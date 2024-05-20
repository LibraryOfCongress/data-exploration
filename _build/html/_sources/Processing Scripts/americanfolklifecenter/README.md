

# americanfolklifecenter


I. About The Scripts

The scripts are the primary outcomes of a 10 week pilot internship program - the Cultural Sustainability internship - conceived and organized by the American Folklife Center’s digital assets specialist in conjunction with the Library’s Internship and Programs Department. 

The program was designed to bridge gaps in the digital preservation pedagogy and curriculum through supporting hands-on collection processing work for graduate students already immersed in digital preservation. A description of the position can be found here: https://www.usajobs.gov/GetJob/ViewDetails/488325200

It also built on the Library’s existing work in this area with its past involvement with the highly successful IMLS sponsored National Digital Stewardship Program (NDSR). More info here: https://ndsr-program.org/about/

More background about the internship pilot and scripts can be found in the Library’s “The Signal” blog post, “Minimal Digital Processing at the American Folklife Center,” written by the Cultural Sustainability intern, Annie Schweikert:
https://blogs.loc.gov/thesignal/2018/12/minimal-digital-processing-at-the-american-folklife-center/

The digital assets specialist hopes to build on this work w/further use cases. These scripts are meant to change as the Library’s other supporting systems and repository development change. The scripts are optimized for AFC’s existing programs, staff, systems, and repository. For a slightly dated overview on AFC’s digital processing more generally, see:
https://blogs.loc.gov/thesignal/2016/06/the-workflow-of-the-american-folklife-center-digital-collections/


II. What’s Included:

Reportmd.sh - In order to encompass as many use cases as possible, 1 script was designed to report out, in the form of csv,  gz,  xml files, as much as could be understood to supplement and/or create technical reports. Reportmd.sh, then, is a baseline minimal processing script. It is meant specially to support the many time-based files (audio and audiovisual) in our collections and does not yet address disk images (which are less frequent) or other categories of collection content. This script does not alter any of the collection files. It’s meant to document processes and collections “as is,” to better track  both potential intentional and unintentional changes in the future. This file can be opened as a text file, but as the “.sh” indicates, it’s written in bash.

Processfiles.sh - This script is only applicable when the digital assets specialist decides the collection, accrual, or accession is a good case for a higher commitment to process the collection more fully by also manipulating and changing files. The changes can include file renaming, deleting of hidden files, grouping directories, and flattening of directory structures. These minimal processing steps bring collections closer to 1) ideally flatter repository ingest packages, avoiding ingest packages that are many directory levels deep  2) smaller, machine readable and normalized “intellectual objects” as ingest packages, which is how we at AFC must organize collections for the Library’s online digital collections display. 

III. How Was It Created?
“The Signal” blog post page cited explains that the script builds on pre-existing workflows and borrows liberally from the scripts maintained and developed at CUNY Television by David Rice, but it is optimized with AFC’s collections, systems, and practices in mind.

IV. Code descriptions

V. Rights Statement
All contributions to AFC processing scripts are free to use and re-use in any way!

VI. Creator and contributor information
Creator: Annie Schweikert
Contributors: Julia Kim

VI. Contact Information
Please direct all questions and comments to juliakim@loc.gov. 


