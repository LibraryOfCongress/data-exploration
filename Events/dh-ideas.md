# Bite-size ideas for the "Doing DH @ LC" Create-a-thon 

## Digital Humanities Preconference, August 5, 2024

Just a few initial seed ideas for projects, if you don't have your own 

* Go to data.labs.loc.gov and browse the various[ Exploratory Data Packages](https://data.labs.loc.gov/packages/) that are available, read through the documentation, take a look at the visualizations, and see if anything piques your interest 
* Run through some of the[ Jupyter Notebook Tutorials for Data Exploration](https://libraryofcongress.github.io/data-exploration/intro.html) to get a sense of what's possible 
* Get together with others at a table and create your own bite-sized ideas based on particular research questions, collections, or technical capabilities that interest you. Share it with LC staff (we'd definitely be interested!) 

--- 

* Piping LC data packages into a database tool like Datasette for SQL-like querying and exploratory visualization 
    * [Datasette](https://datasette.io/) 
    * [Minimal example with sample data on Glitch](https://third-boiling-system.glitch.me/data/sample-data_metadata) 
* By the People transcription datasets – asking LLMs to work with those paper datasets 
    * By the People is the Library's public crowdsourced transcription program. For all completed campaigns, the transcribed text has been made available as easily-downloadable datasets on loc.gov:[ By the People completed transcriptions datasets](https://www.loc.gov/collections/selected-datasets/?fa=contributor:by+the+people+%28program%29). The text is ideal for various text analysis tasks including topic modeling, parsing and summarizing using large language models, and named entity recognition. You can find out more about the campaigns here:[ Campaign information.](https://crowd.loc.gov/campaigns/completed/) 
        * Delve into the occult experiments of British Spiritualist, accountant, and Freemason,[ Frederick Hockley](https://crowd.loc.gov/campaigns/hockley/) (1808-1885) 
        * [Organizing for Women’s Suffrage: The NAWSA Records](https://crowd.loc.gov/campaigns/organizing-for-womens-suffrage-the-nawsa-records/) 
* Explore the Children's Literature, Philosophy, or Local History Collections  
    * The General Collections Assessment is an ongoing program to assess the Library's approximately 22 million books, bound serials and other materials classified under the General Collections. As part of this project, the Library is making available for exploration the underlying bibliographic datasets used as the primary data sources for the collection assessments.[ https://data.labs.loc.gov/gen-coll-assessment/](https://data.labs.loc.gov/gen-coll-assessment/)  
* Mappable collections: 
    * The[ Sanborn Maps Data Package](https://data.labs.loc.gov/sanborn/)<span style="text-decoration:underline;"> </span>comes with an easy-to-download CSV of metadata, including estimated latitudes and longitudes for most Sanborn atlases. This data is perfect for loading into map interfaces to experiment with representing the collection spatially. These coordinates were created by using the OpenStreetMap geocoder Nominatim.  
    * Several other data packages on data.labs.loc.gov were also geocoded using the same method, including[ Free to Use and Reuse Data Package](https://data.labs.loc.gov/free-to-use/),[ National Jukebox Data Package](https://data.labs.loc.gov/jukebox/),[ Digitized Telephone Directories, 1891-1988 Data Package](https://data.labs.loc.gov/telephone/), and[ Directory Holdings Data Package](https://data.labs.loc.gov/directories/).  
    * The[ Stereograph Card Images Data Package](https://data.labs.loc.gov/stereographs/)<span style="text-decoration:underline;"> </span>also comes with a CSV of metadata that includes estimated latitude and longitudes for almost 10% of the collection. These coordinates come directly from the loc.gov API. 
* MARC Library Catalog records 
    * Interested in exploring library catalog records in bulk? Here are a few resources to get started! 
        * [MARC records](https://www.loc.gov/cds/products/marcDist.php) (browse down to MARC Open-Access) - bibliographic information for most of the Library’s collections circa 2016. 25 million records are available for exploration in UTF-8 and XML formats. 
        * [Sample MARC data set](https://labs.loc.gov/static/labs/events/images/hack-to-learn-MARCSample.tar.gz) and[ ReadMe file](https://labs.loc.gov/static/labs/lc-for-robots/images/readme-marc.txt) 
        * [General Collections Assessment Data Package](https://data.labs.loc.gov/gen-coll-assessment/) – currently contains data as CSV for three sections of the Library's general collections: Children's Literature, Philosophy, and Local History 
* A georeferencing tool like Allmaps for the Sanborns, or other Fire Insurance maps 
    * No coding required! Try out[ Allmaps](https://allmaps.org/), a georeferencing tool for IIIF-enabled maps. Head over to[ https://loc.gov/maps](https://loc.gov/maps) to pick out some maps you'd like to georeference. Scroll down to the section "Getting started".  
        * [Sanborn Atlas Volume Finder](https://guides.loc.gov/fire-insurance-maps/sanborn-atlas-volume-finder)  
* Historic American Buildings Survey/Historic American Engineering Record/Historic American Landscapes Survey 
    * One of the most popular collections at the Library, this collection  includes the records of three National Park Survey surveys that document achievements in architecture, engineering, and landscape design. A common request is to view a map of the survey locations, but the titles (which have the most precise location information) are difficult to work with using traditional geocoders. Large language models (LLMs) potentially offer a new route for geocoding and mapping this collection. If you're interested in this challenge, let us know! We have a spreadsheet of data from the collection, including the titles of each survey. We've also pulled coordinates from Wikidata, which has crowdsourced locations for a small proportion of the collection.  
        * Try parsing addresses from the titles using an LLM 
        * Try directly geocoding the titles using an LLM 
        * Use the items with Wikidata coordinates for comparison 
        * See for example:[ https://simonwillison.net/2024/Jul/14/pycon/#pycon-2024.051.jpeg](https://simonwillison.net/2024/Jul/14/pycon/#pycon-2024.051.jpeg),[ https://medium.com/@jrballesteros/chatgpt-for-parsing-addresses-and-geocoding-a8c9d0a91a5b](https://medium.com/@jrballesteros/chatgpt-for-parsing-addresses-and-geocoding-a8c9d0a91a5b) ,[ https://blog.geomusings.com/2024/05/14/simple-ner-with-chatgpt/](https://blog.geomusings.com/2024/05/14/simple-ner-with-chatgpt/)  
* Analyzing archival Finding Aids 
    * The Library currently has 3,139 archival collections described in EAD-XML finding aids, at[ https://findingaids.loc.gov/](https://findingaids.loc.gov/). Try your hand at analyzing the full text of the finding aids. You can use sentence transformers for topic modeling, or try out large language models for generating summaries and topic terms.  
        * Tell us if you're interested, and we can give you the full set of XML documents, full text extracted from the Container Lists, and a CSV of various subject fields plus collection-level narrative fields like Abstract, Scope and Contents, and Biographical/Historical notes.  
* Historical federal powerpoints:  
    * Our Web Archive collections include millions of PDFs, PowerPoints, audio files, data spreadsheets, and other files attached to websites going back to the late 1990s. At[ data.labs.loc.gov/dot-gov/](https://data.labs.loc.gov/dot-gov/), you'll find a data package that contains random samples of these files from .gov websites archived between 1996 and 2017. For each of seven types of files (audio, CSV, image, PDF, PowerPoint, TSV, and Excel), 1,000 files are included plus basic metadata about the files including embedded tiles, timestamps, and more. Try analyzing the text, perform image or audio analysis, or just have some fun visualizing the metadata.  
        * Other web archive datasets are listed at[ https://labs.loc.gov/work/experiments/webarchive-datasets/](https://labs.loc.gov/work/experiments/webarchive-datasets/)  
* Work with US Copyright Office bulk data:  
    * [https://data.copyright.gov/index.html](https://data.copyright.gov/index.html)  
    * This probably requires help to work with and explain how the data is structured, but if you're interested let us know and we can definitely help!  
* Color detection in Sanborn maps to extract material types 
    * The Sanborn Maps Data Package includes over 400,000 detailed map images of United States cities and towns from the late 19<sup>th</sup> century through the mid-20<sup>th</sup> century. The images and their approximate locations are available for download at[ https://data.labs.loc.gov/sanborn/](https://data.labs.loc.gov/sanborn/), and the collection is browsable at[ https://www.loc.gov/collections/sanborn-maps/about-this-collection/](https://www.loc.gov/collections/sanborn-maps/about-this-collection/). Could image analysis of these images be used to investigate geographic and chronological trends in building materials in the U.S.? The maps color-code buildings according to their building materials. For example,[ this sheet of Los Angeles yellow buildings](https://www.loc.gov/resource/g4364lm.g4364lm_g00656192206/?sp=13) were built with wood (frame). This[ sheet of mostly-red buildings from the Bronx](https://www.loc.gov/resource/g3804nm.g3804nm_g06116189503/?sp=34) and[ St. Louis](https://www.loc.gov/resource/g4164sm.g4164sm_g048581907/?sp=2) were built with brick. Stone and concrete buildings are typically blue, and adobe buildings are gray, and special hazard buildings are green. Try your hand at writing a script that calculates the average color of each sheet and classifies sheets by predominant color. 
        * For color analysis you could use a common Python image analysis library like PILLOW or cv2 
        * For cluster analysis (to group sheets by predominant color), you could use a Python library like scikit-learn 
        * Maybe it's possible to update pieces of this code from NYPL Labs, which includes color detection for material types, among other things:[ https://github.com/nypl-spacetime/building-inspector](https://github.com/nypl-spacetime/building-inspector) 

     


Not-yet-developed bites: 

* Looking at pre-prepped OCR, and detecting bad pages 
    * Detect unusable OCR 
* Prints and Photographs materials and object detection  
    * Recent LC Labs intern project on object detection:[ https://github.com/beefoo/lclabs-jfp24](https://github.com/beefoo/lclabs-jfp24)  
