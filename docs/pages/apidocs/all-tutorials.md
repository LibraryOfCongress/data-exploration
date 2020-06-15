---
title: "Available Tutorials"
keywords: tutorial, how-to, api, Jupyter, json
tags:
sidebar: apidocs_sidebar
permalink: all-tutorials.html
summary: The data-exploration GitHub includes several Jupyter notebooks and other files that contain tutorials on how to use the API, with example scripts. The tutorials are loosely categorized by topic. Under each heading, you can find details on what the tutorial documents contain, the complexity and assumed background knowledge, and possible use cases and adaptations of the code provided.
---

Almost all of these documents are Jupyter notebooks, which is a programming environment that runs in a web browser. A notebook can contain both text in a markdown format and Python code that can be run directly as part of the workflow.

If this is your first time using Jupyter notebooks, there are [several](https://reproducible-science-curriculum.github.io/workshop-RR-Jupyter/setup/) great [tutorials](https://programminghistorian.org/en/lessons/jupyter-notebooks) online to help you install and set up the software.

Also, remember that the use cases listed are only a few examples intended as a starting point! The possibilities are far wider. We're excited to see what you do with the collections. If you have ideas about how to make the API more useful or more topics that you want us to cover in the documentation, please let us know!

## General Search and Query

[JSON API Overview](https://github.com/LibraryOfCongress/data-exploration/blob/master/LOC.gov%20JSON%20API.ipynb)

An overview of how to retrieve information in a JSON format from the Library of Congress API. This tutorial sets a baseline for doing powerful data retrieval and visualization projects.

Background knowledge:
* Understand URLs for loc.gov API [requests](requests.html) and how to modify them

Use Cases:
* Get and visualize data
* Show images from collections
* Make cool projects like [this](https://library-of-time.glitch.me/) and [this](https://jeffreyshen19.github.io/political-cartoon-visualizer/) and [this](https://loc-photo-roulette.glitch.me/) - for more inspiration, see the [experiments](https://labs.loc.gov/work/experiments/?st=gallery) that LC Labs has been working on!

[OpenSearch](https://github.com/LibraryOfCongress/data-exploration/blob/master/OpenSearch.ipynb)

Brief guide to searching loc.gov directly from a web browser.

Background knowledge: None

Use cases: Searching the website

[Sitemaps](https://github.com/LibraryOfCongress/data-exploration/blob/master/Sitemap.ipynb)

Describes Sitemaps and how to get information about the frequency of updates.

Background knowledge: None, but understanding the basics of [Sitemaps](https://www.sitemaps.org/) and [how the protocol works](https://www.sitemaps.org/protocol.html) is recommended

Use cases:
* Determining how often collections or parts of the website are updated
* Finding the number of items in a collection or sub-items on a page of the site

## Images

[Accessing Images for Analysis](https://github.com/LibraryOfCongress/data-exploration/blob/master/Accessing%20images%20for%20analysis.ipynb)

How to access, display, and download images in bulk. Also provides information about what metadata is available and how to get particular details.

This tutorial is for accessing images via the API, which are generally smaller and low resolution. For accessing larger images that can be manipulated (size, rotation, crop, etc.), see the next tutorial, on IIIF.

Background knowledge:
* Understand URLs for loc.gov API [requests](requests.html) and how to modify them

Use cases:
* Find URLs for the images
* Download images in bulk
* Get information about the images, such as copyright and usage details

[IIIF](https://github.com/LibraryOfCongress/data-exploration/blob/master/IIIF.ipynb)

How to scale, rotate, reflect, crop, and otherwise manipulate images using the IIIF API.

IIIF stands for the International Image Interoperability Framework. It is a standardized way to get images that is used by various libraries, museums, digital archives, etc.

Background knowledge:
* Where to find the IIIF URLs (can be found in image metadata accessed via the JSON API)
* (optional) Details of [IIIF URL structure](https://iiif.io/api/image/2.1/#table-of-contents)

Use cases:
* Get higher resolution images and manipulate them
* Display images, individually or in galleries
* Can also be done in bulk

[Image Color Analysis](https://github.com/LibraryOfCongress/data-exploration/blob/master/Dominant%20colors.ipynb)

How to find and analyze the colors in an image. This tutorial uses [k-means clustering](https://jakevdp.github.io/PythonDataScienceHandbook/05.11-k-means.html) to analyze and group the pixel values into 6 colors per image, but you can adjust that as needed.

Background knowledge:
* Using [links in HTML](https://www.w3schools.com/tags/att_a_href.asp)
* How to create an [SVG rectangle in HTML](https://www.w3schools.com/graphics/svg_rect.asp)
* (recommended) Color codes for web - [RGB vs. Hex](https://goedemorgenwp.com/make-site-colorful-color-use-hex-vs-rgb/)

Use cases:
* Visualize [colors in Library of Congress collections images](https://loc-colors.glitch.me/)
* Categorize or search images by color

[Downloading Monographs as Images](https://github.com/LibraryOfCongress/data-exploration/blob/master/Downloading_Monographs_as_Images_in_Rosenwald_Collection/Downloading%20Monographs%20as%20Images%20in%20Rosenwald%20Collection.ipynb)

Similar to the Accessing Images for Data Analysis notebook — provides code for accessing and downloading images specifically from the [Lessing J. Rosenwald Collection](https://www.loc.gov/rr/rarebook/rosenwald.html).

See background knowledge and use cases for the accessing images notebook.

## Location Data and Maps

[Extracting Location Data](https://github.com/LibraryOfCongress/data-exploration/blob/master/Extracting%20location%20data%20for%20geovisualization.ipynb)

Demonstrates how to retrieve geographic data (latitude and longitude) and plot it onto a map. This tutorial focuses on items in the Historic American Engineering Record (HAER). The way that geographic data is stored across collections does vary, so some collections may require more data manipulation before doing geographic visualizations.

Background knowledge:
* Understand URLs for loc.gov API [requests](requests.html) and how to modify them
* (optional) Python [folium mapping documentation](https://python-visualization.github.io/folium/modules.html#module-folium.map)
* (optional) Python [pandas dataframe documentation](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.html)

Use cases:
* Map item locations
* Analyze geographic data and connect it to other information, such as date
* Compare geographies across collections

[Maps Downloading and Querying](https://github.com/LibraryOfCongress/data-exploration/blob/master/maps/maps-downloading-querying.ipynb)

How to query and download cartographic material. Includes:
* performing bulk downloads of cartographic materials using the loc.gov API and Python
* crafting advanced API queries for map content
* performing post-query filtering

Background knowledge: None, though it may be useful to have some familiarity with Python

Use cases:
* Download and display images from the collections
* Create sets of images that can be used in a number of other applications

[Maps Metadata](https://github.com/LibraryOfCongress/data-exploration/blob/master/maps/maps-analyzing-metadata.ipynb)

How to find, analyze, and visualize cartographic metadata. This tutorial focuses on metadata associated with the files in the Maps Downloading and Querying tutorial as well as items in the Sanborn Maps collection.

Background knowledge:
* How to [install a python package using pip](https://www.w3schools.com/python/python_pip.asp) - or some other package manager

Use cases:
* Search for items within a collection/dataset that have particular locations, dates, etc.
* Analyze the different parts of the metadata (longest/shortest/average item length, most common dates or locations)
* Create charts with the data that compare all of the items

## Chronicling America

[Chronicling America](https://github.com/LibraryOfCongress/data-exploration/blob/master/ChronAm%20API%20Samples.ipynb)

[Chronicling America CSV](https://github.com/LibraryOfCongress/data-exploration/tree/master/chronam_all_digitized)

[Chronicling America Issue Counts](https://github.com/LibraryOfCongress/data-exploration/tree/master/chronam_issue_counts) gets number of issues from that year and state

## Other

[GIPHY.com Metadata](https://github.com/LibraryOfCongress/data-exploration/blob/master/getting_started_with_giphy.ipynb)

[Memegenerator Metadata](https://github.com/LibraryOfCongress/data-exploration/blob/master/getting_started_with_memegenerator.ipynb)

[Accessing and Remixing Sound](https://github.com/LibraryOfCongress/data-exploration/blob/master/loc_goes_lofi.ipynb)

[American Folklife Center Scripts](https://github.com/LibraryOfCongress/data-exploration/tree/master/americanfolklifecenter) will need to look more into this - looks like they're shell/bash scripts
