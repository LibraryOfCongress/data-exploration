import os

def get_s3_bucket_stats(s3, bucket_name, prefix):
    
    # For keeping track of files, grouped by file type
    ftypes = {}

    # Since list_objects_v2 is limited to 1000 results, we need to paginate the results
    paginator = s3.get_paginator("list_objects_v2")
    page_iterator = paginator.paginate(Bucket=bucket_name, Prefix=prefix)
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