#!/bin/bash
# reportmd : generates technical metadata reports prior to CTS ingest
# for local use at AFC, created by Annie Schweikert
# code liberally inspired by and borrowed from https://github.com/mediamicroservices/mm/blob/master/ingestfile and https://github.com/amiaopensource/vrecord
# qc thresholds based on stats compiled by BAVC at https://github.com/bavc/qctools-documentation/blob/master/qctools/QCToolsWorkshopCheatSheet.pdf

SCRIPTNAME=$(basename "${0}")
# threshold values for QC statistics @ 10-bit depth
SAT_MAX=472.8 #illegal values=472.8
AUD_MAX=-0.01
BRNG_MAX=0.03
YUV_MAX=1023 #clipping=1023; "high">=960
TOUT_MAX=0.009
# number of frames at or above QC thresholds at which script warns operator
VID_OUTLIER_THRSHLD=10
AUD_OUTLIER_THRSHLD=10
COLOR_THRSHLD=1000

_usage(){
    echo
    echo "${SCRIPTNAME}"
    echo "This script will generate technical metadata reports prior to CTS ingest."
    echo "It is to be run immediately upon receipt of digitized files."
    echo ""
    echo "Usage: ${SCRIPTNAME} /complete/path/to/bag/"
    echo "      or ${SCRIPTNAME} /complete/path/to/directory/"
    echo "      or ${SCRIPTNAME} /complete/path/to/file"
    echo "Note: input does not have to conform to Bag-It specifications."
    echo ""
    echo "  -h (display this help)"
    exit
}

USER_INPUT=${@}
OPTIND=1
while getopts "h" OPT ; do
    case "${OPT}" in
        h) _usage ;;
        *) echo "bad option -${OPTARG}" ; _usage ; exit 1 ;;
    esac
done
shift $(( ${OPTIND} - 1 ))

# local functions
_extract_pres_extension(){
    # only runs reports for files with extensions corresponding to AFC local preservation formats
    if [[ -f "${1}" ]] ; then
        # ${1,,} means to interpret the filename passed by the script, ${1}, as all-lowercase
        case "${1,,}" in
            *.tif|*.tiff|*.dng|*.nef|*.cr2|*.pdf|*.doc|*.docx|*.sgm|*.csv|*.xml)    EXTENSION="IMG"    ;;
            *.mxf)                                                                  EXTENSION="VID"    ;;
            *.wav|*.bwf)                                                            EXTENSION="AUD"    ;;
            *.iso)                                                                  EXTENSION="DISC"   ;;
            *)                                                                      EXTENSION="" ;;
        esac
    elif [[ -d "${1}" ]] ; then
        return
    else
        echo "${1} is not a regular file or directory!"
        [[ "${PROCESS}" == "FILE" ]] && exit 1 # if the input is supposed to be a file but is found to be irregular, exit the script and do not create reports
    fi
}
_extract_all_extension(){
    # runs reports for all files in package
    if [[ -f "${1}" ]] ; then
        # ${1,,} means to interpret the filename passed by the script, ${1}, as all-lowercase
        case "${1,,}" in
            *.ai|*.bmp|*.cr2|*.cr3|*.csv|*.dng|*.doc|*.docx|*.ind|*.indd|*.jpeg|*.jpg|*.nef|*.pages|*.pdf|*.png|*.ppt|*.pptx|*.psd|*.psp|*.sgm|*.tif|*.tiff|*.xls|*.xslx|*.xlt|*.xml|*.xmp|*.zip)  EXTENSION="IMG"    ;;
            *.avi|*.dv|*.f4p|*.f4v|*.flv|*.jp2|*.m4v|*.mkv|*.mov|*.mp2|*.mp4|*.mpe|*.mpeg|*.mpg|*.mpv|*.mxf|*.ogg|*.ogv|*.qt|*.riff|*.rm|*.rmvb|*.vob|*.webm|*.wmv)                                EXTENSION="VID"    ;;
            *.aac|*.aiff|*.au|*.bwf|*.flac|*.m4a|*.m4b|*.m4p|*.mka|*.mmf|*.mp3|*.mpc|*.ra|*.sln|*.tta|*.wav|*.wma)                                                                                 EXTENSION="AUD"    ;;
            *.iso)                                                                                                                                                                                 EXTENSION="DISC"   ;;
            *)                                                                                                                                                                                     EXTENSION="OTHER"  ;;
        esac
    elif [[ -d "${1}" ]] ; then
        return
    else
        echo "${1} is not a regular file or directory!"
        [[ "${PROCESS}" == "FILE" ]] && exit 1 # if the input is supposed to be a file but is found to be irregular, exit the script and do not create reports
    fi
}
_report(){
    local RED="$(tput setaf 1)"   # Red      - For Warnings
    local GREEN="$(tput setaf 2)" # Green    - For Declarations
    local BLUE="$(tput setaf 6)"  # Blue     - For Questions
    local NC="$(tput sgr0)"       # No Color
    local COLOR=""
    local ECHOOPT=""
    OPTIND=1
    while getopts ":qdwn" OPT; do
        case "${OPT}" in
            q) COLOR="${BLUE}" ;;                         # question mode, use color blue
            d) COLOR="${GREEN}" ; LOG_MESSAGE="Y";;       # declaration mode, use color green
            w) COLOR="${RED}" ; LOG_MESSAGE="Y" ;;        # warning mode, use color red
            n) ECHOOPT="-n" ;;                            # to avoid line breaks after echo
            *) echo "Invalid option for _report" ;;
        esac
    done
    shift $(( ${OPTIND} - 1 ))
    MESSAGE="${1}"
    if [[ "${LOG_MESSAGE}" = "Y" ]] ; then
        echo "${ECHOOPT}" "${COLOR}${MESSAGE}${NC}"
        echo "${MESSAGE}" >> "${ERRORLOG}"
    else
        echo "${ECHOOPT}" "${COLOR}${MESSAGE}${NC}"
    fi
}
_yes_or_no(){
    case "${1}" in
        "Yes"|"No") ;;
        "quit") echo "Exiting" ; exit 0 ;;
        *) echo "Error: Not a valid option, select a valid number." ; return 1 ;;
    esac
}
_lookup_reportmd(){
    case $"${1}" in
        "Extract metadata from all files"|"Extract metadata from preservation master files only") ;;
        "quit") echo "Bye then" ; exit 0 ;;
        *) echo "Error: Not a valid option, select a valid number." ; return 1 ;;
    esac
}
_lookup_tree(){
    case $"${1}" in
        "Overwrite existing tree"|"Do not overwrite - create new tree with date stamp in filename"|"Do not create new tree") ;;
        "quit") echo "Bye then" ; exit 0 ;;
        *) echo "Error: Not a valid option, select a valid number." ; return 1 ;;
    esac
}
_frames_to_percent(){
    PERCENT=$(echo "scale=2 ; ${1} / ${FRAMECOUNT} * 100" | bc)
    echo "Percent of total frames: ${PERCENT}%"
}

