

Just a few initial seed ideas for projects, if you don't have your own 


 



* Go to data.labs.loc.gov and just browse the various[ Exploratory Data Packages](https://data.labs.loc.gov/packages/) that are available, read through the documentation, take a look at the visualizations, and see if anything piques your interest 
* Run through some of the[ Jupyter Notebook Tutorials for Data Exploration](https://libraryofcongress.github.io/data-exploration/intro.html) to get a sense of what's possible 
* Get together with others at a table and create your own bite-sized ideas based on particular research questions, collections, or technical capabilities that interest you. Share it with LC staff (we'd definitely be interested!) 

--- 
 

* Piping LC data packages into a database tool like Datasette for SQL-like querying and exploratory visualization 
    * [Datasette](https://datasette.io/) 
    * [Minimal example with sample data on Glitch](https://third-boiling-system.glitch.me/data/sample-data_metadata) 
* Looking at pre-prepped OCR, and detecting bad pages 
    * Detect unusable OCR 
* Color detection in Sanborn maps to extract material types 
    * Maybe it's possible to update pieces of this code, which includes color detection for material types, among other things:[ https://github.com/nypl-spacetime/building-inspector](https://github.com/nypl-spacetime/building-inspector) 
* Mappable collections: 
    * The[ Sanborn Maps Data Package](https://data.labs.loc.gov/sanborn/)<span style="text-decoration:underline;"> </span>comes with an easy-to-download CSV of metadata, including estimated latitudes and longitudes for each Sanborn atlas. This data is perfect for loading into map interfaces to experiment with representing the collection spatially.  
    * [Stereograph Card Images Data Package](https://data.labs.loc.gov/stereographs/) 
    * [Historic American Buildings Survey/Historic American Engineering Record/Historic American Landscapes Survey (HABs/HAER/HALS)](https://www.loc.gov/pictures/collection/hh/)  
        * (~10% of those have coordinates on them; fair proportion have wikidata IDs) 
        * Throw HABs/HAER/HALS into an LLM with a proposed schema, and see if it can pull out location data from the item titles? 
            * Inspired by:[ https://simonwillison.net/2024/Jul/14/pycon/#pycon-2024.051.jpeg](https://simonwillison.net/2024/Jul/14/pycon/#pycon-2024.051.jpeg) 
* Geocoding off of place names in MARC records 
    * [MARC records](https://www.loc.gov/cds/products/marcDist.php) - bibliographic information for most of the Library’s collections. 25 million records are available for exploration in UTF-8, MARC8, and XML formats. 
    * [Sample MARC data set](https://labs.loc.gov/static/labs/events/images/hack-to-learn-MARCSample.tar.gz) and[ ReadMe file](https://labs.loc.gov/static/labs/lc-for-robots/images/readme-marc.txt) 
    * Could this potentially at least flag errors, or likely errors? 
* A georeferencing tool like Allmaps for the Sanborns, or other Fire Insurance maps 
    * [Allmaps](https://allmaps.org/), a georeferencing tool for IIIF-enabled maps 
    * [Sanborn Maps Data Package](https://data.labs.loc.gov/sanborn/) 
    * [Sanborn Atlas Volume Finder](https://guides.loc.gov/fire-insurance-maps/sanborn-atlas-volume-finder)  
* Prints and Photographs materials and object detection  
    * Recent LC Labs intern project on object detection:[ https://github.com/beefoo/lclabs-jfp24](https://github.com/beefoo/lclabs-jfp24)  
* Historic American Buildings Survey/Historic American Engineering Record/Historic American Landscapes Survey 
    * One of the most popular collections at the Library, this collection is affectionately known as HABS/HAER/HALS. The collection includes the records of three National Park Survey surveys that document achievements in architecture, engineering, and landscape design. A common request is to view a map of the survey locations, but the titles (which have the most precise location information) are difficult to work with using traditional geocoders. Large language models (LLMs) potentially offer a new route for geocoding and mapping this collection. If you're interested in this challenge, let us know! We have a spreadsheet of data from the collection, including the titles of each survey. We've also pulled coordinates from Wikidata, which has crowdsourced locations for a small proportion of the collection.  
* By the People transcription datasets – asking LLMs to work with those paper datasets 
    * By the People is the Library's public crowdsourced transcription program. For all completed campaigns, the transcribed text has been made available as easily-downloadable datasets on loc.gov:[ By the People completed transcriptions datasets](https://www.loc.gov/collections/selected-datasets/?fa=contributor:by+the+people+%28program%29). The text is ideal for various text analysis tasks including topic modeling, parsing and summarizing using large language models, and named entity recognition. You can find out more about the campaigns here:[ Campaign information.](https://crowd.loc.gov/campaigns/completed/) 
* Clustering the text of XML finding aids using sentence transformers 
    * The Library currently has 3,139 archival collections described in EAD-XML finding aids, at[ https://findingaids.loc.gov/](https://findingaids.loc.gov/). Try your hand at analyzing the full text of the finding aids. You can use sentence transformers for topic modeling, or try out large language models for generating summaries and topic terms. Tell us if you're interested, and we can give you the full set of XML documents, full text extracted from the Container Lists, and a CSV of various subject fields plus collection-level narrative fields like Abstract, Scope and Contents, and Biographical/Historical notes.  
* Historical federal powerpoints:  
    * [https://labs.loc.gov/work/experiments/webarchive-datasets/](https://labs.loc.gov/work/experiments/webarchive-datasets/)  
    * Remember PowerPoints from the 90s and early 2000s? We do! Our Web Archive collections include thousands of PowerPoint slides archived from websites going back to the late 1990s. At[ data.labs.loc.gov/dot-gov/](https://data.labs.loc.gov/dot-gov/), you'll find a data package that contains 1,000 PowerPoints randomly sampled from .gov United States government websites archived between 1996 and 2017. The PowerPoints are available at[ powerpoint_data.zip](https://data.labs.loc.gov/dot-gov/powerpoint_data.zip) (3.2 GB) and include basic metadata about the files including embedded tiles, timestamps, and more. Try analyzing the text in the slides, extracting the images for image analysis, or just have some fun visualizing.  
* Work with US Copyright Office bulk data:  
    * [https://data.copyright.gov/index.html](https://data.copyright.gov/index.html)  
    * This probably requires help to work with and explain how the data is structured, but if you're interested let us know and we can definitely help!  
* Explore the Children's Literature, Philosophy, or Local History Collections  
    * The General Collections Assessment is an ongoing program to assess the Library's approximately 22 million books, bound serials and other materials classified under the General Collections. As part of this project, the Library is making available for exploration the underlying bibliographic datasets used as the primary data sources for the collection assessments.[ https://data.labs.loc.gov/gen-coll-assessment/](https://data.labs.loc.gov/gen-coll-assessment/)  