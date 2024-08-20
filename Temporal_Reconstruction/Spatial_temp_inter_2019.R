## Spatial - temporal resolution

library(raster)
library(spacetime) # armar matrices spacio-temporales
library(tictoc)

#library(dplyr)
#library(xts)

#library(gstat)

#link <- '/Users/fcoj_aguirre/Documents/Articulos en trabajo/Snow_Magallanes/Scripts/Snow_Cover_SMATI/Outputs/Order_files/Brunswick'
#setwd(link)

#year_st <- 2015


library(optparse)

## Terminal variables
option_list = list(
  make_option(c("-n", "--name"), type="character", default="Brunswick", 
              help="folder name of the downscaled images [default= %default]", metavar="character"),
  make_option(c("-y", "--year"), type="integer", default=NULL, 
              help="year to process", metavar="character")
) 

opt_parser = OptionParser(option_list=option_list)
opt = parse_args(opt_parser)

source_st <- opt$name
year_st <- opt$year


setwd('..')

link <- paste0('./Outputs/Order_files/', source_st)
setwd(link)
getwd()

Out_link_1 <- './Snow_Interpolation/'
Out_dir_1 = dir.create(paste0(Out_link_1,year_st))

#Out_link_2 <- paste0(Out_link_1, year_st)
#Out_dir_2 = dir.create(Out_link_2)

#Out_link_3 <- paste0(Out_link_1, year_st)
#Out_dir_3 = dir.create(Out_link_3)

## Referent raster, to have the correct dimensions!! 
#####
link_r <- paste0('./Mesma_albedo/',year_st)
mesma_alb_268 <- brick(paste0(link_r,'/','2015_268_mesma_albedo.tif'))
names(mesma_alb_268) <- c('fraction', 'g_size', 'ndsi', 'madi','s_mask','albedo')
#####


mesma_file <- readLines(paste0('Mesma_albedo/',year_st,'/',year_st,'_mesma_alb.txt'))

days <- length(mesma_file)

day_w <- 15 ## ventana para la interpolación

day_i <- days -day_w
#day_st <- vector(mode = "list", length = (day_i+1))
day_st <- list()

rast_1 <- list()
rast_2 <- list()

