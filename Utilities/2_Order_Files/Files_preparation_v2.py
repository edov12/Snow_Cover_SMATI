# #!/usr/bin/env python3
# This script orders the anual downloaded files, from the Earthdata, for the correct execution of the main scripts application
# If you like to used the download SMATI location you can left the source and deatination argument as '.'

import argparse
import sys
import os
import shutil

DESC = "This script orders the anual downloaded files, from the Earthdata, for the correct execution of the main scripts application"


def _order(source, destination, year, check_name):
    folder_MOD09GA = 'MOD09GA'
    folder_MOD09GQ = 'MOD09GQ'
    folder_MOD35 = 'MOD35'
    #Folder_1 = 'Brunswick_Final'
    Folder_2 = year
    #Folder_3 = 'Brunswick'
    archivolec = 'checksums_502266192' # Comment after the test!

    File_ord = 'Order_files'

    if source == '.' and destination == '.':
        source_1 = os.getcwd()
        source = source_1
        #source_2 = source_1
        source = os.chdir("..")
        source = os.chdir('./4_Example_Data/Brunswick/'+ year)
        source = os.getcwd()

        source_2 = os.chdir("..")
        source_2 = os.chdir("..")
        source_2 = os.chdir("./Order_files/Reflectance_bands")
        source_2 = os.getcwd()


    

    path_1 = source + '/' + archivolec

    path_2 = source_2

    #path_3 = os.path.join(os.path.expanduser('~'), source)

    return print(path_1, path_2)




def _main(argv):
    #parser = argparse.ArgumentParser(description = 'Order Files Script')
    parser = argparse.ArgumentParser(prog=argv[0], description=DESC)
    parser.add_argument('-s', '--source', metavar='DIR', help = 'the input folder path', required=True)
    parser.add_argument('-d', '--destination', metavar='DIR', help = 'the destination folder path', required=True)
    parser.add_argument('-y', '--year', help = 'year to order', required=True)
    parser.add_argument('-n', '--check_name', help = 'checksums name', required=True)
    #self.inp_path = parser.add_argument('-inp_p', help = "put your input path")

    args = parser.parse_args(argv[1:])
    '''
    if not os.path.exists(args.destination):
        os.makedirs(args.destination)
    return args.source, args.destination, args.year, args.check_name
    '''
    return _order(args.source, args.destination, args.year, args.check_name)






if __name__ == '__main__':
    try:
        #print('hola')
        #print(sys.argv[0])
        sys.exit(_main(sys.argv))
        #print(sys.exit(_main(sys.argv)))
        #_main()

        #_order(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4])

        #print(sys.argv)
    except KeyboardInterrupt:
        sys.exit(-1) # tells the program to quit
        #print('hola2')
    
    print('hola')
