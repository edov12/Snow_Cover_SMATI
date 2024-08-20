## This script is to apply the Temporal Interpolation into your files:
This script is working for a full year of images
This is the 3° script and run on your spectral unmixed images

Before running this script, select a reference image, such as the one in the example:
***./Order_files/Brunswick/Mesma_albedo/2015/2015_268_mesma_albedo.tif*** as a referent of the correct dimensions

### To apply this script:

**Run in the terminal:**
    Rscript Snow_reconst_filter_v2.R -n <folder_name> -y <year>

1. -n --name, the name of your main folder, as in the example: ***Brunswick***
2. -y --year, the year to apply this script
3. Important to note that the folder named: ***Snow_Interpolation*** must be created inside the folder ./Order_files/<name>, befor run this script