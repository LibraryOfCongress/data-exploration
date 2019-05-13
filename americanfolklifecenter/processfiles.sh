#!/bin/bash
# processfiles : options to clean up hidden files, batch rename files, flatten directories, prompt user to split directories by size, create derivatives
# for local use at AFC, created by Annie Schweikert
# code liberally inspired by and borrowed from https://github.com/mediamicroservices/mm/blob/master/ingestfile

SCRIPTNAME=$(basename "${0}")
MAX_CTS_BAGSIZE=250000000000

_usage(){
    echo
    echo "${SCRIPTNAME}"
    echo "This script will provide the option to rename files, collapse and rename directories, and delete hidden files."
    echo "It is to be run before metadata extraction, so that filenames match the metadata logs reportmd.sh generates."
    echo ""
    echo "Usage: ${SCRIPTNAME} /complete/path/to/directoryorbag/"
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
            *.tif|*.tiff|*.dng|*.nef|*.pdf|*.doc|*.docx|*.sgm|*.csv|*.xml)    EXTENSION="IMG"    ;;
            *.mxf)                                                                  EXTENSION="VID"    ;;
            *.wav|*.bwf)                                                            EXTENSION="AUD"    ;;
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
            *.ai|*.bmp|*.cr2|*.cr3|*.csv|*.dng|*.doc|*.docx|*.ind|*.indd|*.jpeg|*.jpg|*.nef|*.orf|*.pages|*.pdf|*.png|*.ppt|*.pptx|*.psd|*.psp|*.sgm|*.tif|*.tiff|*.xls|*.xslx|*.xlt|*.xml|*.xmp|*.zip)  EXTENSION="IMG"    ;;
            *.avi|*.dv|*.f4p|*.f4v|*.flv|*.jp2|*.m4v|*.mkv|*.mov|*.mp2|*.mp4|*.mpe|*.mpeg|*.mpg|*.mpv|*.mxf|*.ogg|*.ogv|*.qt|*.riff|*.rm|*.rmvb|*.vob|*.webm|*.wmv)                                      EXTENSION="VID"    ;;
            *.aac|*.aiff|*.au|*.bwf|*.flac|*.m4a|*.m4b|*.m4p|*.mka|*.mmf|*.mp3|*.mpc|*.ra|*.sln|*.tta|*.wav|*.wma)                                                                                       EXTENSION="AUD"    ;;
            *)                                                                                                                                                                                           EXTENSION="OTHER"  ;;
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
            d) COLOR="${GREEN}" ; LOG_MESSAGE="Y" ;;      # declaration mode, use color green
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
_lookup_renaming(){
    case $"${1}" in
        "Rename files"|"Replace invalid characters"|"Don't rename files") ;;
        "quit") echo "Bye then" ; exit 0 ;;
        *) echo "Error: Not a valid option, select a valid number." ; return 1 ;;
    esac
}

# ============================================================
# query user to determine handling
INPUT="${1}"

_report -q "Please enter the name of the person running the script:"
read -r OPERATOR
echo ""
    
_report -q "Delete .DS_Store and Thumbs.db files?"
_report -q "(These files are created by Mac and Windows computers to control file icon display information. They can cause processing problems between Windows and Mac environments, and their removal does not affect any content.)"
PS3="Select an answer: "
REMOVE_HIDDEN_OPTIONS=("Yes" "No" "quit")
select REMOVE_HIDDEN_CHOICE in "${REMOVE_HIDDEN_OPTIONS[@]}" ; do
    _yes_or_no "${REMOVE_HIDDEN_CHOICE}"
    [[ "${?}" -eq 0 ]] && break
done

_report -q "Rename files?"
_report -q "If you select 'Rename files' you will be prompted for a base filename."
_report -q "If you select 'Replace invalid characters' the following characters will be replaced with an underscore: spaces and (){}[]\|\`\"\'?!<>^*+=;$%&~"
PS3="Select an answer: "
RENAME_OPTIONS=("Rename files" "Replace invalid characters" "Don't rename files" "quit")
select RENAME_CHOICE in "${RENAME_OPTIONS[@]}" ; do
    _lookup_renaming "${RENAME_CHOICE}"
    [[ "${?}" -eq 0 ]] && break
