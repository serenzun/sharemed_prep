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
library(raster)
coordinates(cadeau_00_st)=~x+y
proj4string(cadeau_00_st)<- CRS("+proj=longlat +datum=WGS84")
prova<-spTransform(cadeau_00_st,CRS("+proj=longlat"))


queen_w <- queen_weights(prova)

cadeau_00_st_lat_long_sf <- st_as_sf(cadeau_00_st, coords = c("x", "y"), crs = my.projection)
st_crs(cadeau_00_st_lat_long_sf)
queen_weights(cadeau_00_st_lat_long_sf , order=1,  precision_threshold = 0)
queen_w <- queen_weights(cadeau_00_st_lat_long_sf)
summary(queen_w)
nbrs <- get_neighbors(queen_w, idx = 3)
nbrs
clusters_cadeau <- redcap(8, queen_w,cadeau_00_st, "fullorder-completelinkage")

#clusters_cadeau <- redcap(8, queen_w,cadeau_00_st, "fullorder-completelinkage")
clusters_cadeau
#saveRDS(clusters_cadeau, file="clusters_cadeau.RData")
saveRDS(clusters_cadeau, file="clusters_cadeau_8_full-compl.RData")

clusters_cadeau<- readRDS("clusters_cadeau_8_full-compl.RData")

### try to do like with the others
result_cadeau_spat <- cbind(clusters_cadeau$Cluster,cadeau_00_st_var)
# Interpreting result
result_cadeau_spat$group <- as.factor(clusters_cadeau$Cluster) 
result_cadeau_spat$'cluster_cadeau$Cluster'<-NULL
# https://ggplot2.tidyverse.org/reference/geom_boxplot.html
# https://towardsdatascience.com/understanding-boxplots-5e2df7bcbd51


#install.packages("DataExplorer")
library(DataExplorer)
plot_boxplot(result_cadeau_spat , by="group", geom_boxplot_args=list("outlier.color"="blue"))
#clusplot(result_cadeau_spat, cluster_cadeau$Cluster, main='2D representation of the Cluster solution',
#         color=TRUE, shade=TRUE,
#         labels=4, lines=0)
## Plot the lon-lat dist of our clustering
result_cadeau_spatb <- cbind(clusters_cadeau$Cluster,cadeau_00_st)
result_cadeau_spatb$group <- as.factor(clusters_cadeau$Cluster) 
write.csv(result_cadeau_spatb,"result_cadeau_spatb_8trial.csv")
mapview(result_cadeau_spatb, xcol = "x", ycol = "y", zcol="group",crs = 4269, grid = FALSE, cex=0.5)

result_cadeau_8trial_spatb_sf <- st_as_sf(result_cadeau_spatb, coords = c("x", "y"), crs = my.projection)
st_crs(result_cadeau_8trial_spatb_sf)
result_cadeau_8trial_spatb_sf <-st_rasterize(result_cadeau_8trial_spatb_sf  %>% dplyr::select(group, geometry))
stars::write_stars(result_cadeau_8trial_spatb_sf, file.path(dir_cluster, "result_cadeau_8trial_full-comp_spatb_sf.tif"))
#mapview(result_cadeau_spatb, xcol = "x", ycol = "y", zcol="group",crs = 4269, grid = FALSE)
??kruskalTest

#kruskal-wallis
#Kruskal-Wallis test by rank is a non-parametric alternative to one-way ANOVA test, which extends the two-samples Wilcoxon test in the situation where there are more than two groups. It’s recommended when the assumptions of one-way ANOVA test are not met. This tutorial describes how to compute Kruskal-Wallis test in R software.
kruskal.test(x ~ g, dat)

g <- result_cadeau_spatb$group
x <- result_cadeau_spatb[5:10]
library(PMCMRplus)
kruskalTest(x, g, dist = "Chisquare") 
kwAllPairsDunnTest(x,g,p.adjust.method = "bonferroni")

pairwise.wilcox.test(result_cadeau_spatb$sst, result_cadeau_spatb$group,
                     p.adjust.method = "BH")
# Box plots
# ++++++++++++++++++++
# Plot weight by group and color by group
library("ggpubr")
library(wesanderson)
col = wes_palette("Zissou1", 10, type = "continuous"))
ggboxplot(result_cadeau_spatb, x = "group", y = "o2", 
          color = "group", palette = c("#00AFBB", "#E7B800", "#FC4E07","#00AFBB", "#E7B800", "#FC4E07","#00AFBB", "#E7B800"),
        #  order = c("ctrl", "trt1", "trt2"),
          ylab = "Weight", xlab = "Treatment")
