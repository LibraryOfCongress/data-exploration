import os

def get_file_stats(files):
    
    # For keeping track of files, grouped by file type
    ftypes = {}

    # Loop through files
    for file in files:

        filename, file_extension = os.path.splitext(file['object_key'])

        # Skip directories
        if file_extension == '':
            continue
        
        # Keep track of count and size
        if file_extension not in ftypes:
            ftypes[file_extension] = {'Count': 0, 'Size': 0}
        ftypes[file_extension]['Count'] += 1
        ftypes[file_extension]['Size'] += file['size']

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