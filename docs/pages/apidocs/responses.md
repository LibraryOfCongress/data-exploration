---
title: Responses
keywords: responses, data, json, api 
last_updated: Dec 19, 2017
tags: 
summary: "A response is the JSON you get back from your request to the loc.gov API. Because the API also provides data for the loc.gov website, there is a lot of data (e.g. breadcrumbs, facets) that are specifically for that purpose. This page focuses on the sections of the JSON response that are most useful for wokring with collections and items."
sidebar: apidocs_sidebar
permalink: responses.html
folder: apidocs
---

## Search Results

The top-level element ```results``` contains a list of items matching your query. Each item includes many elements, but some of the most useful ones are below. There is even more data available for each item if you request the ```/item/``` view. 

<table>
  <tr>
    <td><strong>Field</strong></td>
    <td><strong>Description</strong></td>
    <td><strong>Type</strong></td>
    <td><strong>Example</strong></td>
  </tr>
  <tr>
    <td style="white-space: nowrap">original_format</td>
    <td>The kind of object being described (not the digitized version).

If the record is for an entire collection, that is included here.</td>
    <td>array</td>
    <td> [ "map" ]

[ "photo, print, drawing", "collection"
]
</td>
  </tr>
  <tr>
    <td>id</td>
    <td>URL for the item, including its identifier. Always appears. </td>
    <td>string</td>
    <td>"http://www.loc.gov/item/2017645977/"</td>
  </tr>
  <tr>
    <td>partof</td>
    <td>Collections, divisions, and units in the Library of Congress. </td>
    <td>array</td>
    <td>["prints and photographs division",
"lot 10526",
"catalog"]</td>
  </tr>
  <tr>
    <td>subject</td>
    <td><p>List of subjects. These are broken-apart Library of Congress Subject Headings. Geography is not shown here, see the location element. </p>

<p>For example, an item with the subject heading "Women -- Afghanistan -- Social conditions" will have [“social conditions",
"women's rights"] in the subject element and “afghanistan” in the location element. </p>

<p>For the full subject headings, request the JSON for the /item view</p></td>
    <td>array</td>
    <td>["public interest/advocacy",
"history",
"september 11 terrorist attacks"
]
</td>
  </tr>
  <tr>
    <td>index</td>
    <td>The index number of the results among all results. This starts with 1 and continues through all of the results in the whole set (not just this page). </td>
    <td>integer</td>
    <td>1</td>
  </tr>
  <tr>
    <td>title</td>
    <td>Title of the item</td>
    <td>string</td>
    <td>"Women Taxpayers; Women Voters"</td>
  </tr>
  <tr>
    <td style="white-space: nowrap">online_format</td>
    <td>Format available via the website</td>
    <td>array</td>
    <td>["web page"],

["image","pdf"]

</td>
  </tr>
  <tr>
    <td>location</td>
    <td>Place related to the item. 

These are extracted from subject headings and other metadata, so there may be duplicates. </td>
    <td>array</td>
    <td>["earth (planet)",
"planet", "earth"]

["benin", "niger", 
"niger", "benin"]

</td>
  </tr>
  <tr>
    <td>mime_type</td>
    <td>Formats available for download</td>
    <td>array</td>
    <td>["image/gif",
"video/mov",
"video/mpeg",
"application/x-video",
"image/jpeg"]
</td>
  </tr>
  <tr>
    <td>digitized</td>
    <td>Whether this item has been digitized. </td>
    <td>boolean</td>
    <td>true</td>
  </tr>
  <tr>
    <td>description</td>
    <td>Often includes a description of the original physical item. </td>
    <td></td>
    <td>["Correspondence. Typed letter regarding Scandinavian production rights to \"Kiss Me. Kate\" Courtesy of Cole Porter Trust (Copyright Notice)."]


["1 photographic print. | Two Pueblo Indian women posed standing, full-length, New Mexico."]
</td>
  </tr>
  <tr>
    <td>date</td>
    <td>Date of item creation. Could be a year or YYYY-MM-DD</td>
    <td>string</td>
    <td>"2002-08-08"

“1910”</td>
  </tr>
  <tr>
    <td>dates</td>
    <td>List of dates related to the item. In ISO 8601 format, UTC.</td>
    <td>array</td>
    <td>["2001-01-01T00:00:00Z", "2001-10-30T00:00:00Z", "2001-12-15T00:00:00Z", "2002-01-01T00:00:00Z"]
</td>
  </tr>
  <tr>
    <td>language</td>
    <td>Languages associated with the item</td>
    <td>array</td>
    <td>["english",
"spanish"]
</td>
  </tr>
  <tr>
    <td>url</td>
    <td>URL on the loc.gov website. 