done
if [[ "${RENAME_CHOICE}" == "Rename files" ]] ; then
    echo ""
    _report -q "Files will be renamed with one-up numbers in the following pattern: basename_001, basename_002, ..."
    _report -q "Please enter your file basename:"
    read -r BASENAME
fi

_report -q "Flatten subdirectories into top-level directory?"
_report -q "If all files cannot fit into a single 250 GB directory, script will prompt the operator to make these divisions."
PS3="Select an answer: "
FLATTEN_OPTIONS=("Yes" "No" "quit")
select FLATTEN_CHOICE in "${FLATTEN_OPTIONS[@]}" ; do
	_yes_or_no "${FLATTEN_CHOICE}"
	[[ "${?}" -eq 0 ]] && break
done

_report -q "Generate a checksum log at the end of the script?"
PS3="Select an answer: "
CHECKSUM_OPTIONS=("Yes" "No" "quit")
select CHECKSUM_CHOICE in "${CHECKSUM_OPTIONS[@]}" ; do
    _yes_or_no "${CHECKSUM_CHOICE}"
    [[ "${?}" -eq 0 ]] && break
done
echo ""

# begin while loop for an unknown # of arguments
while [[ "${@}" != "" ]] ; do
    # read user input
    INPUT="${1}"
    shift

    # figure out input and assign variables based on input type
    if [[ -d "${INPUT}" ]] ; then
        # remove slash from end of directory if present
        if [[ $(echo -n "${INPUT}" | tail -c 1) == "/" ]] ; then INPUT="${INPUT%?}" ; else INPUT="${INPUT}" ; fi
        # look for "data" subdirectory; if it's found, the script assumes the directory conforms to bag-it structure
        if [[ -d "${INPUT}/data" ]] ; then PROCESS=BAG ; else PROCESS=DIR ; fi
        if [[ "${PROCESS}" == "BAG" ]] ; then
            echo "${INPUT} conforms to Bag-It structure"
            DATAPATH="${INPUT}/data"
            LOGPATH="${INPUT}"
        elif [[ "${PROCESS}" == "DIR" ]] ; then
            echo "${INPUT} is a directory"
            DATAPATH="${INPUT}"
            LOGPATH="${DATAPATH}/admin"
            mkdir "${LOGPATH}"
        fi
        ERRORLOG="${LOGPATH}/$(basename "${INPUT}")_processfiles_log.txt"
        MD5FILE="${LOGPATH}/manifest-md5_$(date +%Y%m%d).txt"
    else
        _report -w "${INPUT} is not recognized as a directory" ;
        exit 1
    fi

    # set up PREMIS events log and check for existing
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

    # set up tree log after checking for existing trees
    # tree should be a record of the original directory structure
    TREE_LOG="${LOGPATH}/$(basename "${INPUT}")_tree.txt"
    if [[ -f "${TREE_LOG}" ]] ; then
        _report -q "There is already a tree generated at:"
        _report -q "${TREE_LOG}"
        _report -q "Creating new tree at ${LOGPATH}/$(basename "${INPUT}")_tree_$(date +%Y%m%d).txt"
        TREE_LOG="${LOGPATH}/$(basename "${INPUT}")_tree_$(date +%Y%m%d).txt"
    fi

    chmod 644 "${MD5FILE}" "${ERRORLOG}" "${PREMIS_LOG}"
    
    echo ""
    # log operator decisions
    cat <<EOF > "${ERRORLOG}"
    Log for ${SCRIPTNAME}

    Date: $(date +%Y%m%d-%T)
    Operator: ${OPERATOR}
    Input: ${INPUT}
    Input type: ${PROCESS}
    Rename invalid characters?: ${REPLACE_CHARS_CHOICE}
    Delete .DS_Store and Thumbs.db files?: ${REMOVE_HIDDEN_CHOICE}
    Flatten subdirectories? (if not in Bag-It structure): ${FLATTEN_CHOICE}
    Generate checksums?: ${CHECKSUM_CHOICE}
    If yes, checksums stored at: ${MD5FILE}

    Original tree/file summary stored at: ${TREE_LOG}
    Preservation event metadata stored at: ${PREMIS_LOG}

    Script output:
