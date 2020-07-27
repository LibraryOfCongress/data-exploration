---
title: "Available Tutorials"
keywords: tutorial, how-to, api, Jupyter, json
tags:
sidebar: apidocs_sidebar
permalink: all-tutorials.html
summary: The data-exploration GitHub includes several Jupyter notebooks and other files that contain tutorials on how to use the API, with example scripts. The tutorials are loosely categorized by topic. Under each heading, you can find details on what the tutorial documents contain, the assumed background knowledge, and possible applications of the code provided.
---

Almost all of these documents are Jupyter notebooks, which is a programming environment that runs in a web browser. A notebook can contain both text in a markdown format and Python code that can be run directly as part of the workflow.

If this is your first time using Jupyter notebooks, here are a couple great tutorials online to help you install and set up the software:

* https://reproducible-science-curriculum.github.io/workshop-RR-Jupyter/setup/
* https://programminghistorian.org/en/lessons/jupyter-notebooks

Also, remember that the applications listed are only a few examples intended as a starting point! The possibilities are far wider. We're excited to see what you do with the collections. If you have ideas about how to make the API more useful or more topics that you want us to cover in the documentation, please let us know!

## General Search and Query

### [JSON API Overview](https://github.com/LibraryOfCongress/data-exploration/blob/master/LOC.gov%20JSON%20API.ipynb)

An overview of how to retrieve information in a JSON format from the Library of Congress API. This tutorial sets a baseline for doing powerful data retrieval and visualization projects.

**Background knowledge:**
* Understand URLs for loc.gov API [requests](requests.html) and how to modify them

