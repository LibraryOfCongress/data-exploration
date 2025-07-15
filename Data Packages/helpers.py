import os
import requests
import time

def get_s3_bucket_stats(s3, bucket_name):
    
    # For keeping track of files, grouped by file type
    ftypes = {}

    # Since list_objects_v2 is limited to 1000 results, we need to paginate the results
    paginator = s3.get_paginator("list_objects_v2")
    page_iterator = paginator.paginate(Bucket=bucket_name)
    for page in page_iterator:

        # Loop through the results
        for obj in page.get('Contents', []):
            filename, file_extension = os.path.splitext(obj['Key'])

            # Skip directories
            if file_extension == '':
                continue
            
            # Keep track of count and size
            if file_extension not in ftypes:
                ftypes[file_extension] = {'Count': 0, 'Size': 0}
            ftypes[file_extension]['Count'] += 1
            ftypes[file_extension]['Size'] += obj['Size']

    # Convert to list, sort file types by total size
    stats = [{'FileType': ext, 'Count': ftypes[ext]['Count'], 'Size': ftypes[ext]['Size']} for ext in ftypes]
    stats = sorted(stats, key=lambda s: -s['Size'])

    # Format numbers
    for i, s in enumerate(stats):
        stats[i]['Count'] = f'{s["Count"]:,}'
        kb = round(s["Size"]/1000.0)
        mb = round(s["Size"]/1000000.0)
        gb = round(s["Size"]/1000000000.0, 2)
        size = f'{kb:,}KB'
        if gb > 1:
            size = f'{gb:,}GB'
        elif mb > 1:
            size = f'{mb:,}MB'
        stats[i]['Size'] = size

    return stats


def get_file_stats(files):

    # For keeping track of files, grouped by file type
    ftypes = {}

    # Loop through files
    for file in files:

        filename, file_extension = os.path.splitext(file["object_key"])

        # Skip directories
        if file_extension == "":
            continue

        # Keep track of count and size
        if file_extension not in ftypes:
            ftypes[file_extension] = {"Count": 0, "Size": 0}
        ftypes[file_extension]["Count"] += 1
        ftypes[file_extension]["Size"] += file["size"]

    # Convert to list, sort file types by total size
    stats = [
        {"FileType": ext, "Count": ftypes[ext]["Count"], "Size": ftypes[ext]["Size"]}
        for ext in ftypes
    ]
    stats = sorted(stats, key=lambda s: -s["Size"])

    # Format numbers
    for i, s in enumerate(stats):
        stats[i]["Count"] = f'{s["Count"]:,}'
        kb = round(s["Size"] / 1000.0)
        mb = round(s["Size"] / 1000000.0)
        gb = round(s["Size"] / 1000000000.0, 2)
        size = f"{kb:,}KB"
        if gb > 1:
            size = f"{gb:,}GB"
        elif mb > 1:
            size = f"{mb:,}MB"
        stats[i]["Size"] = size

    return stats