EOF

    echo "============================================================"
    # carry out operations

    # delete hidden files
    if [[ "${REMOVE_HIDDEN_CHOICE}" == "Yes" ]] ; then
        echo "Deleting .DS_Store and Thumbs.db files..."
        find "${DATAPATH}" -type f -name ".DS_Store" -exec echo rm {} \;
        find "${DATAPATH}" -type f -name "Thumbs.db" -exec echo rm {} \;
    fi

    # flag potentially difficult files and print for operator to review
    IRREGULAR_FILES="$(find "${DATAPATH}" ! -type f ! -type d)"
    if [[ -n "${IRREGULAR_FILES}" ]] ; then
        echo ""
        _report -w "Irregular files found! The following files were not recognized as regular files or directories: ${IRREGULAR_FILES}."
        _report -w "The script will process these files, but their content may be inaccessible."
    fi

    # generate tree for original file list (if there is no tree and user wants to create one)
    if [[ ! -f "${TREE_LOG}" ]] ; then
        echo ""
        echo "Generating tree..."
        # generate tree with date of last modification time, size, and with non-printable characters as-is; ignore admin folder
        tree -DNh -I "admin" "${DATAPATH}" | tee "${TREE_LOG}"
        # append summary of file types, sorted alphabetically and counted by extension
        find "${DATAPATH}" -type f -path "${DATAPATH}/admin" -prune -o print0 | sed 's/.*\.//' | sort | uniq -c | tee -a "${TREE_LOG}"
    fi

    # rename files
    if [[ "${RENAME_CHOICE}" == "Rename files" ]] ; then
        i=1
        # find number of files to determine zero padding
        FILECOUNT=$(find "${DATAPATH}" -type f | wc -l)
        if [[ "${FILECOUNT}" -lt 100 ]] ; then
            PADDING="%02d"
        elif [[ "${FILECOUNT}" -lt 1000 ]] ; then
            PADDING="%03d"
        elif [[ "${FILECOUNT}" -lt 10000 ]] ; then
            PADDING="%04d"
        elif [[ "${FILECOUNT}" -lt 100000 ]] ; then
            PADDING="%05d"
        elif [[ "${FILECOUNT}" -lt 1000000 ]] ; then
            PADDING="%06d"
        else
            _report -w "Too many files for script to rename!"
        fi
        while IFS= read -r -d '' file
        do
            # strip file extension (text after period) so file can be renamed
            STRIPPED_FILENAME="${file%.*}"
            FILE_EXTENSION="${file##*.}"
            NUM=$(printf ${PADDING} $i)
            # if file has no extension, it will return the same string for extension and filename; in that case, reassign file extension to be nothing
            if [[ "${STRIPPED_FILENAME}" == "${FILE_EXTENSION}" ]] ; then FILE_EXTENSION="" ; else FILE_EXTENSION=".${FILE_EXTENSION}" ; fi
            NEW_FILENAME="$(dirname ${file})/${BASENAME}_${NUM}${FILE_EXTENSION}"
            mv -iv "${file}" "${NEW_FILENAME}"
            i=$((i+1))
            echo "$(date +%F-%T),${NEW_FILENAME},filename change,Success,${file},${OPERATOR},Filename changed from ${file} to ${NEW_FILENAME}" >> "${PREMIS_LOG}"
        # note that "print0" is the key to interpreting file names with whitespace correctly in the below statement
        # FOR FURTHER CODING: a way to sort the results of "find" (ls doesn't work but "sort" might)
        done <  <(find "${DATAPATH}" -path "${DATAPATH}/admin" -prune -o -type f -print0)
    # rename files with invalid characters
    # this command may break on newline characters in filenames!
    elif [[ "${RENAME_CHOICE}" == "Replace invalid characters" ]] ; then
        echo "Searching for file and directory names with invalid characters..."
        # replace characters with underscores
        while IFS= read -r -d '' file
        do
            # replace characters within brackets [...] with underscores _ -> s/[...]/_/g
            NEWFILE="$(echo "${file}" | sed -e 's/[][(){}<>|?!'\'''\"''\`'^*+=~&;$%'\ ']/_/g')"
            mv -iv "${file}" "${NEWFILE}"
            echo "$(date +%Y%m%d-%T),${NEWFILE},filename change,Success,${file},${OPERATOR},Filename changed from ${file} to ${NEWFILE}" >> "${PREMIS_LOG}"
        done <  <(find "${DATAPATH}" -type f -name "*[\]\[\(\)\{\}\<\>\|\?\!\'\"\`\^\*\+\=\;\$\%\&\~\\\ [:space:]]*" -print0)
    fi

    # check for flatness
    if [[ "${FLATTEN_CHOICE}" == "Yes" ]] ; then
        if (( $(du -s --bytes "${DATAPATH}" | cut -f1) > "${MAX_CTS_BAGSIZE}" )) ; then
            echo ""
            _report -w "Total size of files within ${DATAPATH} is over CTS's maximum bagsize of 250 GB."
            _report -q "Script will create a series of directories of less than 250 GB, beginning with the directory name you supply below and appending 'one-up' numbers at the end of the name."
            _report -q "For example, if your starting directory is 450 GB and you type afc2018001 below, the script will move files to two directories: afc2018001_01 (250 GB) and afc2018001_02 (200 GB)."
            echo ""
            _report -q "Type your bag name below, or type q or Q to quit this process and leave your directories as-is."
            read -r BAGNAME
            if [[ "${BAGNAME}" != [qQ] ]] ; then
                echo ""
                _report -d "Making directories and moving files..."
                # below code based on https://stackoverflow.com/questions/29116212/split-a-folder-into-multiple-subfolders-in-terminal-bash-script
                DIRCOUNT=1  # number of subdirs created
                DIRSIZE=0 # size of subdirs created
                while IFS= read -r -d $'\0' FILENAME
                do
                    # zero pad dircount - 3 digits default because it is unlikely to have more than 999 directories of 250 GB each
                    # whenever directory size is reset to 0, make a new dir:
                    DIRNUMBER=$(printf "%03d" ${DIRCOUNT})
                    if [[ "${DIRSIZE}" -eq 0 ]] ; then
                        NEWDIR="${DATAPATH}/${BAGNAME}_${DIRNUMBER}"
                        mkdir "${NEWDIR}"
                    fi
                    ORIG_FILENAME="$(basename "${FILENAME}")"
                    # note that du defaults to giving sizes in powers of 1024 rather than 1000; 
                    FILESIZE=$(du -s --bytes "${FILENAME}" | cut -f1)
                    DIRSIZE=$(( ${FILESIZE} + ${DIRSIZE} ))
                    # check if directory will go over max CTS bagsize once new file is added
                    if [[ "${DIRSIZE}" -lt "${MAX_CTS_BAGSIZE}" ]] ; then
                        # check if file being moved already exists in new dir:
                        if [[ ! -e "${NEWDIR}/${ORIG_FILENAME}" ]] ; then
                            mv -iv "${FILENAME}" "${NEWDIR}/${ORIG_FILENAME}"
                        else
                            # strip file extension (text after period) so file can be renamed
                            STRIPPED_FILENAME="${ORIG_FILENAME%.*}"
                            FILE_EXTENSION="${ORIG_FILENAME##*.}"
                            EXT_COUNT=1
                            # if file has no extension, it will return the same string for extension and filename; in that case, reassign file extension to be nothing
                            if [[ "${STRIPPED_FILENAME}" == "${FILE_EXTENSION}" ]] ; then FILE_EXTENSION="" ; else FILE_EXTENSION=".${FILE_EXTENSION}" ; fi
                            NEW_FILELOCATION="${NEWDIR}/${STRIPPED_FILENAME}_duplicate_${EXT_COUNT}${FILE_EXTENSION}"
                            while [[ -e "${NEW_FILELOCATION}" ]] ; do
                                EXT_COUNT=$((EXT_COUNT+1))
                                NEW_FILELOCATION="${NEWDIR}/${STRIPPED_FILENAME}_duplicate_${EXT_COUNT}${FILE_EXTENSION}"
                            done
                            mv -iv "${FILENAME}" "${NEW_FILELOCATION}"
                        fi
                    # whenever dirsize counter reaches its maximum, reset it, and increase dir counter:
                    elif [[ "${DIRSIZE}" -ge "${MAX_CTS_BAGSIZE}" ]] ; then
                        DIRCOUNT=$((DIRCOUNT+1))
                        # if a single file is bigger than max bag size, create its own bag
                        if [[ "${FILESIZE}" -ge "${MAX_CTS_BAGSIZE}" ]] ; then
                            NEWDIR="${DATAPATH}/${BAGNAME}_${DIRNUMBER}"
                            echo mkdir "${NEWDIR}"
                            DIRCOUNT=$((DIRCOUNT+1))
                        fi
                        DIRSIZE=0
                    fi
                # find all files besides those in the admin folder
                done < <(find "${DATAPATH}" -path "${DATAPATH}/admin" -prune -o -type f -print0)
                # delete empty directories
                find "${DATAPATH}"  -type d -empty -delete
                _report -d "Directory flattening complete!"
            elif [[ "${BAGNAME}" == [qQ] ]] ; then
                _report -d "Skipping directory flattening..."
            fi
        else
            _report -d "Moving all files to parent directory..."
            while IFS= read -r -d $'\0' FILENAME
            do
                ORIG_FILENAME="$(basename "${FILENAME}")"
                # check if file being moved already exists in new dir:
                if [[ ! -e "${DATAPATH}/${ORIG_FILENAME}" ]] ; then
                    mv -iv "${FILENAME}" "${DATAPATH}/${ORIG_FILENAME}"
                else
                    # strip file extension (text after period) so file can be renamed
                    STRIPPED_FILENAME="${ORIG_FILENAME%.*}"
                    FILE_EXTENSION="${ORIG_FILENAME##*.}"
                    EXT_COUNT=1
                    # if file has no extension, it will return the same string for extension and filename; in that case, reassign file extension to be nothing
                    if [[ "${STRIPPED_FILENAME}" == "${FILE_EXTENSION}" ]] ; then FILE_EXTENSION="" ; else FILE_EXTENSION=".${FILE_EXTENSION}" ; fi
                    NEW_FILENAME="${NEWDIR}/${STRIPPED_FILENAME}_${FILE_EXTENSION}"
                    while [[ -e "${NEW_FILENAME}" ]] ; do
                        EXT_COUNT=$((EXT_COUNT++))
                        NEW_FILENAME="${DATAPATH}/${STRIPPED_FILENAME}_duplicate_${EXT_COUNT}${FILE_EXTENSION}"
                    done
                    mv -iv "${FILENAME}" "${NEW_FILENAME}"
                fi
            done < <(find "${DATAPATH}" -type f -print0)
            # delete empty directories
            find "${DATAPATH}"  -type d -empty -delete
            _report -d "Directory flattening complete!"
        fi
    fi

    # generate checksums
    echo "Generating file checksums..."
    find "${DATAPATH}" -type f -path "${DATAPATH}/admin" -prune -o -exec md5sum {} + > "${MD5FILE}"
    if [[ -s "${MD5FILE}" ]] ; then
        echo "$(date +%Y%m%d-%T),${INPUT},message digest calculation,Success,n/a,${OPERATOR},MD5s calculated for ${DATAPATH} and stored at ${MD5FILE}" >> "${PREMIS_LOG}"
        _report -d "Checksums generated and stored in ${MD5FILE}"
    else
        _report -w "An error occurred with the checksum command. Checksums were not generated."
    fi

    echo "============================================================"
    echo ""
    echo ""
    echo "Summary:"
    if [[ ! -s "${PREMIS_LOG}" ]] || [[ ! -s "${TREE_LOG}" ]]; then
        echo "Not all requested metadata reports completed successfully."
    elif [[ "${CHECKSUM_CHOICE}" == "Yes" ]] && [[ ! -s "${PREMIS_LOG}" ]] ; then
        echo "Not all requested metadata reports completed successfully."
    else
        echo "All requested metadata reports completed successfully."
    fi
    if [[ -f "${ERRORLOG}" ]] ; then
        echo "Check script output ${ERRORLOG} for further error reporting."
    else
        _report -w "Error log was not created."
    fi
done

_report -d "Script has completed."