# ============================================================
# query user to determine handling
    _report -q "Please enter the name of the person running the script:"
    read -r OPERATOR

    _report -q "Do you want to generate a checksum log? (Recommended unless checksums have been recently generated in AFC custody)"
    _report -q "If there is a new existing checksum log at manifest-md5.txt, the new checksum log will be compared with the existing log."
    PS3="Select an answer: "
    CHECKSUM_OPTIONS=("Yes" "No" "quit")
    select CHECKSUM_CHOICE in "${CHECKSUM_OPTIONS[@]}" ; do
        _yes_or_no "${CHECKSUM_CHOICE}"
        [[ "${?}" -eq 0 ]] && break
    done
    echo ""
    
    _report -q "Extract metadata for all files, or just for preservation masters?"
    _report -q "Preservation master formats: .mxf, .wav, .bwf, .tif, .tiff, .pdf, .doc, .docx, .xml, .cr2, .nef, .sgm, csv"
    PS3="Select an answer:"
    REPORTMD_OPTIONS=("Extract metadata from all files" "Extract metadata from preservation master files only" "quit")
    select REPORTMD_CHOICE in "${REPORTMD_OPTIONS[@]}" ; do
        _lookup_reportmd "${REPORTMD_CHOICE}"
        [[ "${?}" -eq 0 ]] && break
    done

    _report -q "Generate QCTools XML for any MXF files and scan results for a summary of potential flags?"
    PS3="Select an answer:"
    QCTOOLS_OPTIONS=("Yes" "No" "quit")
    select QCTOOLS_STATUS in "${QCTOOLS_OPTIONS[@]}" ; do
        _yes_or_no "${QCTOOLS_STATUS}"
        [[ "${?}" -eq 0 ]] && break
    done
    
    _report -q "Delete .DS_Store and Thumbs.db files?"
    _report -q "(These files are created by Mac and Windows computers to control file icon display information. They can cause processing problems between Windows and Mac environments, and their removal does not affect any content, UNLESS they have been included in an existing checksum manifest.)"
    PS3="Select an answer: "
    REMOVE_HIDDEN_OPTIONS=("Yes" "No" "quit")
    select REMOVE_HIDDEN_CHOICE in "${REMOVE_HIDDEN_OPTIONS[@]}" ; do
        _yes_or_no "${REMOVE_HIDDEN_CHOICE}"
        [[ "${?}" -eq 0 ]] && break
    done
    
