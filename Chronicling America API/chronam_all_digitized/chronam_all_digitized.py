# -*- coding: utf-8 -*-
#!/usr/bin/env python
import json
import requests
import csv

# US Newspaper Directory results URL
results_json = 'https://chroniclingamerica.loc.gov/newspapers.json'

# List for storing digitzed titles JSON urls and title information
title_url_list = list()
all_digitized_titles = list()
digitized_title = []
count = 0
max_places_of_publication_count = 0

# Returns JSON results
def get_json(url):
    data = requests.get(url)
    return(json.loads(data.content))
    
data = get_json(results_json)

# Cycle through newspapers.json to get title url and state information
for record in data['newspapers']:
    title_json_url = record['url']
    state = record['state']
    url_string = str(title_json_url)
    all_digitized_info = [state, url_string]
    title_url_list.append(all_digitized_info)
    
# Cycles through title_url_list to get title information
for i in title_url_list:
    state = i[0]
    
    title_json = get_json(i[1])   
    lccn = (title_json['lccn'])
        
# Accounts for multiple places of publication
    places_of_publication = []
    places_of_publication_count = 0
    for place in title_json['place']:
        places_of_publication_count +=1
        place_of_publication = place
        places_of_publication.append(place_of_publication)
    
# Checks and replaces max_places_of_publication_count if new max
    if places_of_publication_count > max_places_of_publication_count:
        max_places_of_publication_count = places_of_publication_count
    else:
        None
    
    title = (title_json['name'])
    title_url_json = (title_json['url'])
    issue_count = 0
    first_issue = title_json['issues'][0]['date_issued']
    for issue in title_json['issues']:
        issue_count +=1
    last_date = issue_count - 1    
    last_issue = title_json['issues'][last_date]['date_issued']
    
# Adds the State, LCCN, Title, Title URL JSON, Issue count, First issue, Last issue for the title
    digitized_title = [state, lccn, title, title_url_json, issue_count, first_issue, last_issue]

# Adds Places of Publication to the title information
    for i in places_of_publication:
        digitized_title.append(i)
# Appends titile information to the all_digitized_titles list        
    all_digitized_titles.append(digitized_title.copy())
# Prints out digitized title information and count so it looks like the script is running    
    print(digitized_title)    
    count += 1

# Creates header row for .csv file
    header = ['state', 'lccn', 'title', 'title_url_json', 'digitized_issue_count', 'first_digitized_issue', 'last_digitized_issue']
# Accounts for multiple places of publication
    p_o_p = 0
    while p_o_p < max_places_of_publication_count:
        place_count = p_o_p
        place = 'place_of_publication_' + str(place_count)
        header.append(place)
        p_o_p += 1
    
# Save the all_digitized_titles list as a .csv file
# Order of variables: state, lccn, title, title_url_json, digitized_issue_count, first_digitized_issue, last_digitized_issue, place_of_publication (repeats for all places of publication)
with open('chronam_all_digitized.csv', 'w', encoding='utf-8', newline='') as csv_file:
    writer = csv.writer(csv_file)
    writer.writerow(header)
    writer.writerows(all_digitized_titles)

# Prints number of digitized titles and done 
print('Number of digitized titles: ' + str(count))
print('done') 