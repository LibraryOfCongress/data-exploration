"""
A simple python script demonstrating how you can bulk download files
from a Library of Congress Data Package (https://data.labs.loc.gov/packages/).

Example usage:
    python bulk_download.py --package "https://data.labs.loc.gov/free-to-use/" --out "output/free-to-use/"
"""

import argparse
import os

import requests
from tqdm import tqdm

parser = argparse.ArgumentParser()
parser.add_argument(
    "--package", dest="PACKAGE", default="https://data.labs.loc.gov/free-to-use/", help="The data package URL from https://data.labs.loc.gov/packages/"
)
parser.add_argument(
    "--out", dest="OUTPUT_DIR", default="output/free-to-use/", help="Output directory"
)
parser.add_argument(
    "--dryrun", dest="DRYRUN", action="store_true", help="Just output the details; do not download files"
)
args = parser.parse_args()

def bulk_download(package_url: str, output_dir: str, dryrun: bool=False) -> None:
    """Bulk download a Library of Congress data package"""

    # Download the manifest file
    file_manifest_url = f"{package_url}manifest.json"
    response = requests.get(file_manifest_url, timeout=300)
    response_json = response.json()
    files = [dict(zip(response_json["cols"], row)) for row in response_json["rows"]] # zip columns and rows

    # Iterate over files
    for file in tqdm(files):
        url = f"https://{file['object_key']}"
        filename = f"{output_dir}{file['filename']}"

        if dryrun:
            print(f"{url} -> {filename}")
            continue

        # Make sure directory exists
        dirname = os.path.dirname(filename)
        if not os.path.exists(dirname):
            os.makedirs(dirname)

        # Use streaming for large files
        r = requests.get(url, stream=True, timeout=120)
        with open(filename, "wb") as f:
            for chunk in r.iter_content(chunk_size=1024):
                if chunk:  # filter out keep-alive new chunks
                    f.write(chunk)

    print("Done.")


bulk_download(args.PACKAGE, args.OUTPUT_DIR, args.DRYRUN)