If the items is something in the library catalog, the URL will start with lccn.loc.gov. </td>
    <td>string</td>
    <td>https://www.loc.gov/item/2017711647/<br />
  	//lccn.loc.gov/08030295</td>
  </tr>
  <tr>
    <td>image_url</td>
    <td>URLs for images in various sizes, if available. 

If the item is not something that has an image (e.g. it’s a book that’s not digitized or an exhibit), the URL for the image might be for an icon image file. </td>
    <td>array</td>
    <td>["//cdn.loc.gov/service/pnp/bbc/<br />0000/0000/0004f_150px.jpg",]
    </td>
  </tr>
</table>

{% include warning.html content="If you're using the API from within the Library of Congress, you may have access to additional data. Notably, this may include URLs for images larger than thumbnails. These are only for use on-site at the Library of Congress, don't rely on that data being available off-site." %}

## Example response


A typical response is very long, with many elements that are intended for the website only. Shown below is just the ```item``` section of the response:

```
"item": {
    "library_of_congress_control_number": "98688726",
    "source_collection": [],
    "display_offsite": true,
    "contributors": [{
            "g.w. & c. colton & co.": "https://www.loc.gov/search/?fa=contributor%3Ag.w.+%26+c.+colton+%26+co.&fo=json"
        },
        {
            "new orleans, mobile, and chattanooga railroad": "https://www.loc.gov/search/?fa=contributor%3Anew+orleans%2C+mobile%2C+and+chattanooga+railroad&fo=json"
        }
    ],
    "creator": "G.W. & C.B. Colton & Co.",
    "access_restricted": false,
    "site": [
        "ammem",
        "catalog"
    ],
    "original_format": [
        "map"
    ],
    "genre": [],
    "subject_headings": [
        "New Orleans, Mobile, and Chattanooga Railroad",
        "Railroads--United States--Maps",
        "United States"
    ],
    "created_published": [
        "New York, 1865."
    ],
    "extract_urls": [
        "http://www.loc.gov/item/98688726#gmd.mar",
        "http://lccn.loc.gov/98688726#catalog"
    ],
    "id": "http://www.loc.gov/item/98688726/",
    "contents": [],
    "subject": [
        "new orleans, mobile, and chattanooga railroad",
        "railroads",
        "united states",
        "maps"
    ],
    "index": 1,
    "digital_id": [
        "http://hdl.loc.gov/loc.gmd/g3701p.rr004750"
    ],
    "call_number": [
        "G3701.P3 1865 .G15"
    ],
    "group": [
        "gmd.mar",
        "catalog",
        "general-maps"
    ],
    "score": 11.276397,
    "location_country": [
        "united states"
    ],
    "title": "Map showing the New Orleans, Mobile & Chattanooga Railroad and its connections.",
    "description": [
        "Map of the eastern half of the United States showing drainage, cities and towns, counties, and the railroad network."
    ],
    "related_items": [],
    "online_format": [
        "image"
    ],
    "subjects": [{
            "maps": "https://www.loc.gov/search/?fa=subject%3Amaps&fo=json"
        },
        {
            "new orleans, mobile, and chattanooga railroad": "https://www.loc.gov/search/?fa=subject%3Anew+orleans%2C+mobile%2C+and+chattanooga+railroad&fo=json"
        },
        {
            "railroads": "https://www.loc.gov/search/?fa=subject%3Arailroads&fo=json"
        },
        {
            "united states": "https://www.loc.gov/search/?fa=subject%3Aunited+states&fo=json"
        }
    ],
    "location": [{
        "united states": "https://www.loc.gov/search/?fa=location%3Aunited+states&fo=json"
    }],
    "_version_": 1584611057109827600,
    "type": [
        "map"
    ],
    "mime_type": [
        "image/gif",
        "image/tiff",
        "image/jpeg",
        "image/jp2"
    ],
    "digitized": true,
    "rights_advisory": [],
    "medium": [
        "map 53 x 83 cm."
    ],
    "reproduction_number": [],
    "repository": [
        "Library of Congress Geography and Map Division Washington, D.C. 20540-4650 USA dcu"
    ],
    "format": [{
        "map": "https://www.loc.gov/search/?fa=original_format%3Amap&fo=json"
    }],
    "partof": [{
            "count": 635,
            "url": "https://www.loc.gov/collections/railroad-maps-1828-to-1900/?fo=json",
            "title": "railroad maps, 1828-1900"
        },
        {
            "count": 900,
            "url": "https://www.loc.gov/collections/transportation-and-communication/?fo=json",
            "title": "transportation and communication"
        },
        {
            "count": 16205,
            "url": "https://www.loc.gov/search/?fa=partof%3Ageography+and+map+division&fo=json",
            "title": "geography and map division"
        },
        {
            "count": 639861,
            "url": "https://www.loc.gov/search/?fa=partof%3Aamerican+memory&fo=json",
            "title": "american memory"
        },
        {
            "count": 815225,
            "url": "https://www.loc.gov/search/?fa=partof%3Acatalog&fo=json",
            "title": "catalog"
        }
    ],
    "timestamp": "2017-11-20T18:34:26.584000Z",
    "campaigns": [],
    "extract_timestamp": "2017-11-20T18:24:49.580000Z",
    "date": "1865",
    "shelf_id": "G3701.P3 1865 .G15",
    "other_title": [],
    "dates": [{
        "1865": "https://www.loc.gov/search/?dates=1865%2F1865&fo=json"
    }],
    "language": [{
        "english": "https://www.loc.gov/search/?fa=language%3Aenglish&fo=json"
    }],
    "rights": [
        "<h2>\r\nRights and Access\r\n</h2>\r\n<p>The maps in the Map Collections materials were either  published prior to 1922, produced by the United States government, or both  (see catalogue records that accompany each map for information regarding  date of publication and source).  The Library of Congress is providing  access to these materials for educational and research purposes and is not  aware of any U.S. copyright protection (see Title 17 of the United States  Code) or any other restrictions in the Map Collection materials. </p>\r\n<p>Note that the written permission of the copyright owners and/or  other rights holders (such as publicity and/or privacy rights) is required  for distribution, reproduction, or other use of protected items beyond that  allowed by fair use or other statutory exemptions.  Responsibility for  making an independent legal assessment of an item and securing any necessary  permissions ultimately rests with persons desiring to use the item.</p>\r\n<p> More about <a href=\"//memory.loc.gov/ammem/copyrit2.html\"> American Memory, Copyright and other Restrictions</a></p>\r\n<p> Credit Line: Library of Congress, Geography and Map Division. </p>\r\n<p> For guidance about compiling full citations consult <a href=\"//memory.loc.gov/ammem/ndlpedu/start/cite/index.html\">Citing Electronic Sources</a> on the Learning Page. </p>\r\n"
    ],
    "url": "https://www.loc.gov/item/98688726/",
    "notes": [
        "Scale 1:3,168,000.",
        "LC Railroad maps, 475",
        "Description derived from published bibliography.",
        "Inset: Map showing the relation of Mobile & N.O. to the ports of Mexico, Central America , and the W.I. 21 x 21 cm.",
        "Available also through the Library of Congress Web site as a raster image."
    ],
    "control_number": "",
    "summary": [
        "Map of the eastern half of the United States showing drainage, cities and towns, counties, and the railroad network."
    ],
    "hassegments": false,
    "image_url": [
        "//cdn.loc.gov/service/gmd/gmd370/g3701/g3701p/rr004750.gif",
        "//cdn.loc.gov/service/gmd/gmd370/g3701/g3701p/rr004750.gif#h=150&w=231",
        "//tile.loc.gov/image-services/iiif/service:gmd:gmd370:g3701:g3701p:rr004750/full/pct:3.125/0/default.jpg#h=207&w=320",
        "//tile.loc.gov/image-services/iiif/service:gmd:gmd370:g3701:g3701p:rr004750/full/pct:6.25/0/default.jpg#h=415&w=640",
        "//tile.loc.gov/image-services/iiif/service:gmd:gmd370:g3701:g3701p:rr004750/full/pct:12.5/0/default.jpg#h=830&w=1280",
        "//tile.loc.gov/image-services/iiif/service:gmd:gmd370:g3701:g3701p:rr004750/full/pct:25/0/default.jpg#h=1660&w=2560"
    ],
    "other_formats": [{
            "link": "https://lccn.loc.gov/98688726/marcxml",
            "label": "MARCXML Record"
        },
        {
            "link": "https://lccn.loc.gov/98688726/mods",
            "label": "MODS Record"
        },
        {
            "link": "https://lccn.loc.gov/98688726/dc",
            "label": "Dublin Core Record"
        }
    ],
    "aka": [
        "http://www.loc.gov/resource/g3701p.rr004750/",
        "http://www.loc.gov/item/98688726/",
        "http://hdl.loc.gov/loc.gmd/g3701p.rr004750",
        "http://lccn.loc.gov/98688726"
    ],
    "contributor_names": [
        "G.W. & C.B. Colton & Co.",
        "New Orleans, Mobile, and Chattanooga Railroad."
    ],
    "access_advisory": []
},
```
