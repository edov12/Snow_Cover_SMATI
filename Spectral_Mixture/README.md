## This script is to apply the Spectral Unmixing into your files:
This script is working for a full year of images
This is the 2° script and run on your downscaled images

### To apply this script:

**Run in the terminal:**

    Rscript Snow_reconst_filter_v2.R -n <folder_name> -y <year>
    
1. -n --name, the name of your main folder, as in the example: ***Brunswick***
2. -y --year, the year to apply this script
3. Important to note that the folder named: ***Mesma_albedo*** must be created inside the folder ./Order_files/<name>, befor run this script