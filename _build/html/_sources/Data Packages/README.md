# Resources for using Library of Congress Data Packages

This is a growing collection of resources (Jupyter Notebooks, scripts, workflows) for accessing and using [data packages from the Library of Congress](https://data.labs.loc.gov/packages/).

## Requirements

To run the Jupyter Notebooks you will need to change into this directory and install the required Python libraries:

```
cd "Data Packages"
pip install -r requirements.txt
```

## Bulk downloading

The [bulk_download.py](https://github.com/LibraryOfCongress/data-exploration/blob/master/Data%20Packages/bulk_download.py) is a simple script for downloading files from a Data Package in bulk. For example, this command will download all the images in the [Free to Use and Reuse Data Package](https://data.labs.loc.gov/free-to-use/):

```
python bulk_download.py --package "https://data.labs.loc.gov/free-to-use/" --out "output/free-to-use/"
```

## Data Package notebooks

Each data package has a Jupyter notebook demonstrating how to access and use that data package:

- [Sanborn Data Package](https://github.com/LibraryOfCongress/data-exploration/blob/master/Data%20Packages/sanborn.ipynb)
- [Free to Use and Reuse Data Package](https://github.com/LibraryOfCongress/data-exploration/blob/master/Data%20Packages/free-to-use.ipynb)
- [National Jukebox Data Package](https://github.com/LibraryOfCongress/data-exploration/blob/master/Data%20Packages/jukebox.ipynb)
- [Digitized Books Data Package](https://github.com/LibraryOfCongress/data-exploration/blob/master/Data%20Packages/digitized-books.ipynb)
- [Directory Holdings Data Package](https://github.com/LibraryOfCongress/data-exploration/blob/master/Data%20Packages/directories.ipynb)
- [Telephone Directories Data Package](https://github.com/LibraryOfCongress/data-exploration/blob/master/Data%20Packages/telephone.ipynb)
- [Selected Dot Gov Media Types, Web Archives Data Package](https://github.com/LibraryOfCongress/data-exploration/blob/master/Data%20Packages/dot-gov-pdf.ipynb)
- [Stereograph Card Images Data Package](https://github.com/LibraryOfCongress/data-exploration/blob/master/Data%20Packages/stereographs.ipynb)
- [Austro-Hungarian Map Set Data Package](https://github.com/LibraryOfCongress/data-exploration/blob/master/Data%20Packages/austro-hungarian-maps.ipynb)
- [General Collection Assessment Data Package](https://github.com/LibraryOfCongress/data-exploration/blob/master/Data%20Packages/gen-coll-assessment.ipynb)
- [United States Elections, Web Archives Data Package](https://github.com/LibraryOfCongress/data-exploration/blob/master/Data%20Packages/us-elections.ipynb)
