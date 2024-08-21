>## To create a Download request in [Earthdata](https://ladsweb.modaps.eosdis.nasa.gov):
**Run in the terminal:**

    python Download_Modis.py -s <parameter_file>
1. -s <parameter_file>, is the name of the file that has all the information associated with the parameters required for the download order.
2. Depending on the availability of the server and the bandwidth connection, it is possible that the time may not allow the order to be completed, resulting in the following error: *504 Gateway Time-out at ./Modis_Script/order_MWS.pl line 682*, in this case the order must be repeated until the placed orders number is obtained.
3. More information can be found at [LAADS Web Service Classic Quick Start Guide] (https://ladsweb.modaps.eosdis.nasa.gov/tools-and-services/lws-classic/quick-start)

>## To Download the order requested:
**Run in the terminal:**

    python laads-data-download.py -s <URL> -d <DIR> -t <TOK>
1. -s URL, --source URL  Recursively download files at URL, i.e.: *https://ladsweb.modaps.eosdis.nasa.gov/archive/orders/50226xxxx/*
2. -d DIR, --destination DIR, Store directory structure in DIR
3. -t TOK, --token TOK   Use app token TOK to authenticate form [Generate a Bearer Token](https://urs.earthdata.nasa.gov/users/)

**Script download** from [How to Use LAADS Data with Download Scripts](https://ladsweb.modaps.eosdis.nasa.gov/tools-and-services/data-download-scripts/#python)