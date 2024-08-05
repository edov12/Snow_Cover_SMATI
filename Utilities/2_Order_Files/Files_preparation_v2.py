# Ordena los Archivos Anuales

#from osgeo import gdal
#import numpy as np
#from osgeo import gdal_array
import os
#from pyhdf.SD import SD, SDC
#import matplotlib.pyplot as pyplot
import shutil

folder_MOD09GA = 'MOD09GA'
folder_MOD09GQ = 'MOD09GQ'
folder_MOD35 = 'MOD35'
#folder_Zenith = 'Zenith'
Folder_1 = 'Brunswick_Final'
Folder_2 = '2020'
Folder_3 = 'Brunswick'
archivolec = 'checksums_501684320'

File_ord = 'Order_files'
#carpeta3 = '3'
#archivolec = 'checksums_501682267'

#archivolec = '2016_File_master' #??

#path_1 = os.path.join(os.path.expanduser('~'), 'Documents/DATA', carpeta1, carpeta2,carpeta3, archivolec)

path_1 = os.path.join(os.path.expanduser('~'), 'Documents/Data/Data_modis', Folder_1, Folder_2, archivolec)

path_2 = os.path.join(os.path.expanduser('~'), 'Documents/Data/Data_modis', File_ord)

path_3 = os.path.join(os.path.expanduser('~'), 'Documents/Data/Data_modis', Folder_1, Folder_2)

#print(path_1)

file = open(path_1, 'r')
#print(file.readline())

linea_file =[]
#linea_MOD09GQ =[]
#linea_MOD35 =[]

narchivos_MOD09GA = []
narchivos_MOD09GQ = []
narchivos_MOD35 = []

cont_file = 0
#cont_MOD09GQ = 0
#cont_MOD35 = 0

while True:
    linea = file.readline()  # lee línea
    a = linea.find('MOD09GA')
    d = linea.find('MOD09GQ')
    e = linea.find('MOD35')
    #print(a)
    #print(linea)

    if not linea:
        break  # Si no hay más se rompe bucle
        #print(linea_h)

    linea_file.append(linea)

    if a >= 0:
        b = len(linea_file[cont_file])

        c = linea_file[cont_file]

        narchivos_MOD09GA.append(c[a:b - 1])

        # print(narchivos[cont])
    elif d >= 0:
        b = len(linea_file[cont_file])

        c = linea_file[cont_file]

        narchivos_MOD09GQ.append(c[d:b - 1])
    
    elif e >= 0:
        b = len(linea_file[cont_file])

        c = linea_file[cont_file]

        narchivos_MOD35.append(c[e:b - 1])

    cont_file = cont_file + 1
# create sub folders
MOD09GA_dir = os.mkdir(path_2 +'/' + Folder_3+'/'+Folder_2+'/MOD09GA')
MOD09GQ_dir = os.mkdir(path_2 +'/' + Folder_3+'/'+Folder_2+'/MOD09GQ')
MOD35_dir = os.mkdir(path_2 +'/' + Folder_3+'/'+Folder_2+'/MOD35')



#MOD09GA Files
for k in narchivos_MOD09GA:
    #narchivos_year.append(k)
    #l = l + 1
    #print(k)
    shutil.copy2(path_3 + '/' + k,
                     path_2 +'/' + Folder_3+'/'+Folder_2+'/MOD09GA')

#MOD09GQ Files
for j in narchivos_MOD09GQ:
    #narchivos_year.append(k)
    #l = l + 1
    #print(k)
    shutil.copy2(path_3 + '/' + j,
                     path_2 +'/' + Folder_3+'/'+Folder_2+'/MOD09GQ')

#MOD35 Files
for l in narchivos_MOD35:
    #narchivos_year.append(k)
    #l = l + 1
    #print(k)
    shutil.copy2(path_3 + '/' + l,
                     path_2 +'/' + Folder_3+'/'+Folder_2+'/MOD35')


# write the yearly master files
with open(path_2+'/'+Folder_3+'/'+Folder_2+'/MOD09GA/'+Folder_2+'_MOD09GA', 'w') as f:
    f.writelines("%s\n" % lin for lin in narchivos_MOD09GA)

f.close()

with open(path_2+'/'+Folder_3+'/'+Folder_2+'/MOD09GQ/'+Folder_2+'_MOD09GQ', 'w') as f:
    f.writelines("%s\n" % lin for lin in narchivos_MOD09GQ)

f.close()

with open(path_2+'/'+Folder_3+'/'+Folder_2+'/MOD35/'+Folder_2+'_MOD35', 'w') as f:
    f.writelines("%s\n" % lin for lin in narchivos_MOD35)

f.close()