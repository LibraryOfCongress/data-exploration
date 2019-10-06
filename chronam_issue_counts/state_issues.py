#!/usr/bin/env python
# -*- coding: UTF-8 -*-
import argparse
import csv
import json

import requests


# URL for all digitized titles
all_digitized_titles_url = 'http://chroniclingamerica.loc.gov/newspapers.json'

iso_3166_2_US_file = './ISO_3166-2:US.txt'


# RETURNS JSON OF ALL DIGITIZED NEWSPAPER LIST
def get_json(url):
    data = requests.get(url)
    return json.loads(data.content)

# LOOPS THROUGH ALL DIGITIZED LIST FOR A STATE'S TITLES AND RETURNS URLS IN A LIST
def get_title_urls_for_state(data, state):
    state_title_urls = []
    for title in data['newspapers']:
        if title['state'] == state:
            state_title_urls.append(title['url'])
    return state_title_urls

def parse_state_arg(state_arg):

    # NOTE: this should be removed if data problem resolved
    if state_arg in ['Piedmont']:
        return state_arg

    with open(iso_3166_2_US_file, 'r') as f:
        iso_3166_2_US_data = json.load(f)
    verified_state_name = None
    if len(state_arg) == 2:
        for state in iso_3166_2_US_data['ISO_3166-2:US']:
            if state_arg == state['short_code']:
                verified_state_name = state['subdivision_name']
    else:
        for state in iso_3166_2_US_data['ISO_3166-2:US']:
            if state_arg == state['subdivision_name']:
                verified_state_name = state['subdivision_name']
    if not verified_state_name:
        print('Invalid input: "{0}". Run "python state_issues.py --help" for more info on valid values.'.format(
            state_arg
        ))
        raise Exception
    
    return verified_state_name

def main(args):

    if not args.force:
        state_name = parse_state_arg(args.state)
    else:
        state_name = args.state

    total_issue_count = 0
    title_issue_count = 0
    title_json = ''
    title_information = {}
    state_digitized_titles = []
    digitized_issues_year_state_total = {}
    digitized_issues_year_state_total[state_name] = {}

    # GETS LIST OF TITLES FROM ALL DIGITIZED LIST IN CHRONICLING AMERICA
    title_data = get_json(all_digitized_titles_url)

    # CREATES ARRAY OF TITLES FOR A STATE
    state_urls = get_title_urls_for_state(title_data, state_name)

    for url in state_urls:
        title_json = get_json(url)
        
        # LOOP THROUGH COUNTING ISSUES PER YEAR 
        for issue in title_json['issues']:
            issue_date = str(issue['date_issued'])
            year = issue_date[:4]
            if year in digitized_issues_year_state_total[state_name]:
                digitized_issues_year_state_total[state_name][year] += 1
                total_issue_count += 1
            else:
                digitized_issues_year_state_total[state_name][year] = 1
                total_issue_count += 1
            title_issue_count += 1
            title_information['total_issues'] = title_issue_count
        digitized_issues_year_state_total[state_name]['total_issues'] = total_issue_count
        state_digitized_titles.append(title_information.copy())

    # SORTS ISSUES BY YEAR
    string_total_items_sorted = sorted(digitized_issues_year_state_total[state_name].items())

    if not string_total_items_sorted:
        print('no data available for {0}'.format(state_name))
        return

    # OUTPUTS AS CSV FILE
    filename = '{0}_total.csv'.format(state_name)
    with open(filename, 'w', newline='') as csv_file:
        writer = csv.writer(csv_file)
        for key, value in string_total_items_sorted:
            writer.writerow([state_name, key, value])

    print('done')
    print('file saved at {0}'.format(filename))


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument(
        'state', help='''Specify a single state. 
        Valid values are two letter state codes or full state names. 
        See https://en.wikipedia.org/wiki/ISO_3166-2:US for all valid values.'''
    )
    parser.add_argument(
        '-f', '--force', action='store_true', default=False, help='''Use "force" 
        flag to skip validation on user input.'''
    )
    args = parser.parse_args()
    main(args)