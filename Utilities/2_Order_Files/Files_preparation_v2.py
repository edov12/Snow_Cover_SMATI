# #!/usr/bin/env python3
# This script orders the anual downloaded files, from the Earthdata, for the correct execution of the main scripts application

import argparse
#import sys
import os
import shutil

'''
def order_files(self, inp_path, out_path, year, name_checksums):
    parser = argparse.ArgumentParser(description = 'Order Files Script')
    self.inp_path = parser.add_argument('-inp_p', help = "put your input path")
'''



if __name__ == '__main__':
    parser = argparse.ArgumentParser(description = 'Order Files Script')
    #parser.add_argument('-h', help = "put your input path")
    parser.add_argument('-i_p', '--inp_path', help = 'put your input path')
    parser.add_argument('-o_p', '--out_path', help = 'put your output path')
    parser.add_argument('-y', '--year', help = 'put your year path')
    parser.add_argument('-n_ch', '--check_name', help = 'put your checksums name')
    #parser = argparse.ArgumentParser(description = 'My script')
    #parser.add_argument('-inp_p', help = "put your imput path")
    args = parser.parse_args()
    
    #folder = "C:\\TEMP\\"+args.folder
    #order_files(inp_path)
    print(args.inp_path)
