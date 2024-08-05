>## To create a Download request in [Earthdata](https://ladsweb.modaps.eosdis.nasa.gov):


>## To Download the order requested:
**Run in the terminal:**

    python laads-data-download.py -s <URL> -d <DIR>
1. -s URL, --source URL  Recursively download files at URL, i.e.: *https://ladsweb.modaps.eosdis.nasa.gov/archive/orders/50226xxxx/*
2. -d DIR, --destination DIR, Store directory structure in DIR
3. -t TOK, --token TOK   Use app token TOK to authenticate form [Generate a Bearer Token](https://urs.earthdata.nasa.gov/users/)

**Script download** from [How to Use LAADS Data with Download Scripts](https://ladsweb.modaps.eosdis.nasa.gov/tools-and-services/data-download-scripts/#python)
