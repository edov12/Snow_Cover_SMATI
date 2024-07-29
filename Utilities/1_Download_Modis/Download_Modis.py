#!/usr/bin/env python3

## File to download MODIS subset images
## Read the Parameter File
import os
import numpy as np
from io import StringIO
import subprocess



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
        
        self.param_list = linea_file[6]
        param_text = StringIO(self.param_list)
        param_ndarray = np.genfromtxt(param_text, dtype="U25,i8,f8,f8,f8,f8,<U6,<U6,<U6,<U6", delimiter="\t")
        self.param_array = param_ndarray.item(0)
        self.name_account = self.param_array[0] # Variable publica
        self.year = self.param_array[1]
        self.north = self.param_array[2]
        self.south = self.param_array[3]
        self.west = self.param_array[4]
        self.east = self.param_array[5]
        self.stat_time = self.param_array[6]
        self.end_time = self.param_array[7]
        self.format = self.param_array[8]
        self.proj = self.param_array[9]
     
        
if __name__ == "__main__":
    parameter_file = Parameter_Modis('parameters.txt')
    '''
    print('perl order.pl -a ' + parameter_file.name_account + ' -c 61 -t "' + parameter_file.stat_time
          + ', '+ str(parameter_file.year) + ' 00:00:00" -u "' + parameter_file.end_time + ', ' + str(parameter_file.year) + ' 23:59:59" -resample Nearest,Mosaic -format' +
          parameter_file.format + ' -n ' + str(parameter_file.north) + ' -w ' + str(parameter_file.west) + ' -s ' + str(parameter_file.south) + ' -e ' + str(parameter_file.east) + ' -proj ' +
          parameter_file.proj + ' -to_do post-process "MOD09GA___sur_refl_b01_1" "MOD09GA___sur_refl_b02_1" "MOD09GA___sur_refl_b03_1" "MOD09GA___sur_refl_b04_1" "MOD09GA___sur_refl_b05_1" "MOD09GA___sur_refl_b06_1" "MOD09GA___sur_refl_b07_1" "MOD09GA___SolarZenith_1"' +
          ' "MOD09GQ___sur_refl_b01_1" "MOD09GQ___sur_refl_b02_1" "MOD35_L2___Cloud_Mask"')
    '''
    
    res = subprocess.call('perl order.pl -a ' + parameter_file.name_account + ' -c 61 -t "' + parameter_file.stat_time
          + ', '+ str(parameter_file.year) + ' 00:00:00" -u "' + parameter_file.end_time + ', ' + str(parameter_file.year) + ' 23:59:59" -resample Nearest,Mosaic -format' +
          parameter_file.format + ' -n ' + str(parameter_file.north) + ' -w ' + str(parameter_file.west) + ' -s ' + str(parameter_file.south) + ' -e ' + str(parameter_file.east) + ' -proj ' +
          parameter_file.proj + ' -to_do post-process "MOD09GA___sur_refl_b01_1" "MOD09GA___sur_refl_b02_1" "MOD09GA___sur_refl_b03_1" "MOD09GA___sur_refl_b04_1" "MOD09GA___sur_refl_b05_1" "MOD09GA___sur_refl_b06_1" "MOD09GA___sur_refl_b07_1" "MOD09GA___SolarZenith_1"' +
          ' "MOD09GQ___sur_refl_b01_1" "MOD09GQ___sur_refl_b02_1" "MOD35_L2___Cloud_Mask"')
    #res = subprocess.call('perl ./Modis_Script/order_MWS.pl -c 61 -t "Aug 1, 2008 00:00:00" -u "Aug 1, 2008 23:59:59" -n 5.0 -w 100.0 -s -10.0 -e 125.0 -to_do list MOD021KM MYD021KM', shell=True)
    res
    
        
        
