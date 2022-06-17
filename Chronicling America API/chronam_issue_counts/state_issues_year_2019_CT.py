#!/usr/bin/env python
# -*- coding: UTF-8 -*-
import json
import csv
import requests

# URL for all digitized titles
all_digitized_titles_json = 'http://chroniclingamerica.loc.gov/newspapers.json'

total_issue_count = 0
title_issue_count = 0
total_issues = 0
title_json = ''
title_json_url = ''
state_urls = list()
title_information = dict()
state_digitized_titles = list()
digitized_issues_year_state_total = dict()
digitized_issues_year_state_total['Connecticut'] = {}

# RETURNS JSON OF ALL DIGITIZED NEWSPAPER LIST
def get_json(url):
    data = requests.get(url)
    return(json.loads(data.content))

# LOOPS THROUGH ALL DIGITIZED LIST FOR A STATES TITLES AND RETURNS URLS IN AN ARRAY
def get_title_list(seed):
    for title in title_list_seed['newspapers']:
        if title['state'] == 'Connecticut':
            title_json_url = title['url']
            title_json_url = title_json_url
            state_urls.append(title_json_url)

# GETS LIST OF TITLES FROM ALL DIGITIZED LIST IN CHRONICLING AMERICA
title_list_seed = get_json(all_digitized_titles_json)

# CREATES ARRAY OF TITLES FOR A STATE
get_title_list(title_list_seed)

count = 0
for url in state_urls:
	title_json = get_json(url)
	
	# LOOP THROUGH COUNTING ISSUES PER YEAR 
	for issue in title_json['issues']:
		issue_date = str(issue['date_issued'])
		year = issue_date[:4]
		month = issue_date[5:7]
		day = issue_date[8:]
		if year in digitized_issues_year_state_total['Connecticut']:
			digitized_issues_year_state_total['Connecticut'][year] += 1
			total_issue_count += 1
		else:
			digitized_issues_year_state_total['Connecticut'][year] = 1
			total_issue_count += 1
		title_issue_count += 1
		title_information['total_issues'] = title_issue_count
	digitized_issues_year_state_total['Connecticut']['total_issues'] = total_issue_count
	state_digitized_titles.append(title_information.copy())

# SORTS ISSUES BY YEAR
string_total_items_sorted = sorted(digitized_issues_year_state_total['Connecticut'].items())

# OUTPUTS AS CSV FILE
with open('Connecticut_total.csv', 'w', newline='') as csv_file:
    writer = csv.writer(csv_file)
    for key, value in string_total_items_sorted:
        writer.writerow(['Connecticut', key, value])

print('done')
