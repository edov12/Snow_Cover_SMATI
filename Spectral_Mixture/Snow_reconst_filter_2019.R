## MESMA Spectral unmixing and filters

#load packages
library(raster)
library(RStoolbox)
library(openxlsx)
library(tictoc)

library(optparse)

option_list = list(
  make_option(c("-n", "--name"), type="character", default="Brunswick", 
              help="folder name of the downscaled images [default= %default]", metavar="character"),
  make_option(c("-y", "--year"), type="integer", default=NULL, 
              help="year to process", metavar="character")
  #make_option(c("-h", "--help"), type="character", default=NULL, 
  #help="include parameters", metavar="character")
) 

opt_parser = OptionParser(option_list=option_list)
opt = parse_args(opt_parser)

source_t <- opt$name

source_t <- 'Brunswick'
year <- 2015

setwd('..')
getwd()
link <- paste0('./Outputs/Order_files/', source_t)

link <- '/Users/fcoj_aguirre/Documents/Articulos en trabajo/Snow_Magallanes/Scripts/Snow_Cover_SMATI/Outputs/Order_files/Brunswick'

setwd(link)

year <- opt$year

Out_link <- paste0(link,'/Brunswick_mesma_albedo/',year)
Out_dir = dir.create(Out_link)

down_file <- readLines(paste0('./Downscaling_files/', year,'/',year,'_downcaling.txt'))

# down file
day <- length(down_file)
day_mesma <- vector(mode = "list", length = day)

# Read spectral signatures (0-100)
#setwd('..')
#setwd('..')
#setwd('..')


data_sp <- read.xlsx(paste0('./Snow_unmixing_v1/Snows_rock.xlsx'))
row.names(data_sp) <- data_sp$Land_cover
fr_1 <- data_sp[1:8,2:8]

#setwd(link)

############

## Armar el FOR

