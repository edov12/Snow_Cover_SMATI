#!/usr/bin/env python3

## File to download MODIS subset images
## Read the Parameter File

import os
import numpy as np
from io import StringIO
import subprocess

import argparse
import sys



class Parameter_Modis:
    def __init__(self, p_file):
        self.p_file = p_file
        
        self.path_dir = os.getcwd()
        path_param = os.path.join(os.path.expanduser('~'), self.path_dir + '/', self.p_file)
        file_peram = open(path_param, 'r')
        
        linea_file =[]
        while True:
            linea = file_peram.readline()
            if not linea:
                break
            linea_file.append(linea)
        
        
        _init_year_list = linea_file[7] # initial year
        _init_year_text = StringIO(_init_year_list)
        _init_year_ndarray = np.genfromtxt(_init_year_text, dtype="U25,i8", delimiter="\t")
        _init_year_array = _init_year_ndarray.item(0)
        self.init_year = _init_year_array[1]
        
        
        _final_year_list = linea_file[8]    # final year 
        _final_year_text = StringIO(_final_year_list)
        _final_year_ndarray = np.genfromtxt(_final_year_text, dtype="U25,i8", delimiter="\t")
        _final_year_array = _final_year_ndarray.item(0)
        self.final_year = _final_year_array[1]
        
        _param_list = linea_file[9] # line with the parameters
        _param_text = StringIO(_param_list)
        _param_ndarray = np.genfromtxt(_param_text, dtype="U25,f8,f8,f8,f8,<U6,<U6,<U6,<U6", delimiter="\t")
        _param_array = _param_ndarray.item(0)
        self.name_account = _param_array[0]
        self.north = _param_array[1]
        self.south = _param_array[2]
        self.west = _param_array[3]
        self.east = _param_array[4]
        self.start_time = _param_array[5]
        self.end_time = _param_array[6]
        self.format = _param_array[7]
        self.proj = _param_array[8]
     
def _main(argv):
    parser = argparse.ArgumentParser(prog=argv[0], description='parameter file')
    parser.add_argument('-s', '--source', metavar='DIR', help = 'the parameter file', required=True)
    args = parser.parse_args(argv[1:])
    
    return Parameter_Modis(args.source)





     
if __name__ == "__main__":
    parameter_file = _main(sys.argv)
    
    n_years = (parameter_file.final_year - parameter_file.init_year) + 1
    
    #print(n_years)
   
    if n_years == 1:
        
        res = subprocess.call('perl ./Modis_Script/order_MWS.pl -a ' + parameter_file.name_account + ' -c 61 -t "' + parameter_file.start_time
              + ', '+ str(parameter_file.init_year) + ' 00:00:00" -u "' + parameter_file.end_time + ', ' + str(parameter_file.init_year) + ' 23:59:59" -resample Nearest,Mosaic -format ' +
              parameter_file.format + ' -n ' + str(parameter_file.north) + ' -w ' + str(parameter_file.west) + ' -s ' + str(parameter_file.south) + ' -e ' + str(parameter_file.east) + ' -proj ' +
              parameter_file.proj + ' -to_do post-process "MOD09GA___sur_refl_b01_1" "MOD09GA___sur_refl_b02_1" "MOD09GA___sur_refl_b03_1" "MOD09GA___sur_refl_b04_1" "MOD09GA___sur_refl_b05_1" "MOD09GA___sur_refl_b06_1" "MOD09GA___sur_refl_b07_1" "MOD09GA___SolarZenith_1"' +
              ' "MOD09GQ___sur_refl_b01_1" "MOD09GQ___sur_refl_b02_1" "MOD35_L2___Cloud_Mask"', shell=True)
        
        res
        

        
    else:
        years = []
        
        for y in range(n_years):
            years.append(parameter_file.init_year + y)
        
        for year in years:
            res = subprocess.call('perl ./Modis_Script/order_MWS.pl -a ' + parameter_file.name_account + ' -c 61 -t "' + parameter_file.start_time
                  + ', '+ str(year) + ' 00:00:00" -u "' + parameter_file.end_time + ', ' + str(year) + ' 23:59:59" -resample Nearest,Mosaic -format ' +
                  parameter_file.format + ' -n ' + str(parameter_file.north) + ' -w ' + str(parameter_file.west) + ' -s ' + str(parameter_file.south) + ' -e ' + str(parameter_file.east) + ' -proj ' +
                  parameter_file.proj + ' -to_do post-process "MOD09GA___sur_refl_b01_1" "MOD09GA___sur_refl_b02_1" "MOD09GA___sur_refl_b03_1" "MOD09GA___sur_refl_b04_1" "MOD09GA___sur_refl_b05_1" "MOD09GA___sur_refl_b06_1" "MOD09GA___sur_refl_b07_1" "MOD09GA___SolarZenith_1"' +
                  ' "MOD09GQ___sur_refl_b01_1" "MOD09GQ___sur_refl_b02_1" "MOD35_L2___Cloud_Mask"', shell=True)
            
            res
        
