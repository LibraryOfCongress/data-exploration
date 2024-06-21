# Using the loc.gov API with the Chronicling America Historic Newspapers Collection
## About this Repository
This repository contains information about using the [LoC.gov API](https://www.loc.gov/apis/) with the Chronicling America collection.  Additionally there are six (6) Jupyter notebooks designed specifically for using the loc.gov API to access Chronicling America content. To jump directly to the Jupyter Notebooks, see **Example Notebooks** below. [Jump to Notebooks](/#example-notebooks-performing-basic-tasks-analysis-and-downloads)
### Credits
The Jupyter notebooks in this repository were created by NDNP staff in the Serial and Government Publications Division at the Library of Congress. The content was inspired by, and at times closely follows, the notebooks created by [LC Maps for Robots](https://github.com/LibraryOfCongress/data-exploration/blob/861bbe6e0fb9992fe1c4fedf43e3f61bccd980bc/loc.gov%20JSON%20API/maps/README.md) 

Contact ndnptech@loc.gov for questions about these Chronicling America notebooks.
  
### Rights Statement
The content in this repository is free to use and reuse without restriction.

---


## Chronicling America: Digital Collection of Historic American Newspapers
[**Chronicling America**](https://www.loc.gov/collections/chronicling-america/about-this-collection/) is a searchable and freely accessible digital collection of historic newspaper pages. A product of the National Digital Newspaper Program (NDNP), it contains millions of newspaper pages from nearly every state and territory in the United States published through 1963.

NDNP, a partnership between the National Endowment for the Humanities (NEH) and the Library of Congress, is a long-term effort to develop an Internet-based, searchable database of U.S. newspapers with descriptive information and select digitization of historic pages. Supported by NEH, this rich digital resource is developed and permanently maintained at the Library of Congress. An NEH award program will fund the contribution of content from, eventually, all U.S. states and territories.

More information on program guidelines, participation, and technical information can be found on the [**Chronicling America LibGuide**](https://guides.loc.gov/chronicling-america), [**Library of Congress: Chronicling America Collection**](https://www.loc.gov/collections/chronicling-america/about-this-collection/) and on the [**National Endowment for the Humanities website**](http://www.neh.gov/projects/ndnp.html).

### Note on Language in Chronicling America

Developing the most useful keywords requires knowing what terms were used in the period you are searching, rather than what the common, contemporary terms might be. This can be particularly challenging when searching for news about race and ethnicity, since much of the language describing such communities has evolved and changed throughout the centuries.

The **[Race and Ethnicity Keyword Thesaurus for Chronicling America](https://edsitement.neh.gov/media-resources/race-and-ethnicity-keyword-thesaurus-chronicling-america)** features a guide to searching topics of race and ethnicity in Chronicling America, including a thesaurus of words used in the past that may help produce more results. Primary documents from the past contain sensitive content, and the suggested keywords are often offensive to several different communities of people.

Created by partners in the [National Digital Newspaper Program](https://www.loc.gov/ndnp/awards/), this resource hopes to serve researchers at all levels through demonstrations and explanations of search terms related to race and ethnicity in Chronicling America.

More information can be found at the **[Race and Ethnicity Keyword Thesaurus for Chronicling America](https://edsitement.neh.gov/media-resources/race-and-ethnicity-keyword-thesaurus-chronicling-america)**.

---

## LOC.GOV API
The loc.gov application programming interface (API) provides structured data about Library of Congress collections in JSON and YAML formats. Software programs routinely access the JSON/YAML API to keep the loc.gov website updated as new digital content is added to the Library's collections. For example, JSON data is used to build loc.gov pages for items (loc.gov/item), collections (loc.gov/collections/), searches (loc.gov/search/), and more.

However, in addition to being a resource for the computer applications powering the loc.gov website, the API can be used by developers, digital librarians, and researchers to directly retrieve digital collections information formatted as JSON or YAML data.

### Access
The loc.gov API is accessible to the public with no API key or authentication required.
Additional information can be found at: [APIs for LoC.gov](https://www.loc.gov/apis/)

---
# Rate Limits and Definitions
## Rate Limits
When working with and downloading bulk data using the loc.gov API, please be mindful of rate limits for Newspapers. Requests that exceed the rate which loc.gov can successfully accommodate will be blocked to prevent a denial of service.

> **Newspapers Endpoints:**
* Burst Limit: 20 requests per 1 minute, Block for 5 minutes
* Crawl Limit: 20 requests per 10 seconds, Block for 1 hour

If you are unsure how large your search query will be, you should first perform an **Advanced Search** at [Chronicling America](https://www.loc.gov/collections/chronicling-america/) to see how many results you get.

> Search queries with more than 100,000 results are too big for the loc.gov API. Please use facets to limit the size of your results and search query. Recommended search facets can be found in the *Definitions: API Query Paramenters for Newspapers* section. They include:
* Start Date/End Date: Narrow your search results to specific time periods or break up your search queries by decades.
* LCCN: Narrow your search to a specific newspaper title.
* State: Narrow your search to a specific state.


More information on rate limits can be found at: [https://www.loc.gov/apis/json-and-yaml/working-within-limits/](https://www.loc.gov/apis/json-and-yaml/working-within-limits/)

---
## Definitions: API Query Paramenters for Newspapers
The easiest way to create a URL for your API query is to perform an **Advanced Search** at [Chronicling America](https://www.loc.gov/collections/chronicling-america/).
> If you performed an Advanced Search to create your API Query, we recommend including some of the additional query parameters.

The structure of an API Query URL looks like this:

    https://www.loc.gov/collections/chronicling-america/?{queryparameters}&{queryparameters}?fo=json

**Base URL**: To perform an API query on Newspapers from Chronicling America, you need a URL which is divided with the following sections:


| Library of Congress Website | End Point | Question Mark | Query Parameters | Format |
| --- | --- |  --- | --- | --- |
| URL for Library of Congress | Indicates the Digital Collection to be searched |  Starts Query | Indicate what is being searched | Indicates Display Format |
| | | | Combined by ampersand `&` symbol.  | Options: json, yaml |
| | | | | |
| https://www.loc.gov | /collections/chronicling-america/ | ? | {queryparameters}&{queryparameters} | &fo=json |

Example API Query URL:

    https://www.loc.gov/collections/chronicling-america/?dl=page&end_date=1924-12-31&qs=cat&start_date=1924-10-01&location_state=california&fo=json

---

For **Newspapers from the Chronicling America collection**, the most useful **Query Parameters** used in the loc.gov API are:

| Parameter | Effect on the Query | Note |
| --- | --- |  --- |
| `dl=___` | Display Level. Indicates whether display results will be newspaper title, issue, or page level. | Examples: |
| | | `all` (Default, same effect as omitting this parameter) |
| | | `issue` |
| | | `page`  |
| `qs=____` | Indicates what words the query will search. | Use Plus "+" symbol between words |
| `ops=___` | Indicates the type of search operation. | Examples: |
| |  | `PHRASE` ("This exact phrase"), |
| |  | `AND` ("All of these words"), |
| |  | `OR` ("Any of these words"), |
| |  | `~5` ("These words within 5 words of each other"), |
| |  | `~10` ("These words within 10 words of each other") |
| `end_date=YYYY-MM-DD` | Indicates the end "date" field. | |
| `start_date=YYYY-MM-DD` | Indicates the start "date" field value. | |
| `location_state=___` | Narrows result of the newspaper title to its state location. | |
| `location_city=____` | The publication "location" state should equal "___". | |
| `location_county=____` | The publication "location" state should equal "___". | |
| `fa=batch:_____` | Indicates the batch name. | |
| `fa=number_lccn:___` | Indicates the newspaper title's LCCN. | |
| `&partof_title=` | Indicates the newspaper title. | Use Plus `+` symbol between words. Title are case sensitive and need correct spelling/diacritics. |
| `fa=language:____` | Indicates the language of the newspaper publication. | |
| `subject_ethnicity=____` | Indicates the newspaper ethnicity *if availabile*. | Use Exclamation Mark "!" symbol between multiple ethnicities |
| `searchType=Advanced` | Indicates the search query was the result of an advanced search. | |
| `front_pages_only=true` | Limits the number of results to just the front page of the newspaper. | Recommended for searching major news stories. |

> Note: If you're looking to download full text from the newspaper pages in a given search result, note that the full text (from OCR) is captured for each page within the "full_text" JSON field.  For example: https://www.loc.gov/resource/sn83045462/1922-12-26/ed-1/?sp=22&q=clara+bow&fo=json 
---

# Example Notebooks (Performing Basic Tasks, Analysis, and Downloads)
Below are various examples and tasks you can perform using the [APIs for LoC.gov](https://www.loc.gov/apis/) with Chronicling America. They cover performing basic tasks, analysis, and downloads.
- Each notebook is linked and designed to be downloaded to your computer and opened with Jupyter Notebook or Google Colab (a jupyter notebook service).
- After a notebook has been downloaded and opened, you may follow along or edit and change the variables before running the scripted tasks.
- Downloading of newspaper pages, titles, and batches requires ample hard drive space.
> Note: If the loc.gov website is down or experiencing high demand, the example Jupyter Notebooks may not work correctly or take longer to perform queries and process data.
 ---

 ## Example Notebook 1: Basic API Tasks
 Learning and performing some of these Basic API tasks can ensure your results will contain all the data you need.

Objectives:
1. Understand how to Import the most common Modules
2. Understand how to define the query URL and run the query
3. Understand how to find metadata elements in the JSON and print out the most common metadata fields for newspapers.
4. Perform pagination in order to validate your search query and check the number of results you may have.

Feel free to follow along or download this notebook and put in your own search queries. See: [ChronAm_basic_API tasks.ipynb](/ChronAm_basic_API%20tasks.ipynb)

---
 ## Example Notebook 2: Analyzing Specific Newspapers for Content
 
 **Notebook Example:**

> The *Washington Times* newspaper printed a special children's section called "Book of Magic." This section contains children stories and coloring and puzzle activities.
Specifically, we will utilize the API tool to 1. Narrow our search to a specific newspaper title and its content using a phrase. 2. Limit the search result so we only get the top 16 results.

Objectives:
1. Retrieve Newspaper Page-level results from a specific newspaper
2. Limit results to only the top 16
3. Exporting results from Queries to CSV Table

Feel free to follow along or download this notebook and put in your own search queries. See: [ChronAm_analyzing_specific_titles_limit_results.ipynb](/ChronAm_analyzing_specific_titles_limit_results.ipynb)

---
 ## Example Notebook 3: Analyzing Word Frequency on Newspaper Front Pages
 
**Notebook Example:**
> On August 18, 1920, Tennessee became the 36th state to ratify the 19th amendment which provided the final ratification necessary to add the amendment to the U.S. Constition which gave women the right to vote. In this example, we will look at the word frequency for the term “Suffrage” on the front pages of the newspapers on August 26, 1920 (when U.S. government officially certified state's ratification of the 19th amendment) and the day after (August 27, 1920).

Objectives:
1. Retrieve Newspaper Page-level results for word frequency analysis
2. Exporting results from Queries to CSV Table

Feel free to follow along or download this notebook and put in your own search queries. See: [ChronAm_analyzing_word_frequency_newspaper_frontpages.ipynb](/ChronAm_analyzing_word_frequency_newspaper_frontpages.ipynb)


---
 ## Example Notebook 4: Analyzing Word Frequency and Location

 **Notebook Example:**

> We wil utilize the API tool to look at the frequency of word usage found in Newspapers in relationship to time (when was the term published in newspapers) and location (where the term was most commonly used at on a newspaper's state location) using the term "influenza." 

Objectives:
1. Retrieve Newspaper Page-level results for word frequency and location analysis
2. Exporting results from Queries to CSV Table
3. Display Data Visualization from data gathered

Feel free to follow along or download this notebook and put in your own search queries. See: [ChronAm_analyzing_language_location_frequency.ipynb](/ChronAm_analyzing_language_location_frequency.ipynb)


---
 ## Example Notebook 5: Downloading Search Results

Objectives:
1. Download Files from the Search Results
2. Exporting Metadata of Downloaded Search Results onto a CSV File

Feel free to follow along or download this notebook and put in your own search queries. See:
[ChronAm-download_results.ipynb](/ChronAm-download_results.ipynb)

> Note: Please make sure to limit/filter your search results in order to adhere to rate limits. Do not attempt to download large search queries because they may be too large for the loc.gov API.

---

 ## Example Notebook 6: Part 1: Downloading a Newspaper Title

 To download a specific newspaper title, you need to know the following information:
  * the newspaper Title's LCCN or the correct full name/spelling of the Newsaper.

Objectives:

1. Download Files from a specific newspaper title

Feel free to follow along or download this notebook and put in your own search queries. See:
[ChronAm-download_newspaper_title_batch.ipynb](/ChronAm-download_newspaper_title_batch.ipynb)

> Note: This process takes longer to perform due to the size of the batch. Because of potential outages, rate limits and the large size of the API request, we recommend splitting the query by using facets such as start/end date (see example below).

Example:
Query all issues of the Evening Star by the Title Name:

    https://www.loc.gov/collections/chronicling-america/?partof_title=evening+star&fo=json

Example:
Query all issues of the Evening Star by the LCCN:

    https://www.loc.gov/collections/chronicling-america/?fa=number_lccn:sn83045462&fo=json

Example:
Query all newspaper issues found in Chronicling America for the Evening Star in 1920:

    https://www.loc.gov/collections/chronicling-america/?fa=number_lccn:sn83045462&start_date=1920-01-01&end_date=1920-12-31&fo=json


---

## Example Notebook 6: Part 2: Download an NDNP Batch

To download an NDNP Batch, you need to know the following information:
- The correct full name/spelling of the batch.

Objectives:

1. Download Files from a specific NDNP Batch


Feel free to follow along or download this notebook and put in your own search queries. See:
[ChronAm-download_newspaper_title_batch.ipynb](/ChronAm-download_newspaper_title_batch.ipynb)

> Note: This process is longer to perform due to the size of the batch. Because of potential outages, rate limits and the large size of the API request, we recommend splitting the query by using facets such as start/end date (see example below).

Example:
To download all newspaper titles in a batch from Tennessee called `tu_brownie_ver01` found in Chronicling America from 1880-1890:

    https://www.loc.gov/collections/chronicling-america/?fa=batch:tu_brownie_ver01&start_date=1880-01-01&end_date=1890-12-31&fo=json



---
# Additional Resources
[Chronicling America](https://www.loc.gov/collections/chronicling-america/about-this-collection/)

[Chronicling America Data Visualizations](https://www.loc.gov/ndnp/data-visualizations/)

[Chronicling America: A Guide for Researchers](https://guides.loc.gov/chronicling-america)

[Recommended Topics in Chronicling America](https://guides.loc.gov/chronicling-america-topics)

[Directory of U.S. Newspapers in American Libraries](https://www.loc.gov/collections/directory-of-us-newspapers-in-american-libraries/about-this-collection/)

[National Digital Newspaper Program](https://www.loc.gov/ndnp/)

[Newspaper and Current Periodical Reading Room](https://www.loc.gov/research-centers/newspaper-and-current-periodical)

[Collections with Newspapers at the Library of Congress](https://www.loc.gov/newspapers/collections/)

[Ask a Librarian in Serial and Government Publications Division](https://ask.loc.gov/newspapers-periodicals/)

[APIs for LoC.gov](https://www.loc.gov/apis/)