def make_request(
    url: str,
    params={},
    headers={},
    max_attempts=10,
    timeout=60,
    pause=5,
    locgov_json=False,
    json=False,
    is_blocked=False,
    verbose=False,
):
    """
    Params:
     - url (str): URL to request.
     - params (dict): Dictionary of parameters to pass to requests.get(). Used mostly
        for API requests.
     - headers (dict): HTTP headers to pass with request, such as User-Agent.
     - max_attempts (int): Maximum number of attempts before returning a general
        error. Default = 10.
     - timeout (int): Number of seconds before requets.get() times out.
     - pause (int): Number of baseline seconds between requests. This will increase
        on retries.
     - locgov_json (bool): True means that the response is a loc.gov JSON record
     - other_json (bool): True means that the response is a JSON record (this is
        ignored if locgov_json = True)
     - is_blocked (bool): True means that the server has already returned a 429.
        This is for use in loops where you'd like to hault all requests in the
        event of a 429 status code.
     - requested_fields (list): If you would like to output only certain fields,
        list them here, e.g., ['aka','item.formats'] Default becomes {}. Only
        works if json or locgov_json is True and response is a dictionary.

    Returns:
     - is_blocked. bool.
     - result. JSON-like object if locgov_json or json are True; binary otherwise;
        or one of string error messages listed below.

    Error handling:
        Pause and retry:
            - Network/DNS issue (requests.get() error)
            - status_code 5##
            - loc.gov JSON with 'status' 5##
            - loc.gov JSON with 'status' 4## (1 retry only)
            - status code 404 if locgov_json = True (1 retry only)
        Returns `False, "ERROR - NO RECORD"`:
            - status code 404
        Returns `False, 'ERROR - INVALID JSON'`:
            - invalid loc.gov JSON
            - invalid JSON
        Returns `False,'ERROR - GENERAL'`:
            - on final attempt, returns 5## status_code or loc.gov JSON 'status'.
            - on final attempt, requests.get() error occurs
            - status code 403
        Returns `True, 'ERROR - BLOCKED'`:
            - status_code 429 (too many requests, blocked by server)
    """
    i = 0
    no_record = False, "ERROR - NO RECORD"  # value to return for URLs that don't exist
    invalid = False, "ERROR - INVALID JSON"  # value to return for invalid JSON
    error = False, "ERROR - GENERAL"  # value to return for all other errors
    blocked = True, "ERROR - BLOCKED"  # value to return after receiving a 429
    if is_blocked is True:
        print("Blocked due to too many requests. Skipping {url} {params}")
        return error
    while i < max_attempts:
        iter_pause = pause * (i + 1)
        if verbose is True:
            retry_msg = f" Trying again in {iter_pause} seconds . . ."
            if i > 0:
                print(retry_msg)
        time.sleep(iter_pause)
        if verbose is True:
            message = f"Making request. Attempt #{i+1} for: {url} {params}"
            print(message)

        try:
            response = requests.get(
                url, params=params, timeout=timeout, headers=headers
            )
        except ConnectionError as e:
            print(f"Connection error ({e}): {url} {params}.")
            i += 1
            continue
        except Exception as e:
            print(f"requests.get() failed ({e}): {url} {params}.")
            i += 1
            continue

        # 429 too many requests
        if response.status_code == 429:
            print(f"Too many requests (429). Skipping: {url} {params}.")
            return blocked

        # 500 - 599 server error
        elif (500 <= response.status_code) & (600 > response.status_code):
            print(f"Server error ({response.status_code}): {url} {params}.")
            i += 1
            continue

        # 403 forbidden
        elif response.status_code == 403:
            print(f"Forbidden request (403). Skipping: {url} {params}.")
            return error

        # 404 doesn't exist
        elif response.status_code == 404:
            if (i <= 2) and (locgov_json is True):
                if verbose is True:
                    print(
                        f"Received 404 status_code (locgov_json is True, trying another time): {url} {params}."
                    )
                i += 1
                continue
            else:
                print(f"Resource does not exist (404). Skipping: {url} {params}.")
                return no_record

        # Verify JSON (if applicable)
        if locgov_json is True:
            try:
                output = response.json()
                status = str(output.get("status"))

                # loc.gov JSON 4##
                if status.startswith("4"):
                    if i > 2:  # only makes two attempts
                        message = f"Resource does not exist (loc.gov {status}). Skipping: {url} {params}."
                        print(message)
                        return False, no_record
                    else:
                        if verbose is True:
                            print("Received loc.gov JSON 404: {url} {params}")
                        i += 1
                        continue

                # loc.gov JSON 5##
                elif status.startswith("5"):
                    if verbose is True:
                        message = (
                            f"Server error ({status}). Request for {url} {params}."
                        )
                        print(message)
                    i += 1
                    continue

                # loc.gov valid JSON
                else:
                    # Success, return the loc.gov JSON record
                    if verbose is True:
                        print(f"Successfull request (loc.gov JSON): {url} {params}")
                    # Proceed to RETURN SUCCESSFUL RESULT

            # loc.gov invalid JSON
            except Exception as e:
                print(f"INVALID JSON ({e}): {url} {params}")
                return invalid

        elif json is True:
            try:
                output = response.json()
                if verbose is True:
                    print(f"Successfull request (JSON): {url} {params}")
                # Proceed to RETURN SUCCESSFUL RESULT
            except Exception as e:
                print(f"INVALID JSON ({e}): {url} {params}")
                return invalid

        else:
            output = response
            if verbose is True:
                print(f"Successfull request: {url} {params}")
            # Proceed to RETURN SUCCESSFUL RESULT

        # RETURN SUCCESSFUL RESULT
        return False, output

    # If hits max attempts, return general error
    return error
