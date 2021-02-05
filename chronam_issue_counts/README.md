<h1>Overview</h1>
<p>The scripts available here will calculate the number of digitized newspaper issues available year by year, state by state in Chronicling America, the Library of Congress’ database of historic American newspapers.</p>
<p>The primary script is named "state_issues.py" and will create a .csv file of the number of digitized issues available in Chronicling America for each year of digitized content from state partners that is available.</p>
<p>Please visit https://chroniclingamerica.loc.gov/about/api/  for background information about the various views of data available from Chronicling America.</p>

<h1>Output</h1>
<b>state_issues.py</b>
<p>The output from this script is one .csv file named "[state name]_total.csv". Each row in the .csv contains the state name, year, and number of issues available in Chronicling America.</p>

<h1>Dependencies</h1>
<p>To run this script, you'll need to have Python 3 installed and the requests library downloaded. You will also need access to a command line interface such as Terminal on OS X, Anaconda on Windows, or other.</p>

<h1>Instructions</h1>
<p>Save the "state_issues.py" and "ISO_3166-2:US.txt" files to a folder where you want the results file saved. Using the command line interface, navigate to the folder.</p>

<p>Run the script by typing: <code>python state_issues.py [two letter state code or full state name]</code></p>
<p>Ex: <code>python state_issues.py TN</code></p>
<p>Ex: <code>python state_issues.py Tennessee</code></p>
<p>State names with multiple words should be wrapped in quotes.</p>
<p>Ex: <code>python state_issues.py "District of Columbia"</code></p>
<p>There is no indication printed to the console that the script is running. When the script is complete, "done" will be printed to the console.</p>
<p>Optionally, input validation can be skipped by adding the force flag.</p>
<p>Ex: <code>python state_issues.py Piedmont --force</code></p>


<h1>Implementation</h1>
<p>We used this script to pull data from Chronicling America to create data visualizations available at http://www.loc.gov/ndnp/data-visualizations/.</p> 

<h1>Next Steps</h1>
<p>Please provide any feedback you may have by filing an issue.</p>

<p>If you use this script, please let us know at <a href="https://twitter.com/LC_Labs">LC Labs</a> or <a href="mailto:ndnptech@loc.gov">ndnptech@loc.gov</a>.</p>

<p>For additional information about accessing the Library of Congress’ collections programmatically please visit <a href="https://labs.loc.gov/lc-for-robots/">LC for Robots</a>.</p>

<h1>Rights Statement</h1>
<p>Script is free to use and reuse without restriction.</p>
