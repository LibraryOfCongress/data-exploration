---
title: Sitemaps
keywords: sitemaps, items, query, results, api 
last_updated: Dec 19, 2017
tags: 
summary: "Sitemaps provide links to pages in a collection or items in a collection. Sitemaps are in XML."
sidebar: apidocs_sidebar
permalink: sitemaps.html
folder: apidocs
---

Another way to get URLs for all of the items in a collection is to use collection-level sitemaps. Adding ```fo=sitemap``` instead of ```fo=json``` to a collection query will give you results in sitemap format. 

**Example:**

[http://www.loc.gov/collections/abraham-lincoln-papers/?c=1000&fo=sitemap](http://www.loc.gov/collections/abraham-lincoln-papers/?c=1000&fo=sitemap)

```
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9" xmlns:image="http://www.google.com/schemas/sitemap-image/1.1/">
  <url>
    <loc>
      http://www.loc.gov/collections/abraham-lincoln-papers/about-this-collection/
    </loc>
    <lastmod>2017-12-20T06:12:37.115000+00:00</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>
  ...
  <url>
    <loc>http://www.loc.gov/item/mal0019900/</loc>
    <lastmod>2017-11-03T18:10:24.982000+00:00</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>
</urlset>
```

{% include tip.html content="Sitemaps are a quick way to get URLs for all of the items in a collection at once." %}
