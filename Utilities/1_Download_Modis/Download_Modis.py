## File to download MODIS subset images
## Read the Parameter File
import os
#import shutil
import numpy as np
from io import StringIO
#import pandas as pd

parameter_l = 'parameters.txt'
path_dir = os.getcwd()
#print(type(path_dir))

path_param = os.path.join(os.path.expanduser('~'), path_dir + '/', parameter_l)
#print(path_param)

file_peram = open(path_param, 'r')
#print(file_peram)

linea_file =[]
while True:
    linea = file_peram.readline()  # lee línea
    #a = linea.find('# ParameterList:\n')
    #print(a)
    #print(linea)
    if not linea:
        break  # Si no hay más se rompe bucle
        #print(linea_h)

    linea_file.append(linea)


param_list = linea_file[6]
print(param_list)

param_text = StringIO(param_list)


#s = StringIO("ingeofa@gmail.com/2015/-53.0/-53.4/-71.6/-70.8/Sep 25/Sep 25/tiff/GEO")

param_ndarray = np.genfromtxt(param_text, dtype="U25,i8,f8,f8,f8,f8,<U6,<U6,<U6,<U6", delimiter="\t")
 
param_array = param_ndarray.item(0)

print(param_array[2])
print(type(param_array[2]))
print(len(param_array))



'''
def readParamList(file):
    """ Read the parameter List . Each row corresponds to a single simulation. 
    Order: U, V, Cw, Mn2, Hw, tauc, tauf. """
    param = np.genfromtxt(file, comments='#', delimiter=',' ,skip_header = 6)
    print(param)

readParamList(file_peram)

'''


'''
linea_file =[]

while True:
    linea = file_peram.readline()  # lee línea
    a = linea.find('1')
    #print(a)
    #print(linea)
    if not linea:
        break  # Si no hay más se rompe bucle
        #print(linea_h)

    linea_file.append(linea)
'''