# begin while loop for an unknown # of arguments
while [[ "${@}" != "" ]] ; do
    INPUT="${1}"
    shift

    # figure out input and assign variables based on input type
    if [[ -f "${INPUT}" ]] ; then
        echo "${INPUT} is a file."
        PROCESS=FILE
        DATAPATH="$(dirname "${INPUT}")"
        LOGPATH="$(dirname "${INPUT}")"
        ERRORLOG="${LOGPATH}/$(basename "${INPUT}")_reportmdlog.txt"
        MD5FILE="${INPUT}.md5" # MD5 file at same directory level
        _extract_all_extension "${INPUT}"
    elif [[ -d "${INPUT}" ]] ; then
        # remove slash from end of directory if present
        if [[ $(echo -n "${INPUT}" | tail -c 1) == "/" ]] ; then INPUT="${INPUT%?}" ; else INPUT="${INPUT}" ; fi
        # look for "data" subdirectory; if it's found, the script assumes the directory conforms to bag-it structure
        if [[ -d "${INPUT}/data" ]] ; then PROCESS="BAG" ; else PROCESS="DIR" ; fi
        if [[ "${PROCESS}" == "BAG" ]] ; then
            echo "${INPUT} conforms to Bag-It structure."
            DATAPATH="${INPUT}/data"
            LOGPATH="${INPUT}"
        elif [[ "${PROCESS}" == "DIR" ]] ; then
            echo "${INPUT} is a directory."
            DATAPATH="${INPUT}"
            LOGPATH="${DATAPATH}/admin"
            mkdir "${LOGPATH}"
        fi
        ERRORLOG="${LOGPATH}/$(basename "${INPUT}")_reportmdlog.txt"
        MD5FILE="${LOGPATH}/manifest-md5_$(date +%Y%m%d).txt"
    else
        _report -w "${INPUT} is not recognized as a file or directory" ;
        exit 1
    fi
    touch "${MD5FILE}" "${ERRORLOG}"

    # set up PREMIS events log
    echo ""
    PREMIS_LOG="${LOGPATH}/$(basename "${INPUT}")_premisevents.csv"
    if [[ -f "${PREMIS_LOG}" ]] ; then
        echo ""
        _report -q "There is a preservation events log set up at:"
        _report -q "${PREMIS_LOG}"
        _report -q "Appending to the existing preservation events events log."
    elif [[ ! -f "${PREMIS_LOG}" ]] ; then
        _report -d "Creating preservation events log at ${PREMIS_LOG}..."
        touch "${PREMIS_LOG}"
        echo "Date (YYYY-MM-DD),File or directory name,Event,Event outcome,Related filename (optional),Operator,Notes" > "${PREMIS_LOG}"
    fi

    echo ""
    # log operator decisions
    cat <<EOF > "${ERRORLOG}"
    Log for ${SCRIPTNAME}

    Date: $(date +%Y%m%d-%T)
    Operator: ${OPERATOR}
    Input: ${INPUT}
    Input type: ${PROCESS}
    Reporting choice: ${REPORTMD_CHOICE}
    Generate QCTools XML for video files?: ${QCTOOLS_STATUS}

    Checksums stored at: ${MD5FILE}
    Preservation event metadata stored at: ${PREMIS_LOG}
    Original tree/file summary stored at: ${TREE_LOG}

    Script output:
EOF

    chmod 644 "${MD5FILE}" "${ERRORLOG}" "${PREMIS_LOG}"

    echo "============================================================"
    # flag potentially difficult files and print for operator to review

    # delete .DS_Store and Thumbs.db files
    if [[ "${REMOVE_HIDDEN_CHOICE}" == "Yes" ]] ; then
        echo "Deleting .DS_Store and Thumbs.db files..."
        find "${DATAPATH}" -type f -name ".DS_Store" -exec echo rm {} \;
        find "${DATAPATH}" -type f -name "Thumbs.db" -exec echo rm {} \;
    fi
    
    # look for any not regular files or directories
    IRREGULAR_FILES="$(find "${DATAPATH}" ! -type f ! -type d)"
    [[ -n "${IRREGULAR_FILES}" ]] && _report -w "Invalid files found! Script will not report on the following invalid files: ${IRREGULAR_FILES}."

    # flag hidden files
    if [[ "${PROCESS}" != "FILE" ]] ; then
        echo "Searching for hidden files and directories..."
        HIDDEN_FILES=$(ls -d .?* "${DATAPATH}")
        if [[ -z "${HIDDEN_FILES}" ]] ; then
            _report -w "Hidden files or directories found! This script will ignore the following objects:"
            _report -w "${HIDDEN_FILES[@]}"
            _report -d "Consider deleting or renaming any files or directories from which you want to extract metadata."
        else
            _report -d "No hidden files or directories found."
        fi
    fi

    # flag files and dirs with invalid characters
    echo "Searching for file and directory names with invalid characters..."
    if [[ "${PROCESS}" == "FILE" ]] ; then
        INVALID_CHARS=$(find "${INPUT}" -name "*[\+\{\}\;\"\'\\\=\?\!~\(\)\<\>\&\*\|\$\%\ ]*")
    else
        INVALID_CHARS=$(find "${DATAPATH}" -type f -name "*[\+\{\}\;\"\'\\\=\?\!~\(\)\<\>\&\*\|\$\%\ ]*")
    fi
    if [[ -n "${INVALID_CHARS}" ]] ; then
        _report -w "Invalid characters found! Consider renaming these files or directories:"
        _report -w "${INVALID_CHARS[@]}"
        _report -d "(Script will still attempt to run reports for each of the above files.)"
    else
        _report -d "No invalid characters found."
    fi

    echo "============================================================"
    # fixity: log initial fixity and structure

    # checksum all non-hidden files in the directory; store in checksum file
    if [[ "${CHECKSUM_CHOICE}" == "No" ]] ; then
        _report -d "Skipping checksum generation."
    elif [[ "${CHECKSUM_CHOICE}" == "Yes" ]] ; then
        echo "Generating file checksums..."
        if [[ "${PROCESS}" == "FILE" ]] ; then
            md5sum "${INPUT}" | tee "${MD5FILE}"
        else
