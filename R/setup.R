#Common workflow

##install.packages(c("devtools", "roxygen2", "testthat", "knitr"))

##install.packages("sf")
#install.packages("rlang")
#install.packages("rlang", dependencies = c("Depends", "Imports", "LinkingTo", "Suggests"))
#install.packages("devtools")   
library(devtools)
#devtools::install_github('ohi-science/ohicore')
#library(ohicore)
##install.packages("rgeos")
library(tibble)
library(rgeos)
##install.packages('DBI')
library(colorRamps)
#install.packages("gdalUtils")
library(gdalUtils)
##Libraries:
library(tidyverse)
library(purrr)
library(here) # install.packages("here")
library(readxl)

## spatial libraries


library(sp)
library(rgdal)

library(raster)

library(ncdf4)
library(parallel)
library(foreach)
library(doParallel)
#library(rasterVis)
#library(seaaroundus)
library(RColorBrewer)
library(cowplot)
library(stringr)
library(colorspace)

#for the directories run the appropriate directories file

## color palette
cols = rev(colorRampPalette(brewer.pal(11, 'Spectral'))(255)) # rainbow color scheme
#mytheme=rasterTheme(region=cols)

cols2 = rev(colorRampPalette(brewer.pal(11, 'Spectral'))(255)) # rainbow color scheme


#to check how many cores I'm using '
#library(parallel) # for using parallel::mclapply() and checking #totalCores on compute nodes / workstation: detectCores()
#library(future) # for checking #availble cores / workers on compute nodes / workstation: availableWorkers() / availableCores() 

#workers <- availableWorkers()
#cat(sprintf("#workders/#availableCores/#totalCores: %d/%d/%d, workers:\n", length(workers), availableCores(), detectCores()))

library(sf)
library(ggplot2)
library(ggplot2)
library(plotly)
#install.packages("gapminder")
library(gapminder)


#ocean<-raster(file.path(dir_B,"prep/spatial/spatial_ohi_supplement/ocean.tif"))
#atl_mask_highres<-raster(file.path(dir_B,("prep/spatial/output/atl_highres_mask.tif")))
#grid_atl_toextract_newgrid<-raster(file.path(dir_B,'prep/spatial/output/grid_atl_toextract_newgrid.tif'))
#mollCRS=crs('+proj=moll +lon_0=0 +x_0=0 +y_0=0 +ellps=WGS84 +units=m +no_defs')
#
#atl_id_rgnsame <- read.csv(file.path(atl, "prep/spatial/output/atl_id_rgnname.csv"))
#