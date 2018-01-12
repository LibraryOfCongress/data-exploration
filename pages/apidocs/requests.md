---
title: Requests
keywords: requests, query, api 
last_updated: Dec 19, 2017
tags: 
summary: "A request is a URL with query parameters."
sidebar: apidocs_sidebar
permalink: requests.html
folder: apidocs
---

## Base URL

All URLs start with ```https://www.loc.gov/``` and should include ```fo=json``` as a parameter to get JSON

No API key or authentication is required. 

## Searching

Get a set of items back by using one of these search endpoints. You can add parameters to the end of any of them, and should always include ```fo=json```.

{%  include tip.html content="Because the API also powers the website, you can use the search box on the loc.gov website to understand how different search parameters affect results." %}


### /search/?

Searches everything on the www.loc.gov website. Includes items in the collection, legislation, web pages, blog posts, and press releases. 

Example: ```https://www.loc.gov/search/?q=baseball&fo=json```

The API does not include records from the library catalog (although items that have been digitized are retrievable). See the [MARC Open Access dataset](https://www.loc.gov/cds/products/marcDist.php) for bulk access to the catalog records up through 2014. 

### /collections/{name of collection}?

Searches within a specified collection. The name of the collection needs to be in "slug" form, which is words separated by hyphens. For example: abraham-lincoln-papers or baseball-cards.  You can find the collection’s name by searching the website. 

<!--{% include tip.html content="Most, but not all collections are queryable via the API. Here’s how you can check which collections are online and available to query." %}" -->

**Example:** ```https://www.loc.gov/collections/civil-war-maps?fo=json```

### /{format}/?

Searches for items which have a specified original format. Possible values include:

* maps:	```maps```
* audio recordings:	```audio```
* photo, print, drawing: ```photos```
* manuscripts/mixed material: ```manuscripts```
* newspapers:	```newspapers```
* film, videos: ```film-and-videos```
* printed music, such as sheet music: ```notated-music```
* archived websites: ```websites```

**Example:** ```https://www.loc.gov/maps/?q=civil war&fo=json```


## Common parameters

Always include ```fo=json``` in your URL so that you get JSON, not HTML.

<table>
  <tr>
    <td style="white-space: nowrap;"><strong>Parameter</strong></td>
    <td><strong>Description</strong></td>
    <td><strong>Examples</strong></td>
  </tr>
  <tr>
    <td>q</td>
    <td>query parameter<br />Does a keyword search in the metadata and any available full text including video transcripts</td>
    <td>q=kittens</td>
  </tr>
  <tr>
    <td>fa</td>
    <td>filter or facet<br />
      <p>takes the format filter-name:value<br />
      multiple filters can be used by separating them with a pipe character: |</p>
      
      <p>Available filters/facets include:</p>
      <p><strong>location</strong></p>
      <p><strong>subject</strong></p>
      <p><strong>original-format</strong></p>
      <p>Many formats are also available as endpoints (e.g. /maps/). Those that are ONLY available using the filters/facets parameter include:</p>
        original-format:sound recording<br />
        original-format:legislation<br />
        original-format:periodical<br />
        original-format:personal narrative<br />
        original-format:software,e-resource<br />
        original-format:3d object<br />

      <p><strong>partof</strong></p>
      <p>Collections, divisions, and units in the Library of Congress. Most are also available using the collections endpoint. See <a href="https://www.loc.gov/search/index/partof/">Part ofs</a> for a list.</p>
      <p><strong>contributor</strong></p>
    </td>
    <td style="white-space: nowrap;"><p>fa=location:ohio</p>
      <p>fa=location:yellowstone national park</p>
      <p>fa=subject:meterology</p>
      <p>fa=original-format:periodical|subject:wildlife</p>
      <p>fa=partof:performing arts encyclopedia</p>
      <p>fa=contributor:lange, dorothea</p>
    </td>
  </tr>
  <tr>
    <td>c</td>
    <td>results per page
default is 25</td>
    <td>c=50</td>
  </tr>
  <tr>
    <td>sp</td>
    <td>page in results (results are returned in pages of 25 items unless specified using the c parameter)
      The first page is sp=1.</td>
    <td>sp=2</td>
  </tr>
  <tr>
    <td>at</td>
    <td>attributes to return in the results
      <p>This is helpful for removing extraneous information from the results, such as more_like_this and related_items. You can specify 
        elements to exclude using at!=</p></td>
    <td>at=item<br />at=item,resources,reproductions<br />at!=more_like_this</td>
  </tr>
  <tr>
    <td>sb</td>
    <td>sort field
      <p>Available sort options include:</p>
        date (earliest to latest)<br />
        date_desc (latest to earliest)<br />
        title_s (by title)<br />
        title_s_desc (reverse by title)<br />
        shelf_id (call number/physical location)<br />
        shelf_id_desc (reverse by call number/physical location)<br />
    </td>
    <td>sb=date_desc<br />
    sb=shelf_id</td>
  </tr>
</table>


**More example requests**

```https://www.loc.gov/collections/herblock-cartoon-drawings/?fo=json&c=100```

```https://www.loc.gov/photos/?fa=location:oklahoma```


## Requesting a specific item

### /item/{identifier}/?

The best way to get at all of the fields related to a specific item is to look at search results and use the **id** field for that item, and put ```fo=json``` at the end. The id field is a URL; the path will vary from collection to collection. 

Examples: 

```https://www.loc.gov/item/ggb2006012811/?fo=json```

```https://www.loc.gov/item/acd1999001521/PP/?fo=json```

```https://www.loc.gov/item/ihas.200196396/?fo=json```

{% include tip.html content="All item records that you find in search results have an **id** field (the URL for that item’s metadata). Some, but not all, collections have an **item_id** field, which contains just the unique identifier itself. Since not all collections have **item_id**, it’s better to rely on the **id** field and the URL it contains." %}

{% include warning.html content="Only URLs in the **id** field that start with ```loc.gov/item``` or ```loc.gov/resource``` will return JSON format when you put ```fo=json``` at the end of the URL. If the **id** field starts with ```https://lccn.loc.gov/```, JSON format is not available because the item is a catalog record. If you are still interested in structured data for catalog records, you can put ```/marcxml``` on the end of the url and get the catalog record in MARCXML format." %}