d <- 0
for( s in 1:(day_i+1)){
  tic()
  
  day_l <- list()
  date_l <- list()
  mesma <- list()
  sn_f_na <- list()
  sn_al_na <- list()
  
  for(i in 1:15){
    day_l[[i]] <- substr(mesma_file[i+d], 6, 8)
    date_l[[i]] <- as.Date(as.numeric(day_l[[i]]), origin = as.Date(paste0((year_st-1),'-12-31')))
    #Read the rasters
    mesma_i <- brick(paste0('Mesma_albedo/',year_st,'/',mesma_file[i+d]))
    names(mesma_i) <- c('fraction', 'g_size', 'ndsi', 'madi','s_mask','albedo')
    
    # revisa mismas dimenciones en los rasters
    if(ncol(mesma_i)==ncol(mesma_alb_268) & nrow(mesma_i)==nrow(mesma_alb_268)){
      #print(i)
      mesma[[i]] <- mesma_i
    } else{
      #print('false')
      mesma_j <- resample(mesma_i, mesma_alb_268, method='bilinear')
      mesma[[i]] <- mesma_j
    }
    sn_f <- mesma[[i]]$fraction * mesma[[i]]$s_mask
    sn_f_na[[i]] <- reclassify(sn_f, cbind(NaN, -9999))
    
    sn_al_na[[i]] <- reclassify(mesma[[i]]$albedo, cbind(NaN, -9999))
  }
  day_st[[s]] <- date_l[[7]]
  
  ## Snow fraction
  
  Snow_f_s <- stack(sn_f_na[[1]], sn_f_na[[2]], sn_f_na[[3]], sn_f_na[[4]], sn_f_na[[5]], sn_f_na[[6]], sn_f_na[[7]], sn_f_na[[8]],
                    sn_f_na[[9]], sn_f_na[[10]], sn_f_na[[11]], sn_f_na[[12]], sn_f_na[[13]], sn_f_na[[14]], sn_f_na[[15]])
  
  Snow_alb_s <- stack(sn_al_na[[1]], sn_al_na[[2]], sn_al_na[[3]], sn_al_na[[4]], sn_al_na[[5]], sn_al_na[[6]], sn_al_na[[7]], sn_al_na[[8]],
                      sn_al_na[[9]], sn_al_na[[10]], sn_al_na[[11]], sn_al_na[[12]], sn_al_na[[13]], sn_al_na[[14]], sn_al_na[[15]])
  
  date_f <- c(date_l[[1]], date_l[[2]], date_l[[3]], date_l[[4]], date_l[[5]], date_l[[6]], date_l[[7]], date_l[[8]], date_l[[9]], date_l[[10]], date_l[[11]], date_l[[12]],
              date_l[[13]], date_l[[14]], date_l[[15]])
  
  
  Snow_st.p <- as(Snow_f_s, 'SpatialPointsDataFrame')
  Snow_st.p.frame <- as.data.frame(Snow_st.p)
  Snow_st.p.frame[Snow_st.p.frame == -9999] <- NA
  
  Snow_al.st.p <- as(Snow_alb_s, 'SpatialPointsDataFrame')
  Snow_al.st.p.frame <- as.data.frame(Snow_al.st.p)
  Snow_al.st.p.frame[Snow_al.st.p.frame == -9999] <- NA
  
  ## Genera spatial
  sp.frame <- Snow_st.p.frame[,16:17]
  coordinates(sp.frame ) <- ~x+y
  proj4string(sp.frame ) <- CRS('EPSG:32719')
  
  sn_f.frame <- Snow_st.p.frame[,1:15]
  sn_alb.frame <- Snow_al.st.p.frame[,1:15]
  
  ## Definir data
  #snow_data <- data.frame(sf = as.vector(as.matrix(sn_f.frame)), albedo =as.vector(as.matrix(sn_alb.frame)))
  sf_data <- data.frame(sf = as.vector(as.matrix(sn_f.frame)))
  al_data <- data.frame(aledo = as.vector(as.matrix(sn_alb.frame)))
  ## Crea objeto espacio temporal
  #Snow_f.st <- STFDF(sp.frame, date_f, data.frame(counts = as.vector
  #(as.matrix(t.frame))))
  ## Interpolación Snow Fraction
  Snow_f.st <- STFDF(sp.frame, date_f, sf_data)
  
  Snow_f.st_s <- na.spline(Snow_f.st, maxgap = 5)
  
  data_sf_7 <- t(unstack(Snow_f.st_s))
  data_sf_7[data_sf_7 > 1] <- 1
  data_sf_7[data_sf_7 < 0] <- 0
  
  frame_sf.r <- data.frame(Snow_st.p.frame[,16:17],data_sf_7[,1:15])
  coordinates(frame_sf.r) <- ~x+y
  proj4string(frame_sf.r) <- CRS('EPSG:32719')
  
  # Arma el raster
  Snow_f_r_7 <- rasterFromXYZ(frame_sf.r[,7])
  crs(Snow_f_r_7) <- 'EPSG:32719'
  rast_1[[s]] <- Snow_f_r_7
  
  ## Interpolación Snow Albedo
  Snow_alb.st <- STFDF(sp.frame, date_f, al_data)
  Snow_alb.st_s <- na.spline(Snow_alb.st, maxgap = 5)
  
  data_sa_7 <- t(unstack(Snow_alb.st_s))
  data_sa_7[data_sa_7 > 1] <- 1
  data_sa_7[data_sa_7 < 0] <- 0
  
  frame_sa.r <- data.frame(Snow_st.p.frame[,16:17],data_sa_7[,1:15])
  coordinates(frame_sa.r) <- ~x+y
  proj4string(frame_sa.r) <- CRS('EPSG:32719')
  
  # Arma el raster
  Snow_al_r_7 <- rasterFromXYZ(frame_sa.r[,7])
  crs(Snow_al_r_7) <- 'EPSG:32719'
  rast_2[[s]] <- Snow_al_r_7
  
  if(d == 0){
    Rast_SF <- rast_1[[s]]
    Rast_SA <- rast_2[[s]]
  } else{
    Rast_SF <- stack(Rast_SF, rast_1[[s]])
    Rast_SA <- stack(Rast_SA, rast_2[[s]])
  }
  print(day_st[[s]])
  toc()
  #Snow_f_s_f <- stack(Snow_f_r_1, Snow_f_r_2, Snow_f_r_3, Snow_f_r_4)
  #grabar dos archivos!, un raster u un txt con las fechas
  
  d <- d + 1
}



file_sf_r <-file(paste0(Out_link_1,year_st,'/',year_st,'_snow_fr_alb.txt'))
writeLines(as.character(structure(day_st,class= 'Date')), file_sf_r)
close(file_sf_r)

writeRaster(Rast_SF, paste0(Out_link_1,'/',year_st,'/',year_st,'_snow_fraction.tif'), 
            format="GTiff", overwrite=TRUE)

writeRaster(Rast_SA, paste0(Out_link_1,'/',year_st,'/',year_st,'_snow_albedo.tif'), 
            format="GTiff", overwrite=TRUE)


#timeIndex <- readLines(paste0(Out_link_1,year_st,'/',year_st,'_snow_fr_alb.txt'))
#S_f_dm <- setZ(Rast_SF, timeIndex)
#names(S_f_dm) <- format(as.Date(timeIndex), "%a_%Y%m%d")

#library(rasterVis)
#levelplot(S_f_dm, layers = 121:124, panel = panel.levelplot.raster)
