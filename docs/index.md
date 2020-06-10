---
title: "About the loc.gov JSON API"
keywords: api documentation homepage
tags:
sidebar: apidocs_sidebar
permalink: index.html
summary: The loc.gov API is a work in progress and subject to change. Once the API leaves Beta, we anticipate release of an official version of this documentation at loc.gov.
---

## Introduction

The loc.gov JSON API provides structured data about Library of Congress collections. The API was originally designed to power the [loc.gov website](https://www.loc.gov), but in addition to providing HTML for the website it can provide a wealth of information in [JSON format](https://en.wikipedia.org/wiki/JSON).

API stands for "application programming interface". You can write code that sends queries to the API in the form of URLs or web requests (like your browser makes) and get back responses that have structured data. That data, in [JSON format](https://en.wikipedia.org/wiki/JSON), is more easily used by software programs and in analysis tools. With an API, you can do things like:
* dynamically include content from a website in your own website
* send a query for data to feed [a Twitter bot](https://twitter.com/LoCMapBot)
* create a dataset for analysis, visualization, or mapping.

The loc.gov JSON API provides information about things you can find on the Library of Congress website:
* items (books, archived websites, photos, and videos)
* collections (thematic or otherwise grouped items that have been digitized)
* images (thumbnails and higher resolution formats)


There are other [specialized APIs and bulk downloads](https://labs.loc.gov/lc-for-robots) you may want to check out, too.

The API does not include records from the library catalog (although items that have been digitized are retrievable). See the [MARC Open Access dataset](https://www.loc.gov/cds/products/marcDist.php) for bulk access to the catalog records up through 2014.

{% include tip.html content="The API is a work in progress and things may change at any time. Fields may be added, deleted, or used in different ways, so make any code you write flexible and able to adjust to changes. Not every item is available via the API yet; some collections are still in process of being made available." %}

## Base URL

All URLs start with ```https://www.loc.gov/``` and need to include ```fo=json``` as a parameter to get JSON.

No API key or authentication is required.

## Requests

Get started by learning about [requests](requests.html), query parameters, and [pagination](pagination.html).

## Responses

See [Responses](responses.html) for info about fields in search results and examples.

## Tutorials

* [Getting started with the loc.gov API](https://github.com/LibraryOfCongress/data-exploration/blob/master/LOC.gov%20JSON%20API.ipynb) using Python.
* [All tutorials](all-tutorials.html)

## How-to

* [How to work with sitemaps](https://github.com/LibraryOfCongress/data-exploration/blob/master/Sitemap.ipynb)


{% include note.html content="This documentation is a resource to help people understand the API and make use of it. It’s intended to inspire creative uses of the Library of Congress collection. So, it's not comprehensive, but highlights the most relevant aspects. If you have ideas about what else this documentation should cover or anything else to make the API even more useful, let us know!" %}
