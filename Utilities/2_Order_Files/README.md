## This script is for order de data before the main scripts application:


### To apply this script:

**Run in the terminal:**

    python Files_preparation_v2.py -s <source_file> -d <destination_file> -y <year> -n <check_name>
1. -s DIR, source_file DIR
- finish this path with the year i.e.: /2015
- also you can put only '.' if you want to use the example files
2. -d DIR, destination DIR, 
- the path to the place to order your files
- also you can put only 'Brunswick' if you want to use the example files
- important to note that the outputs are placed in the folder ./Outputs/Order_files/*<destination_file>*/Reflectance_bands
- so this sub-folder must be created inside this destination directory
3. -y YEAR, year, the year that you need to process
4. -n check_name, checksums name file that has all the record files downloaded
