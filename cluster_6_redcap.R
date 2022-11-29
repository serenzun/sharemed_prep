library(rgeoda)
library(sf)
library(stars)

library(caret)
library(doParallel)
library(arules)

dir_cluster <- file.path("G:/Il mio Drive/ASSEGNO DI RICERCA/SHAREMED_mio/cluster_analysis")
cluster <- makeCluster(detectCores()-1)
registerDoParallel(cluster)

cadeau_00_st_var <- read.csv(file.path("G:/Il mio Drive/ASSEGNO DI RICERCA/SHAREMED_mio/wp4_atlas/TRIX/cadeau_00_st_var.csv")) 
cadeau_00_st <- read.csv(file.path("G:/Il mio Drive/ASSEGNO DI RICERCA/SHAREMED_mio/wp4_atlas/TRIX/cadeau_00_st.csv")) 

cadeau_00_st_var <- read.csv(file.path("~/github/sharemed_prep/trix_cadeau/cadeau_00_st_var.csv"))

#https://geodacenter.github.io/rgeoda/articles/rgeoda_tutorial.html
prj4string <- "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"
my.projection <- st_crs(prj4string)



cadeau_00_st_lat_long_sf <- st_as_sf(cadeau_00_st, coords = c("x", "y"), crs = my.projection)
st_crs(cadeau_00_st_lat_long_sf)
queen_weights(cadeau_00_st_lat_long_sf , order=1,  precision_threshold = 0)
queen_w <- queen_weights(cadeau_00_st_lat_long_sf)
summary(queen_w)
nbrs <- get_neighbors(queen_w, idx = 3)
nbrs
clusters_cadeau_6 <- redcap(6, queen_w,cadeau_00_st, "fullorder-completelinkage")

#clusters_cadeau <- redcap(8, queen_w,cadeau_00_st, "fullorder-completelinkage")

saveRDS(clusters_cadeau_6, file=file.path(dir_cluster,"clusters_cadeau_6.RData"))
#saveRDS(clusters_cadeau, file="clusters_cadeau_8_full-compl.RData")

#clusters_cadeau<- readRDS("clusters_cadeau_8_full-compl.RData")

### try to do like with the others
result_cadeau_spat <- cbind(clusters_cadeau_6$Cluster,cadeau_00_st_var)
# Interpreting result
result_cadeau_spat$group <- as.factor(clusters_cadeau_6$Cluster) 
result_cadeau_spat$'cluster_cadeau_6$Cluster'<-NULL
# https://ggplot2.tidyverse.org/reference/geom_boxplot.html
# https://towardsdatascience.com/understanding-boxplots-5e2df7bcbd51


library(DataExplorer)
plot_boxplot(result_cadeau_spat , by="group", geom_boxplot_args=list("outlier.color"="blue"))
#clusplot(result_cadeau_spat, cluster_cadeau$Cluster, main='2D representation of the Cluster solution',
#         color=TRUE, shade=TRUE,
#         labels=4, lines=0)
## Plot the lon-lat dist of our clustering
result_cadeau_spatb <- cbind(clusters_cadeau$Cluster,cadeau_00_st)
result_cadeau_spatb$group <- as.factor(clusters_cadeau$Cluster) 
write.csv(result_cadeau_spatb,"result_cadeau_spatb_6trial.csv")

result_cadeau_6trial_spatb_sf <- st_as_sf(result_cadeau_spatb, coords = c("x", "y"), crs = my.projection)
st_crs(result_cadeau_6trial_spatb_sf)
result_cadeau_6trial_spatb_sf <-st_rasterize(result_cadeau_6trial_spatb_sf  %>% dplyr::select(group, geometry))
stars::write_stars(result_cadeau_6trial_spatb_sf, file.path(dir_cluster, "result_cadeau_6trial_full-comp_spatb_sf.tif"))
#mapview(result_cadeau_spatb, xcol = "x", ycol = "y", zcol="group",crs = 4269, grid = FALSE)
