---
title: Pagination
keywords: pagination, pages, query, results, api 
last_updated: Dec 19, 2017
tags: 
summary: "The API returns items in pages or results, rather than all of the results at once. "
sidebar: apidocs_sidebar
permalink: pagination.html
folder: apidocs
---

The default number of results per response (or "page") is 25. You can change how many are in each response by using the ```c``` parameter in your request, for example ```c=100```. Be considerate and keep your count to a reasonable number. Your response may take longer to return if you set it too high. 

The ```pagination``` section of the response has the information you’ll need to understand which page of results you’re on. One way to get the next page of results is to use the URL in the ```next``` field. When there are no more pages, it will be null. 

{% include tip.html content="You may see a pages section in the JSON returned for a query but that’s for a different purpose. Be sure to use the pagination section." %}

<table>
  <tr>
    <td><strong>Field</strong> (within "pagination")</td>
    <td><strong>Description</strong></td>
    <td><strong>Example</strong></td>
  </tr>
  <tr>
    <td>from</td>
    <td>Index number of the first result item in this page of results.</td>
    <td>26</td>
  </tr>
  <tr>
    <td>to</td>
    <td>Index number of the last result in this page of results. </td>
    <td>50</td>
  </tr>
  <tr>
    <td>results</td>
    <td>Index numbers of the result items in this page.</td>
    <td>“26 - 50”</td>
  </tr>
  <tr>
    <td>last</td>
    <td>URL of the last page of results in the whole set of results pages.</td>
    <td>"https://www.loc.gov/search/?q=giraffe&sp=5&fo=json”</td>
  </tr>
  <tr>
    <td>of</td>
    <td>Total number of items in the results. </td>
    <td>318</td>
  </tr>
  <tr>
    <td>previous</td>
    <td>URL of the preceding page of results. Will be null when this is the first page.</td>
    <td>"https://www.loc.gov/search/?q=giraffe&sp=1&fo=json",</td>
  </tr>
  <tr>
    <td>next</td>
    <td>URL of the next page of results. Will be null when there are not more pages.</td>
    <td>"https://www.loc.gov/search/?q=giraffe&sp=3&fo=json"</td>
  </tr>
  <tr>
    <td>perpage</td>
    <td>Number of result items on each page. </td>
    <td>25</td>
  </tr>
  <tr>
    <td>total</td>
    <td>Total number of pages available.</td>
    <td>5</td>
  </tr>
  <tr>
    <td>current</td>
    <td>Page number you are currently on.</td>
    <td>2</td>
  </tr>
</table>

**Example:**

```https://www.loc.gov/collections/national-child-labor-committee/?sp=2&c=100&fo=json```
