#!/usr/local/bin/R

library(optparse)

option_list = list(
  make_option(c("-s", "--source"), type="character", default=".", 
              help="folder name of the images source [default= %default]", metavar="character"),
  make_option(c("-y", "--year"), type="integer", default=NULL, 
              help="year to process", metavar="character"),
  make_option(c("-o", "--out"), type="character", default=".", 
              help="output folder name [default= %default]", metavar="character")
  #make_option(c("-h", "--help"), type="character", default=NULL, 
              #help="include parameters", metavar="character")
) 

opt_parser = OptionParser(option_list=option_list)
opt = parse_args(opt_parser)

link_1 <- opt$source
Out_link <- opt$out
year <- opt$year

if (link_1 == '.') {
  link_1 <- getwd() 
}

setwd(link_1)


if (Out_link == '.'){
  link_2 <- getwd()
  setwd('..')
  link_3 <- getwd()
  setwd('./Utilities/4_Example_Data/Order_files/Brunswick')
  link_4 <- getwd()
  link <- link_4
} else {
  link <- Out_link
}


print(link) ## Asi se llaman las variables!