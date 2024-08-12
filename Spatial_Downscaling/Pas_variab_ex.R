#!/usr/local/bin/R

library(optparse)


option_list = list(
  make_option(c("-s", "--source"), type="character", default="Brunswick", 
              help="folder name of the images source [default= %default]", metavar="character"),
  make_option(c("-y", "--year"), type="integer", default=NULL, 
              help="year to process", metavar="character")
  #make_option(c("-h", "--help"), type="character", default=NULL, 
              #help="include parameters", metavar="character")
) 

opt_parser = OptionParser(option_list=option_list)
opt = parse_args(opt_parser)

source_t <- opt$source
setwd('..')
setwd('./Outputs/Order_files/' + source_t)
year <- opt$year





print(source_t) ## Asi se llaman las variables!
print(year)