for(d in 1:length(down_file)){
  tic()
  print(d)
  day_b_d <- substr(down_file[d], 1, 8)
  day_mesma[d] <- paste0(day_b_d,'_mesma_albedo.tif')
  
  high_atk_GLS <- brick(paste0('./Downscaling_files/',year,'/',down_file[d]))
  #plot(high_atk_GLS)
  names(high_atk_GLS) <- c('band_1','band_2','band_3', 'band_4', 'band_5', 'band_6', 'band_7','elevation',
                           'slope','aspect','zenith','cloud_mask')
  
  high_atk_GLS_f <- stack(high_atk_GLS$band_1, high_atk_GLS$band_2, high_atk_GLS$band_3,
                          high_atk_GLS$band_4, high_atk_GLS$band_5, high_atk_GLS$band_6,
                          high_atk_GLS$band_7)
  
  names(high_atk_GLS_f) <- c('B1_dn', 'B2_dn', 'B3_dn', 'B4_dn', 'B5_dn', 'B6_dn', 'B7_dn')
  
  ## Revisión de bandas NaN
  
  b1_250_m <- cellStats(high_atk_GLS_f$B1_dn, 'mean')
  b2_250_m <- cellStats(high_atk_GLS_f$B2_dn, 'mean')
  b3_250_m <- cellStats(high_atk_GLS_f$B3_dn, 'mean')
  b4_250_m <- cellStats(high_atk_GLS_f$B4_dn, 'mean')
  b5_250_m <- cellStats(high_atk_GLS_f$B5_dn, 'mean')
  b6_250_m <- cellStats(high_atk_GLS_f$B6_dn, 'mean')
  b7_250_m <- cellStats(high_atk_GLS_f$B7_dn, 'mean')
  
  nan_band <- high_atk_GLS_f$B1_dn * NaN
  
  if(is.nan(b1_250_m)|is.nan(b2_250_m)|is.nan(b3_250_m)|is.nan(b4_250_m)|is.nan(b5_250_m)|
     is.nan(b6_250_m)|is.nan(b7_250_m)){
    #print('bandas_nulas')
    
    Snow_umb_r <- stack(nan_band$B1_dn, nan_band$B1_dn, nan_band$B1_dn, nan_band$B1_dn,
                        nan_band$B1_dn, nan_band$B1_dn)
    
    ## Imprimir los raster
    writeRaster(Snow_umb_r, paste0(Out_link,'/',day_b_d,'_mesma_albedo.tif'), 
                format="GTiff", overwrite=TRUE)
    toc()
  }else{
    
    # Función Reescalar raster
    rescale_f <- function(x, x.min = NULL, x.max = NULL, new.min = 0, new.max = 1) {
      if(is.null(x.min)) x.min = min(x)
      if(is.null(x.max)) x.max = max(x)
      new.min + (x - x.min) * ((new.max - new.min) / (x.max - x.min))
    }
    
    # Aplica reescalar
    high_atk_GLS_f_r <- rescale_f(high_atk_GLS_f, x.min = 100, x.max = 16200, new.min = 0, new.max = 100)
    values(high_atk_GLS_f_r) <- round(values(high_atk_GLS_f_r),4) # redondeo a 4 decimales
    
    # Aplica NDSI 
    
    ndsi<- (high_atk_GLS_f_r$B4_dn - high_atk_GLS_f_r$B6_dn) / (high_atk_GLS_f_r$B4_dn + high_atk_GLS_f_r$B6_dn)
    madi <- high_atk_GLS_f_r$B1_dn / high_atk_GLS_f_r$B7_dn
    
    # Aplica modelo MESMA
    probs <- mesma(high_atk_GLS_f_r, fr_1, method = "NNLS")  # aplicación de MESMA!
    
    #Snow_fractional agruped
    
    Snow_f <- probs$Snow_10 + probs$Snow_100 + probs$Snow_250 + probs$Snow_1000
    #plot(Snow_f)
    
    Snow_f_gz <- (probs$Snow_10 * 10) + (probs$Snow_100 * 100) + (probs$Snow_250 * 250) + (probs$Snow_1000 * 1000)
    #plot(Snow_f_gz)
    
    ## Zenith
    zenith_r <- high_atk_GLS$zenith
    zenith_r_v <- clamp(high_atk_GLS$zenith, lower=0, upper=18000, useValues=FALSE)
    zenith_r_v[is.na(zenith_r_v$zenith)] <- NaN  # se cambio Na
    
    zenith_r_m <- zenith_r_v
    values(zenith_r_m)[values(zenith_r_m) >= 0] = 1
    zenith_r_f <- zenith_r_v * zenith_r_m
    
    illum_ang <- (zenith_r_f * 0.01) - high_atk_GLS$slope
    
    Snow_st <- stack(Snow_f, Snow_f_gz, ndsi, madi, high_atk_GLS$cloud_mask, illum_ang)
    names(Snow_st) <- c('Snow_f', 'Snow_gz','NDSI','MADI', 'cloud_mask', 'illum_ang')
    
    ## New snow and cloud descrimination
    Snow_st.p <- as(Snow_st, 'SpatialPointsDataFrame')#
    Snow_st.p.frame <- as.data.frame(Snow_st.p)#
    #colnames(cloud_mask.p.frame) <- c('value','x' ,'y')#
    
    Snow_st.p.frame$Snow_f_r <- Snow_st.p.frame$Snow_f
    Snow_st.p.frame$cloud_mask_r <- Snow_st.p.frame$cloud_mask
    Snow_st.p.frame$Snow_albedo <- Snow_st.p.frame$Snow_f
    
    #Snow_st.p.frame$cloud_mask_r[Snow_st.p.frame$cloud_mask_r == 0] <- NaN
    
    ## Prueba y selección de umbrales
    #cl <- 0
    #sn <- 0
    #nrow(Snow_st.p.frame)
    for(i in 1:nrow(Snow_st.p.frame)){
      if(is.na(Snow_st.p.frame[i,1])){
        Snow_st.p.frame[i,9] <- NaN
      } else{
        if(Snow_st.p.frame[i,1] >= 0.2 & Snow_st.p.frame[i,3] >= 0.4 & Snow_st.p.frame[i,4] >= 6){
          Snow_st.p.frame[i,9] <- 1
        } else{
          if(Snow_st.p.frame[i,1] > 0){
            Snow_st.p.frame[i,9] <- NaN
          } else if (Snow_st.p.frame[i,1] == 0){
            Snow_st.p.frame[i,9] <- 0
          }
        }
      }
    }
    
    ## Calculo de albedo
    vis <- 3/7 # fraction of visible bands
    ni <- 4/7 # fraction of NearInfrared bands
    
    #Vis_A_30 <- 0.004
    #Vis_B_30 <- 0.473
    #pend_Vis_A <- -3.6667*10^(-5)
    #pend_Vis_B <- 2.0333*10^(-4)
    
    #Ni_A_30 <- 0.2025
    #Ni_B_30 <- 0.1791
    #pend_Ni_A <- -1.12*10^(-3)
    #pend_Ni_B <- 3.83*10^(-4)
    
    # Values to broadband albedo Solar 
    Sw_A_30 <- 0.0765
    Sw_B_30 <- 0.2205
    pend_Sw_A <- -3.9*10^(-4)
    pend_Sw_B <- 1.77*10^(-4)
    
    for(a in 1:nrow(Snow_st.p.frame)){
      if(is.nan(Snow_st.p.frame[a,9])){
        Snow_st.p.frame[a,11] <- NaN
      }else{
        if(Snow_st.p.frame[a,9] == 1){
          Sw_A_ang <- pend_Sw_A*(Snow_st.p.frame[a,6]-30) + Sw_A_30
          Sw_B_ang <- pend_Sw_B*(Snow_st.p.frame[a,6]-30) + Sw_B_30
          
          Snow_st.p.frame[a,11] <- 1 - (Sw_A_ang * (Snow_st.p.frame[a,2]^Sw_B_ang))
        }
        else{
          Snow_st.p.frame[a,11] <- NaN
        }
      }
    }
    
    # Arma el raster
    coordinates(Snow_st.p.frame) <- ~x+y
    proj4string(Snow_st.p.frame) <- CRS("+init=epsg:32719") # UTM huso 19S WGS84
    
    Snow_f_r <- rasterFromXYZ(Snow_st.p.frame[,1])
    Snow_gz_r <- rasterFromXYZ(Snow_st.p.frame[,2])
    NDSI_r <- rasterFromXYZ(Snow_st.p.frame[,3])
    MADI_r <- rasterFromXYZ(Snow_st.p.frame[,4])
    Snow_M <- rasterFromXYZ(Snow_st.p.frame[,7])
    Snow_albedo <- rasterFromXYZ(Snow_st.p.frame[,9])
    
    Snow_umb_r <- stack(Snow_f_r, Snow_gz_r, NDSI_r, MADI_r, Snow_M, Snow_albedo)
    crs(Snow_umb_r) <- "+init=epsg:32719"
    
    
    ## Imprimir los raster
    writeRaster(Snow_umb_r, paste0(Out_link,'/',day_b_d,'_mesma_albedo.tif'), 
                format="GTiff", overwrite=TRUE)
    toc()
    
  }
  
}

fileConn<-file(paste0(Out_link,'/',year,'_mesma_alb.txt'))
writeLines(as.character(day_mesma), fileConn)
close(fileConn)