**Applications:**
* Get and visualize data
* Show images from collections
* Make cool projects like [this clock using collection item names](https://library-of-time.glitch.me/) and [this political cartoon visualizer](https://jeffreyshen19.github.io/political-cartoon-visualizer/) - for more inspiration, see the [experiments](https://labs.loc.gov/work/experiments/?st=gallery) that LC Labs has been working on!

### [OpenSearch](https://github.com/LibraryOfCongress/data-exploration/blob/master/OpenSearch.ipynb)

Brief guide to searching loc.gov directly from a web browser.

**Background knowledge:** None

**Applications:** Searching the website

### [Sitemaps](https://github.com/LibraryOfCongress/data-exploration/blob/master/Sitemap.ipynb)

Describes Sitemaps and how to get information about the frequency of page updates.

**Background knowledge:** None, but understanding the basics of [Sitemaps](https://www.sitemaps.org/) and [how the formatting works](https://www.sitemaps.org/protocol.html) is recommended

**Applications:**
* Determining how often collections or parts of the website are updated
* Finding the number of items in a collection or sub-items on a page of the site

## Images

### [Accessing Images for Analysis](https://github.com/LibraryOfCongress/data-exploration/blob/master/Accessing%20images%20for%20analysis.ipynb)

How to access, display, and download images in bulk. Also provides information about what metadata is available and how to get particular details.

This tutorial is for accessing images directly via the the API, so the images are generally smaller (150 px on one side) and low resolution. For accessing larger images that can be manipulated (size, rotation, crop, etc.), see the next tutorial, on IIIF.

**Background knowledge:**
* Understand URLs for loc.gov API [requests](requests.html) and how to modify them

**Applications:**
* Find URLs for images
* Download images in bulk
* Get information about the images, such as copyright and usage details, dates, locations, etc.

### [IIIF](https://github.com/LibraryOfCongress/data-exploration/blob/master/IIIF.ipynb)

How to scale, rotate, reflect, crop, and otherwise manipulate images using the IIIF API.

IIIF stands for the International Image Interoperability Framework. It is a standardized way to get images that is used by various libraries, museums, digital archives, etc.

**Background knowledge:**
* Where to find the IIIF URLs (can be found in image metadata accessed via the JSON API)
* (optional) Details of [IIIF URL structure](https://iiif.io/api/image/2.1/#table-of-contents)

**Applications:**
* Get higher resolution images and manipulate them
* Display images - individually or in galleries
* Can also be done in bulk

### [Image Color Analysis](https://github.com/LibraryOfCongress/data-exploration/blob/master/Dominant%20colors.ipynb)

How to find and analyze the colors in an image. This tutorial uses [k-means clustering](https://jakevdp.github.io/PythonDataScienceHandbook/05.11-k-means.html) to analyze and group the pixel values into 6 colors per image, but you can adjust that as needed.

**Background knowledge:**
* Using [links in HTML](https://www.w3schools.com/tags/att_a_href.asp)
* How to create an [SVG rectangle in HTML](https://www.w3schools.com/graphics/svg_rect.asp)
* (optional - recommended) Color codes for web - [RGB vs. Hex](https://goedemorgenwp.com/make-site-colorful-color-use-hex-vs-rgb/)

**Applications:**
* Visualize [colors in Library of Congress collections images](https://loc-colors.glitch.me/)
* Categorize or search images by color

>**[Downloading Monographs as Images](https://github.com/LibraryOfCongress/data-exploration/blob/master/Downloading_Monographs_as_Images_in_Rosenwald_Collection/Downloading%20Monographs%20as%20Images%20in%20Rosenwald%20Collection.ipynb)**

Similar to the Accessing Images for Data Analysis notebook — provides code for accessing and downloading images specifically from the [Lessing J. Rosenwald Collection](https://www.loc.gov/rr/rarebook/rosenwald.html).

See background knowledge and applications for the accessing images notebook.

## Geographic Data and Maps

### [Extracting Location Data](https://github.com/LibraryOfCongress/data-exploration/blob/master/Extracting%20location%20data%20for%20geovisualization.ipynb)

Demonstrates how to retrieve geographic data (latitude and longitude) and plot it onto a map. This tutorial focuses on items in the Historic American Engineering Record (HAER). The way that geographic data is stored across collections does vary, so some collections may require more data cleaning and manipulation before doing geographic visualizations.

**Background knowledge:**
* Understand URLs for loc.gov API [requests](requests.html) and how to modify them
* (optional) Python [folium mapping](https://python-visualization.github.io/folium/modules.html#module-folium.map)
* (optional) Python [pandas dataframe](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.html)

**Applications:**
* Map item locations
* Analyze geographic data and connect it to other information, such as date
* Compare geographies across collections

### [Maps Downloading and Querying](https://github.com/LibraryOfCongress/data-exploration/blob/master/maps/maps-downloading-querying.ipynb)

How to query and download cartographic material. Includes:
* performing bulk downloads of cartographic materials using the loc.gov API and Python
* crafting advanced API queries for map content
* performing post-query filtering

**Background knowledge:** None, though it may be useful to have some familiarity with Python

**Applications:**
* Download and display images from the collections
* Create sets of images that can be used in a number of other applications

### [Maps Metadata](https://github.com/LibraryOfCongress/data-exploration/blob/master/maps/maps-analyzing-metadata.ipynb)

How to find, analyze, and visualize cartographic metadata. This tutorial focuses on metadata associated with the files in the Maps Downloading and Querying tutorial as well as items in the Sanborn Maps collection.

**Background knowledge:**
* How to [install a python package using pip](https://www.w3schools.com/python/python_pip.asp) - or some other package manager

**Applications:**
* Search for items within a collection/dataset that have particular locations, dates, etc.
* Analyze the different parts of the metadata (longest/shortest/average item length, most common dates or locations)
* Create charts with the data that compare all of the items

## Historic Newspapers

### [Chronicling America](https://github.com/LibraryOfCongress/data-exploration/blob/master/ChronAm%20API%20Samples.ipynb)

The Chronicling America database also has an API that functions similarly to the wider loc.gov API. Its URLs start with https://www.chroniclingamerica.loc.gov/ instead of https://www.loc.gov/ but the endings for querying are the same.

This tutorial provides an introduction to what information is available via the API — one notable difference is that since this collection consists of newspaper pages, you can retrieve the text from the page (collected using [OCR](https://en.wikipedia.org/wiki/Optical_character_recognition)) via the API. It also covers searching for keywords and analyzing data from bulk records.

**Background knowledge:**
* Understand URLs for loc.gov API [requests](requests.html) and how to modify them

**Applications:**
* Visualize search results on a map
* Find certain quotes through time
* Do historical research
* See [these projects](https://blogs.loc.gov/thesignal/2016/08/the-neh-chronicling-america-challenge-using-big-data-to-ask-big-questions/) for more!

### [Chronicling America CSV](https://github.com/LibraryOfCongress/data-exploration/tree/master/chronam_all_digitized)

The Python script here creates a csv file of all of the digitized titles in Chronicling America, with their associated metadata.

**Background knowledge:**
* [Command line basics](https://www.codecademy.com/articles/command-line-commands#:~:text=The%20command%20line%20is%20a,or%20Finder%20on%20Mac%20OS.)
* Need Python 3 installed - basic understanding of how Python and the API work needed for modification

**Applications:** The produced csv can be used for a number of different data analysis and [visualization](https://www.loc.gov/ndnp/data-visualizations/) applications. See the Memegenerator and GIPHY tutorials for more on how to use Python code to analyze data in csv file formats.

### [Chronicling America Issue Counts CSV](https://github.com/LibraryOfCongress/data-exploration/tree/master/chronam_issue_counts)

These scripts create csv files where each row contains the state name, year, and the number of newspaper issues in the Chronicling America database available in that state and year. Each script does this for one state.

See above (Chronicling America CSV) for background knowledge needed and potential applications.

## Other

### [Memegenerator Metadata](https://github.com/LibraryOfCongress/data-exploration/blob/master/getting_started_with_memegenerator.ipynb)

Introduction to csv data analysis in Python using the Memgenerator dataset from [this page](https://labs.loc.gov/work/experiments/webarchive-datasets/). Shows how to:
* find column headers to see what data is available
* count occurrences within the dataset
* visualize data in a bar graph
* retrieve and display images

**Background knowledge:** None, though it may be useful to have some familiarity with Python

**Applications:**
* Exploring memes
* Finding [top 10s and other statistics](https://blogs.loc.gov/thesignal/2018/10/data-mining-memes-in-the-digital-culture-web-archive/) in a dataset
* Data analysis and visualization for any dataset

### [GIPHY.com Metadata](https://github.com/LibraryOfCongress/data-exploration/blob/master/getting_started_with_giphy.ipynb)

Slightly more advanced csv data analysis in Python using the [GIPHY.com dataset taken from this page](https://labs.loc.gov/work/experiments/webarchive-datasets/). Shows how to:
* Get dates for the GIFs
* Group and visualize the dates
* Find the GIF file sizes
* Search the titles in the dataset
* Download all of the GIFs

**Background knowledge:** some familiarity with Python and/or data analysis - the Memegenerator tutorial is a good place to start

**Applications:**
* Exploring GIFs
* Searching through datasets
* Data analysis and visualization for any dataset

### [Accessing and Remixing Sound](https://github.com/LibraryOfCongress/data-exploration/blob/master/loc_goes_lofi.ipynb)

Provides code for selecting random audio segments and combining them together. Assumes that users have already downloaded the [audio files](https://s3.us-east-2.amazonaws.com/lclabspublicdata/lcwa_gov_audio_data.zip) into the same folder as this notebook. The dataset includes 1000 randomly selected audio clips. For more information on how this dataset was generated, see the [README](https://s3.us-east-2.amazonaws.com/lclabspublicdata/lcwa_gov_audio_README.txt).

**Background knowledge:**
* Python:
  * [Importing packages](https://docs.python.org/3/reference/import.html)
  * [Defining functions](https://www.w3schools.com/python/python_functions.asp)
  * Using the [pydub package](https://github.com/jiaaro/pydub)
  * (optional) Using the [glob](https://docs.python.org/3/library/glob.html), [re](https://docs.python.org/3/howto/regex.html), and [random](https://docs.python.org/3/library/random.html) packages

**Applications:**
* Create remixed audio
* Manipulate existing audio files
* Build interactive audio sampling tools, like [this](https://citizen-dj.labs.loc.gov/)

### [American Folklife Center Scripts](https://github.com/LibraryOfCongress/data-exploration/tree/master/americanfolklifecenter)

Includes 2 bash scripts, [reportmd.sh](https://github.com/LibraryOfCongress/data-exploration/blob/master/americanfolklifecenter/reportmd.sh) and [processfiles.sh](https://github.com/LibraryOfCongress/data-exploration/blob/master/americanfolklifecenter/processfiles.sh). These scripts intend to make processing and data analysis easier by automating some of the initial steps. They can be run on any command line interface (i.e. Terminal for macOS, PowerShell or Command prompt for Windows), and the script will prompt user inputs.

Reportmd - Reports collection records out into CSV, GZ, and XML files.

Processfiles - Does processing to clean up files, including batch file renaming, deleting files, and flattening directories.

**Note:** These scripts are complex and require background knowledge to fully understand. However, they can be run and used without that background.

**Background knowledge:**
* Bash scripts:
  * [one tutorial](https://www.taniarascia.com/how-to-create-and-use-bash-scripts/)
  * [another tutorial](https://ryanstutorials.net/bash-scripting-tutorial/bash-script.php)

**Applications:**
* Get data into a different file format
* Automate some data cleaning/processing
* Can be modified to work for other datasets and collections outside of the American Folklife Center
