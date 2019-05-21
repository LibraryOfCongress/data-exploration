<h1>Overview</h1>
This script creates a .csv file of all digitized titles available in Chronicling America, the Library of Congress’ database of historic American newspapers.  Please visit https://chroniclingamerica.loc.gov/about/api/  for background information about the various views of data available from Chronicling America. 

While most of the information related to all digitized titles can be downloaded directly from https://chroniclingamerica.loc.gov/newspapers/, this script also parses the JSON information for each title (e.g. https://chroniclingamerica.loc.gov/lccn/sn85025905.json) in order to also grab the associated hierarchical place information (state, county, city) for each title. 


<h1>Output</h1>
The output from this script is one .csv file named ‘chronam_all_digitized.csv’. Each row in the .csv represents one title and its associated title-level descriptive metadata fields. Information is saved in the .csv in the following order: State, LCCN, Title, JSON view of the Title URL, Issue count, First issue, Last issue, Place(s) of publication.


<h1>Dependencies</h1>
To run this script, you'll need to have Python 3 installed. You will also need access to a command line interface such as Terminal on OS X, Anaconda on Windows, or other.

<h1>Instructions</h1>

Save the chronam_all_digitized_titles.py file to a folder where you want the results file saved.  Using the command line interface, navigate to the folder.

Run the script by typing: python chronam_all_digitized.py

As a notification that the script is running, you will see the information being gathered for each title printed to the console.  When the script is done running, a count of the number of digitized titles and the word ‘done’ will be printed to the console. A file called chronam_all_digitized.csv will appear at the location where the script was run.

<h1>Customizations</h1>
The script can be edited to add, omit, or change the order of specific fields.  

<h1>Implementation</h1>
We used this script to pull data from Chronicling America to create data visualizations available at http://www.loc.gov/ndnp/data-visualizations/. 

<h1>Next Steps</h1>
Please provide any feedback you may have by creating a ticket.

If you use this script, please let us know at <a href="https://twitter.com/LC_Labs">LC Labs</a> or <a href="mailto:ndnptech@loc.gov">ndnptech@loc.gov</a>.

For additional information about accessing the Library of Congress’ collections programmatically please visit <a href="https://labs.loc.gov/lc-for-robots/">LC for Robots</a>.

