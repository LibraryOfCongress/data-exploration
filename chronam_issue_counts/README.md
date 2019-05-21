<h1>Overview</h1>
<p>The scripts available here will calculate the number of digitized newspaper issues available year by year, state by state in Chronicling America, the Library of Congress’ database of historic American newspapers.</p>  
<p>Each script is named “state_issues_year_2019_[state_abbreviation]” and will create a .csv file of the number of digitized issues available in Chronicling America for each year of digitized content from state partners that is available.</p>
<p>Please visit https://chroniclingamerica.loc.gov/about/api/  for background information about the various views of data available from Chronicling America.</p>

<h1>Output</h1>
<b>state_issues_year_2019_DC.py or other files with state/territory abbreviations</b>
<p>The output from this script is one .csv file named "District of Columbia_total.csv". Each row in the .csv contains the state name, year, and number of issues available in Chronicling America.</p>
<b>state_issues_year_2019_NOSTATE</b>
<p>Use find and replace for "STATE_NAME" with the state or territory name you want the script run for. The output from this script is one .csv file named "STATE_NAME_total.csv". Each row in the .csv contains the state name, year, and number of issues available in Chronicling America.</p>

<h1>Dependencies</h1>
<p>To run this script, you'll need to have Python 3 installed. You will also need access to a command line interface such as Terminal on OS X, Anaconda on Windows, or other.</p>

<h1>Instructions</h1>
<p>Save the "state_issues_year_2019_[state_abbreviation]" file to a folder where you want the results file saved.  Using the command line interface, navigate to the folder.</p>

<p>Run the script by typing: "python state_issues_year_2019_[state_abbreviation]"</p>
<p>Ex: python state_issues_year_2019_DC.py</p>
<p>There is no indication printed to the console that the script is running. When the script is complete, "done" will be printed to the console.</p>

<h1>Customizations</h1>
<p>The scripts can be changed to run for any state. The template file is state_issues_year_2019_NOSTATE.py. To change the states issues being counted, use find for "NO STATE" and replace for the state or territory name you would like the script run on.  There is an issue count script for each state and territory available in Chronicling America as of May 2019. As additional content from new state partners is added to Chronicling America, the state_issues_year_2019_NOSTATE.py file can be updated to add the state information by using find "STATE_NAME" and replace with the state/territory you would like to add.</p>

<h1>Implementation</h1>
<p>We used this script to pull data from Chronicling America to create data visualizations available at http://www.loc.gov/ndnp/data-visualizations/.</p> 

<h1>Next Steps</h1>
<p>Please provide any feedback you may have by filing an issue.</p>

<p>If you use this script, please let us know at <a href="https://twitter.com/LC_Labs">LC Labs</a> or <a href="mailto:ndnptech@loc.gov">ndnptech@loc.gov</a>.</p>

<p>For additional information about accessing the Library of Congress’ collections programmatically please visit <a href="https://labs.loc.gov/lc-for-robots/">LC for Robots</a>.</p>

<h1>Rights Statement</h1>
<p>Script is free to use and reuse without restriction.</p>