#            [[ "${PROCESS}" == "BAG" ]] && find "${DATAPATH}" -exec md5sum {} + > "${MD5FILE}"
            find "${DATAPATH}" -path "${DATAPATH}/admin" -prune -o -exec md5sum {} + > "${MD5FILE}"
        fi
        if [[ -s "${MD5FILE}" ]] ; then
            echo "$(date +%Y%m%d-%T),${INPUT},message digest calculation,Success,n/a,${OPERATOR},MD5s calculated for ${DATAPATH} and stored at ${MD5FILE}" >> "${PREMIS_LOG}"
            _report -d "Checksums generated and stored in ${MD5FILE}"
            # if there is already a checksum file that conforms to the Bag-It spec location, then verify those checksums against the checksum manifest we just created
            if [[ "${PROCESS}" == "BAG" ]] && [[ -f "${LOGPATH}/manifest-md5.txt" ]] ; then
                echo "Comparing new checksums with manifest-md5.txt..."
                sort "${MD5FILE}" > ""${MD5FILE}"_sorted.temp"
                sort "${LOGPATH}/manifest-md5.txt" | diff --ignore-all-space - "${MD5FILE}_sorted.temp"
                if [[ $? -eq 0 ]] ; then
                    _report -d "All checksums match manifest-md5.txt."
                    echo "$(date +%Y%m%d-%T),${DATAPATH},fixity check,Success,n/a,${OPERATOR},MD5s created in ${MD5FILE} compared to existing MD5s at ${LOGPATH}/manifest-md5.txt for each file in ${DATAPATH}" >> "${PREMIS_LOG}"
                elif [[ $? -eq 1 ]] ; then
                    _report -w "Not all checksums match. Please compare ${MD5FILE} and ${LOGPATH}/manifest-md5.txt for more information."
                    _report -w "Consider updating the PREMIS events log at ${PREMIS_LOG} with an explanation of the mismatch."
                    echo "$(date +%Y%m%d-%T),${DATAPATH},fixity check,Failure,n/a,${OPERATOR},MD5s created in ${MD5FILE} compared to existing MD5s at ${LOGPATH}/manifest-md5.txt for each file in ${DATAPATH}" >> "${PREMIS_LOG}"
                else
                    _report -w "An error occurred with the diff command. Checksums were not compared."
                fi
                rm ""${MD5FILE}"_sorted.temp"
            fi
        else
            _report -w "An error occurred with the checksum command. Checksums were not generated."
        fi
    fi

    # generate tree and file count by extension
    # tree should be a record of the original directory structure
    if [[ "${PROCESS}" != "FILE" ]] ; then
        echo ""
        TREE_LOG="${LOGPATH}/$(basename "${INPUT}")_tree.txt"
        if [[ -f "${TREE_LOG}" ]] ; then
            _report -q "There is already a tree generated at:"
            _report -q "${TREE_LOG}"
            _report -q "Do you want to create a new tree and overwrite the existing tree?"
            PS3="Select an answer: "
            TREE_OPTIONS=("Overwrite existing tree" "Do not overwrite - create new tree with date stamp in filename" "Do not create new tree" "quit")
            select TREE_STATUS in "${TREE_OPTIONS[@]}" ; do
                _lookup_tree "${TREE_STATUS}"
                [[ "${?}" -eq 0 ]] && break
            done
            # assign new tree filename if requested so as not to overwrite
            if [[ "${TREE_STATUS}" == "Do not overwrite - create new tree with date stamp in filename" ]] ; then
                TREE_LOG="${LOGPATH}/$(basename "${INPUT}")_tree_$(date +%Y%m%d).txt"
            fi
        fi
        # generate tree with date of last modification time, size, and with non-printable characters as-is; ignore admin folder
        if [[ ! -f "${TREE_LOG}" ]] || [[ "${TREE_STATUS}" != "Do not create new tree" ]] ; then
            echo "Generating tree..."
            # generate tree with date of last modification time, size, and with non-printable characters as-is; ignore admin folder
            tree -DNh -I "admin" "${DATAPATH}" | tee "${TREE_LOG}"
            # append summary of file types, sorted and counted by extension
            [[ "${PROCESS}" == "BAG" ]] && find "${DATAPATH}" -type f | sed 's/.*\.//' | sort | uniq -c | tee -a "${TREE_LOG}"
            [[ "${PROCESS}" == "DIR" ]] && find "${DATAPATH}" -type f -path "${LOGPATH}" -prune -o print0 | sed 's/.*\.//' | sort | uniq -c | tee -a "${TREE_LOG}"
        fi
    fi

    # ============================================================
    # conformance: run MediaConch or JHOVE policies on preservation files
    ###### needs proper JHOVE installation + MediaConch policies


    echo "============================================================"
    # qctools process
    if [[ "${QCTOOLS_STATUS}" == "No" ]] ; then
        _report -d "Not generating QCTools XMLs."
    elif [[ "${QCTOOLS_STATUS}" == "Yes" ]] ; then
        # set up qcwarning function
        # in future, could be called from same script directory as a separate script
        _qcwarning(){
            QCXML="${LOGPATH}/$(basename "${1}").qctools.xml.gz"
            if [[ -f "${QCXML}" ]] ; then
                _report -w "QCTools XML already exists for video file ${1}."
                _report -w "To overwrite existing QCTools XML, enter Y. To cancel, enter any other letter."
                read -r OVERWRITE_RESPONSE
                if [[ "${OVERWRITE_RESPONSE}" = [Yy] ]] ; then
                    _report -d "Overwriting existing QCTools XML..."
                else
                    _report -d "Skipping QCTools XML process..."
                fi
            fi
            if [[ ! -f "${QCXML}" ]] || [[ "${OVERWRITE_RESPONSE}" = [Yy] ]] ; then
                _report -d "Generating QCTools XML at ${QCXML}..."
                # check if codec is JPEG2000; if codec is JPEG2000, transcode to .nut for handling. Note that this will not work unless ffmpeg is installed with --enable-libopenjpeg
                CODEC="$(ffprobe -v error -select_streams v:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 ${1})"
                if [[ "${CODEC}" == "jpeg2000" ]] ; then
                    J2K_FILE="${1}.temp.nut"
                    ffmpeg -vsync 0 -i "${1}" -vcodec rawvideo -acodec pcm_s24le -vf tinterlace=mode=merge,setfield=bff -vcodec libopenjpeg -vf tinterlace=mode=merge,setfield=bff -f nut -y "${J2K_FILE}"
                # create QCTools report
                    ffprobe -f lavfi -i "movie=${J2K_FILE}:s=v+a[in0][in1],[in0]signalstats=stat=tout+vrep+brng,idet=half_life=1,split[a][b];[a]field=top[a1];[b]field=bottom,split[b1][b2];[a1][b1]psnr[c1];[c1][b2]ssim[out0];[in1]ebur128=metadata=1,astats=metadata=1:reset=1:length=0.4[out1]" -show_frames -show_versions -of xml=x=1:q=1 -noprivate | gzip > "${QCXML}"
                else
                    ffprobe -f lavfi -i "movie=${1}:s=v+a[in0][in1],[in0]signalstats=stat=tout+vrep+brng,idet=half_life=1,split[a][b];[a]field=top[a1];[b]field=bottom,split[b1][b2];[a1][b1]psnr[c1];[c1][b2]ssim[out0];[in1]ebur128=metadata=1,astats=metadata=1:reset=1:length=0.4[out1]" -show_frames -show_versions -of xml=x=1:q=1 -noprivate | gzip > "${QCXML}"
                fi
            
                _report -d "Analyzing video file ${1} for outliers..."
                # parse QCXML for frame-by-frame outliers
                if [[ -s "${QCXML}" ]] ; then
                    FRAMECOUNT=$(zcat "${QCXML}" | grep -c 'frame media_type="video"')
                    SAT_OUTLIERS=$(zcat "${QCXML}" | perl -nle 'print if not m{lavfi.(?!signalstats.SATMAX)}' | xmlstarlet sel -t -v "count(//tag[@key='lavfi.signalstats.SATMAX'][@value>$SAT_MAX])" -n)
                    AUD_OUTLIERS=$(zcat "${QCXML}" | perl -nle 'print if not m{lavfi.(?!astats.Overall.Peak_level)}' | grep -v "tag key=\"lavfi.[^a]" | xmlstarlet sel -t -v "count(//tag[@key='lavfi.astats.Overall.Peak_level'][@value>=$AUD_MAX])" -n)
                    BRNG_OUTLIERS=$(zcat "${QCXML}" | perl -nle 'print if not m{lavfi.(?!signalstats.BRNG)}' | xmlstarlet sel -t -v "count(//tag[@key='lavfi.signalstats.BRNG'][@value>=$BRNG_MAX])" -n)
                    Y_CHANNEL_OUTLIERS=$(zcat "${QCXML}" | perl -nle 'print if not m{lavfi.(?!signalstats.YMAX)}' | xmlstarlet sel -t -v "count(//tag[@key='lavfi.signalstats.YMAX'][@value>=$YUV_MAX])" -n)
                    U_CHANNEL_OUTLIERS=$(zcat "${QCXML}" | perl -nle 'print if not m{lavfi.(?!signalstats.UMAX)}' | xmlstarlet sel -t -v "count(//tag[@key='lavfi.signalstats.UMAX'][@value>=$YUV_MAX])" -n)
                    V_CHANNEL_OUTLIERS=$(zcat "${QCXML}" | perl -nle 'print if not m{lavfi.(?!signalstats.VMAX)}' | xmlstarlet sel -t -v "count(//tag[@key='lavfi.signalstats.VMAX'][@value>=$YUV_MAX])" -n)
                    TEMPORAL_OUTLIERS=$(zcat "${QCXML}" | perl -nle 'print if not m{lavfi.(?!signalstats.TOUT)}' | xmlstarlet sel -t -v "count(//tag[@key='lavfi.signalstats.TOUT'][@value>=$TOUT_MAX])" -n)
                else
                    _report -w "QCTools XML ${QCXML} is empty or does not exist!"
                fi

                # warn operator of excessive outliers
                echo "Total frames: ${FRAMECOUNT}"
                if [[ "${SAT_OUTLIERS}" -gt "${COLOR_THRSHLD}" ]] ; then
                    _report -w "WARNING: Video file ${1} contains ${SAT_OUTLIERS} frames with illegal saturation values (threshold=${COLOR_THRSHLD})."
                    _report -w "$(_frames_to_percent ${SAT_OUTLIERS})"
                fi
                if [[ "${Y_CHANNEL_OUTLIERS}" -gt "${COLOR_THRSHLD}" ]] ; then
                    _report -w "WARNING: Video file ${1} contains ${Y_CHANNEL_OUTLIERS} frames with clipped Y channel values (threshold=${COLOR_THRSHLD})."
                    _report -w "$(_frames_to_percent ${Y_CHANNEL_OUTLIERS})"
                fi
                if [[ "${U_CHANNEL_OUTLIERS}" -gt "${COLOR_THRSHLD}" ]] ; then
                    _report -w "WARNING: Video file ${1} contains ${U_CHANNEL_OUTLIERS} frames with clipped U channel values (threshold=${COLOR_THRSHLD})."
                    _report -w "$(_frames_to_percent ${U_CHANNEL_OUTLIERS})"
                fi
                if [[ "${V_CHANNEL_OUTLIERS}" -gt "${COLOR_THRSHLD}" ]] ; then
                    _report -w "WARNING: Video file ${1} contains ${V_CHANNEL_OUTLIERS} frames with clipped V channel values (threshold=${COLOR_THRSHLD})."
                    _report -w "$(_frames_to_percent ${V_CHANNEL_OUTLIERS})"
                fi
                if [[ "${TEMPORAL_OUTLIERS}" -gt "${VID_OUTLIER_THRSHLD}" ]] ; then
                    _report -w "WARNING: Video file ${1} contains ${TEMPORAL_OUTLIERS} frames with temporal outliers (anomalies detected between frames) (threshold=${VID_OUTLIER_THRSHLD})."
                    _report -w "$(_frames_to_percent ${TEMPORAL_OUTLIERS})"
                fi
                if [[ "${AUD_OUTLIERS}" -gt "${AUD_OUTLIER_THRSHLD}" ]] ; then
                    _report -w "WARNING: Video file ${1} contains ${AUD_OUTLIERS} frames with clipped audio levels (threshold=${AUD_OUTLIER_THRSHLD})."
                    _report -w "$(_frames_to_percent ${AUD_OUTLIERS})"
                fi
                if [[ "${BRNG_OUTLIERS}" -gt "${COLOR_THRSHLD}" ]] ; then
                    _report -w "WARNING: Video file ${1} contains ${BRNG_OUTLIERS} frames with pixels out of broadcast range (threshold=${COLOR_THRSHLD})."
                    _report -w "$(_frames_to_percent ${BRNG_OUTLIERS})"
                fi
                _report -d "QCTools analysis is complete for ${1}!"
            fi
        }
        # do qcwarning process for preservation video files
        QCXML_ERRORS=0
        if [[ "${PROCESS}" == "FILE" ]] && [[ "${INPUT,,}" == *.mxf ]] ; then
            _qcwarning "${INPUT}"
            [[ ! -s "${QCXML}" ]] && QCXML_ERRORS=1
        elif [[ "${PROCESS}" == "DIR" || "${PROCESS}" == "BAG" ]] ; then
            while IFS= read -r -d '' file
            do
                _qcwarning "${file}"
                if [[ ! -s "${QCXML}" ]] ; then
                    ((QCXML_ERRORS++))
                    QCXML_ERRORFILES+="${file} "
                fi
            done <  <(find "${DATAPATH}" -iname "*.mxf" -print0)
        fi
        if [[ "${QCXML_ERRORS}" -eq 0 ]] && [[ -s "${QCXML}" ]] ; then
            echo "$(date +%Y%m%d-%T),${INPUT},metadata extraction,Success,n/a,${OPERATOR},QCTools XML created at ${QCXML}" >> "${PREMIS_LOG}"
            _report -d "QCTools XML and log of outlier values created for all MXF files."
        elif [[ "${QCXML_ERRORS}" -gt 0 ]] ; then
            _report -w "An error occurred. QCTools XML creation and outlier check did not complete for all files."
            [[ -z "${QCXML_ERRORFILES}" ]] && _report -w "Problem files: ${QCXML_ERRORFILES[@]}"
        fi
    fi

    echo "============================================================"
    echo "Generating other technical metadata reports..."
    # generate MediaTrace XML for video and audio files
    MEDIATRACE_LOG_ERRORS=0
    if [[ "${PROCESS}" == "FILE" ]] && [[ "${EXTENSION}" = "VID" || "${EXTENSION}" = "AUD" ]] ; then
        MEDIATRACE_LOG="${LOGPATH}/$(basename "${INPUT}")_mediatrace.xml"
        mediaconch -mt -fx "${INPUT}" > "${MEDIATRACE_LOG}"
        [[ ! -s "${MEDIATRACE_LOG}" ]] && MEDIATRACE_LOG_ERRORS=1
    elif [[ "${PROCESS}" == "DIR" || "${PROCESS}" == "BAG" ]] ; then
        while IFS= read -r -d '' file
        do
            MEDIATRACE_LOG="${LOGPATH}/$(basename "${file}")_mediatrace.xml"
            mediaconch -mt -fx "${file}" > "${MEDIATRACE_LOG}"
            if [[ ! -s "${MEDIATRACE_LOG}" ]] ; then
                ((MEDIATRACE_LOG_ERRORS++))
                MEDIATRACE_LOG_ERRORFILES+="${file} "
            fi
        done <  <(find "${DATAPATH}" \( -iname "*.mxf" -o -iname "*.wav" -o -iname "*.bwf" \) -print0)
    fi
    # check if there were no errors in log creation AND that at least one log was created; if neither, there were no A/V files in the directory
    if [[ "${MEDIATRACE_LOG_ERRORS}" == 0 ]] && [[ -f "${MEDIATRACE_LOG}" ]] ; then
        _report -d "Success: MediaTrace XMLs created for A/V files."
        echo "$(date +%Y%m%d-%T),${INPUT},metadata extraction,Success,n/a,${OPERATOR},MediaTrace XML created for A/V files in ${INPUT} and stored in ${LOGPATH}" >> "${PREMIS_LOG}"
    elif [[ "${MEDIATRACE_LOG_ERRORS}" -gt 0 ]] ; then
        _report -w "An error occurred. MediaTrace XML not created for the following files: ${MEDIATRACE_LOG_ERRORFILES[@]}"
    fi

    # generate MediaInfo report for video and audio files
    MEDIAINFO_LOG_ERRORS=0
    if [[ "${PROCESS}" == "FILE" ]] && [[ "${EXTENSION}" = "VID" || "${EXTENSION}" = "AUD" ]] ; then
        MEDIAINFO_LOG="${LOGPATH}/$(basename "${INPUT}")_mediainfo.xml"
        mediaconch -mi -fx "${INPUT}" > "${MEDIAINFO_LOG}"
        [[ ! -s "${MEDIAINFO_LOG}" ]] && MEDIAINFO_LOG_ERRORS=1
    elif [[ "${PROCESS}" == "DIR" || "${PROCESS}" == "BAG" ]] ; then
        while IFS= read -r -d '' file
        do
            if [[ "${REPORTMD_CHOICE}" == "Extract metadata from all files" ]] ; then
                _extract_all_extension "${file}"
            elif [[ "${REPORTMD_CHOICE}" == "Extract metadata from preservation master files only" ]] ; then
                _extract_pres_extension "${file}"
            fi
            if [[ "${EXTENSION}" = "VID" || "${EXTENSION}" = "AUD" ]] ; then
                MEDIAINFO_LOG="${LOGPATH}/$(basename "${file}")_mediainfo.xml"
                mediaconch -mi -fx "${file}" > "${MEDIAINFO_LOG}"
                if [[ ! -s "${MEDIAINFO_LOG}" ]] ; then
                    ((MEDIAINFO_LOG_ERRORS++))
                    MEDIAINFO_LOG_ERRORFILES+="${file} "
                fi
            fi
        done <  <(find "${DATAPATH}" -print0)
    fi
    # check if there were no errors in log creation AND that at least one log was created; if neither, there were no A/V files in the directory
    if [[ "${MEDIAINFO_LOG_ERRORS}" == 0 ]] && [[ -f "${MEDIAINFO_LOG}" ]] ; then
        _report -d "Success: MediaInfo XMLs created for A/V files."
        echo "$(date +%Y%m%d-%T),${INPUT},metadata extraction,Success,n/a,${OPERATOR},MediaInfo XMLs created for A/V files in ${INPUT} and stored in ${LOGPATH}" >> "${PREMIS_LOG}"
    elif [[ "${MEDIAINFO_LOG_ERRORS}" -gt 0 ]] ; then
        _report -w "An error occurred. MediaInfo XML not created for the following files: ${MEDIAINFO_LOG_ERRORFILES[@]}"
    fi

    # generate joint ExifTool report for all preservation image and text files
    EXIFTOOL_LOG_ERRORS=0
    EXIFTOOL_LOG="${LOGPATH}/$(basename "${INPUT}")_exiftool.csv"
    chmod 644 "${EXIFTOOL_LOG}"
    if [[ "${PROCESS}" == "FILE" ]] && [[ "${EXTENSION}" = "IMG" || "${EXTENSION}" = "OTHER" ]] ; then
        /opt/exiftool/exiftool -csv "${INPUT}" > "${EXIFTOOL_LOG}"
        [[ ! -s "${EXIFTOOL_LOG}" ]] && EXIFTOOL_LOG_ERRORS=1
    elif [[ "${PROCESS}" == "DIR" || "${PROCESS}" == "BAG" ]] ; then
        /opt/exiftool/exiftool -csv -r "${DATAPATH}" > "${EXIFTOOL_LOG}"
        if [[ "${?}" -ne 0 ]] ; then
            EXIFTOOL_LOG_ERRORS=1
        fi
    fi
    if [[ -s "${EXIFTOOL_LOG}" ]] && [[ "${EXIFTOOL_LOG_ERRORS}" == 0 ]] ; then
        _report -d "ExifTool CSV created at ${EXIFTOOL_LOG}"
        echo "$(date +%Y%m%d-%T),${INPUT},metadata extraction,Success,n/a,${OPERATOR},ExifTool CSV created for preservation image/text files in ${INPUT} and stored in ${LOGPATH}" >> "${PREMIS_LOG}"
    elif [[ "${EXIFTOOL_LOG_ERRORS}" -ne 0 ]] ; then
        _report -w "An error occurred in the ExifTool application. Consider retrying the exiftool command."
    fi

    echo "============================================================"
    echo ""
    echo ""
    echo "Summary:"
    [[ -n "${INVALID_FILES}" ]] && echo "Script did not report on the following invalid files: ${INVALID_FILES[@]}."
    [[ -n "${HIDDEN_FILES}" ]] && echo "Script did not report on the following hidden files: ${HIDDEN_FILES}[@]"
    [[ -n "${INVALID_CHARS}" ]] && echo "There were files with invalid characters. The script did report metadata for these files."
    if [[ ! -s "${MD5FILE}" ]] || [[ "${EXIFTOOL_LOG_ERRORS}" -gt 0 || "${MEDIAINFO_LOG_ERRORS}" -gt 0 || "${MEDIATRACE_LOG_ERRORS}" -gt 0 || "${QCXML_ERRORS}" -gt 0 ]] ; then
        echo "Not all requested metadata reports completed successfully."
    else
        echo "All requested metadata reports completed successfully."
    fi
    if [[ -f "${ERRORLOG}" ]] ; then
        echo "Check script output ${ERRORLOG} for further details on any of the above messages."
    else
        _report -w "Error log was not created."
    fi
    _report -d "Script has completed."
done
