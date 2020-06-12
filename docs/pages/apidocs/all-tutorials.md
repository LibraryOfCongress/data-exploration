---
title: "Available Tutorials"
keywords: tutorial, how-to, api, Jupyter, json
tags:
sidebar: apidocs_sidebar
permalink: all-tutorials.html
summary: The [data-exploration GitHub](https://github.com/LibraryOfCongress/data-exploration) includes several Jupyter notebooks and other files that contain tutorials on how to use the API, with example scripts. The tutorials are loosely categorized by topic. Under each heading, you can find details on what the tutorial documents contain, the complexity and assumed background knowledge, and possible use cases and adaptations of the code provided.
---

The majority of these documents are Jupyter notebooks, which is a programming environment that runs in a web browser. A notebook can contain both text in a markdown format and Python code that can be run directly as part of the workflow.

If this is your first time using Jupyter notebooks, there are [several](https://reproducible-science-curriculum.github.io/workshop-RR-Jupyter/setup/) great [tutorials](https://programminghistorian.org/en/lessons/jupyter-notebooks) online to help you install and set up the software.

### General Search and Query

[JSON API Overview](https://github.com/LibraryOfCongress/data-exploration/blob/master/LOC.gov%20JSON%20API.ipynb)

Provides an overview of how to retrieve information in a JSON format from the Library of Congress API. This tutorial sets a baseline for doing powerful data retrieval and visualization projects.

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

Background knowledge: None, but understanding [Sitemaps](https://www.sitemaps.org/) and [how the protocol works](https://www.sitemaps.org/protocol.html) is recommended

Use cases:
* Determining how often collections or parts of the website are updated
* Finding the number of items in a collection or sub-items on a page of the site

### Images

[Accessing Images for Analysis](https://github.com/LibraryOfCongress/data-exploration/blob/master/Accessing%20images%20for%20analysis.ipynb)

[Image Color Analysis](https://github.com/LibraryOfCongress/data-exploration/blob/master/Dominant%20colors.ipynb)

[IIIF](https://github.com/LibraryOfCongress/data-exploration/blob/master/IIIF.ipynb)

[Downloading Monographs as Images](https://github.com/LibraryOfCongress/data-exploration/blob/master/Downloading_Monographs_as_Images_in_Rosenwald_Collection/Downloading%20Monographs%20as%20Images%20in%20Rosenwald%20Collection.ipynb) looks like this one has an error and might be pretty similar to the images one anyway

### Geographic Data

[Geographic Data](https://github.com/LibraryOfCongress/data-exploration/blob/master/Extracting%20location%20data%20for%20geovisualization.ipynb)

[Maps Downloading and Querying](https://github.com/LibraryOfCongress/data-exploration/blob/master/maps/maps-downloading-querying.ipynb)

[Maps Metadata](https://github.com/LibraryOfCongress/data-exploration/blob/master/maps/maps-analyzing-metadata.ipynb)

### Chronicling America

[Chronicling America](https://github.com/LibraryOfCongress/data-exploration/blob/master/ChronAm%20API%20Samples.ipynb)

[Chronicling America CSV](https://github.com/LibraryOfCongress/data-exploration/tree/master/chronam_all_digitized)

[Chronicling America Issue Counts](https://github.com/LibraryOfCongress/data-exploration/tree/master/chronam_issue_counts) gets number of issues from that year and state

### Other

[GIPHY.com Metadata](https://github.com/LibraryOfCongress/data-exploration/blob/master/getting_started_with_giphy.ipynb)

[Memegenerator Metadata](https://github.com/LibraryOfCongress/data-exploration/blob/master/getting_started_with_memegenerator.ipynb)

[Accessing and Remixing Sound](https://github.com/LibraryOfCongress/data-exploration/blob/master/loc_goes_lofi.ipynb)

[American Folklife Center Scripts](https://github.com/LibraryOfCongress/data-exploration/tree/master/americanfolklifecenter) will need to look more into this - looks like they're shell/bash scripts
