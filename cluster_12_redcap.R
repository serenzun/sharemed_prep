library(rgeoda)
library(sf)
library(stars)

library(caret)
library(doParallel)
library(arules)

dir_cluster <- file.path("G:/Il mio Drive/ASSEGNO DI RICERCA/SHAREMED_mio/cluster_analysis")
cluster <- makeCluster(detectCores()-1)
registerDoParallel(cluster)

#cadeau_00_st_var <- read.csv(file.path("G:/Il mio Drive/ASSEGNO DI RICERCA/SHAREMED_mio/wp4_atlas/TRIX/cadeau_00_st_var.csv")) 
cadeau_00_st <- read.csv(file.path("G:/Il mio Drive/ASSEGNO DI RICERCA/SHAREMED_mio/wp4_atlas/TRIX/cadeau_00_st.csv"))
cadeau_00_st <- cadeau_00_st %>%   dplyr::filter(sst >10 &ss>10)
myvars <- c("o2","chl", "din", "tp","ss","sst")
cadeau_00_st_var <-cadeau_00_st[myvars]
cadeau_00_st_var<-as.data.frame(scale(cadeau_00_st_var))

#https://geodacenter.github.io/rgeoda/articles/rgeoda_tutorial.html
prj4string <- "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"
my.projection <- st_crs(prj4string)



cadeau_00_st_lat_long_sf <- st_as_sf(cadeau_00_st, coords = c("x", "y"), crs = my.projection)
st_crs(cadeau_00_st_lat_long_sf)
queen_weights(cadeau_00_st_lat_long_sf , order=1,  precision_threshold = 0)
queen_w <- queen_weights(cadeau_00_st_lat_long_sf)
clusters_cadeau_12 <- redcap(12, queen_w,cadeau_00_st, "fullorder-completelinkage")
saveRDS(clusters_cadeau_12, file=file.path(dir_cluster,"clusters_cadeau_12.RData"))

###12

result_cadeau_spat <- cbind(clusters_cadeau_12$Cluster,cadeau_00_st_var)
# Interpreting result
result_cadeau_spat$group <- as.factor(clusters_cadeau_12$Cluster) 
result_cadeau_spat$'cluster_cadeau_12$Cluster'<-NULL
result_cadeau_spatb <- cbind(clusters_cadeau_12$Cluster,cadeau_00_st)
result_cadeau_spatb$group <- as.factor(clusters_cadeau_12$Cluster) 
write.csv(result_cadeau_spatb,file.path(dir_cluster, "result_cadeau_spatb_12trial.csv"))

result_cadeau_12trial_spatb_sf <- st_as_sf(result_cadeau_spatb, coords = c("x", "y"), crs = my.projection)
st_crs(result_cadeau_12trial_spatb_sf)
result_cadeau_12trial_spatb_sf <-st_rasterize(result_cadeau_12trial_spatb_sf  %>% dplyr::select(group, geometry))
stars::write_stars(result_cadeau_12trial_spatb_sf, file.path(dir_cluster, "result_cadeau_12trial_full-comp_spatb_sf.tif"))