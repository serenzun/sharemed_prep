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
summary(queen_w)
nbrs <- get_neighbors(queen_w, idx = 3)
nbrs
#clusters_cadeau_6 <- redcap(6, queen_w,cadeau_00_st, "fullorder-completelinkage")
#clusters_cadeau_8 <- redcap(8, queen_w,cadeau_00_st, "fullorder-completelinkage")
clusters_cadeau_12 <- redcap(12, queen_w,cadeau_00_st, "fullorder-completelinkage")

#saveRDS(clusters_cadeau_8, file=file.path(dir_cluster,"clusters_cadeau_8.RData"))
#saveRDS(clusters_cadeau_6, file=file.path(dir_cluster,"clusters_cadeau_6.RData"))
#saveRDS(clusters_cadeau, file="clusters_cadeau_8_full-compl.RData")
saveRDS(clusters_cadeau_12, file=file.path(dir_cluster,"clusters_cadeau_12.RData"))

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
write.csv(result_cadeau_spatb,file.path(dir_cluster, "result_cadeau_spatb_6trial.csv"))

result_cadeau_6trial_spatb_sf <- st_as_sf(result_cadeau_spatb, coords = c("x", "y"), crs = my.projection)
st_crs(result_cadeau_6trial_spatb_sf)
result_cadeau_6trial_spatb_sf <-st_rasterize(result_cadeau_6trial_spatb_sf  %>% dplyr::select(group, geometry))
stars::write_stars(result_cadeau_6trial_spatb_sf, file.path(dir_cluster, "result_cadeau_6trial_full-comp_spatb_sf.tif"))
#mapview(result_cadeau_spatb, xcol = "x", ycol = "y", zcol="group",crs = 4269, grid = FALSE)




result_cadeau_spatb <- read.csv("result_cadeau_spatb_6trial.csv")

#kruskal-wallis
#Kruskal-Wallis test by rank is a non-parametric alternative to one-way ANOVA test, which extends the two-samples Wilcoxon test in the situation where there are more than two groups. It’s recommended when the assumptions of one-way ANOVA test are not met. This tutorial describes how to compute Kruskal-Wallis test in R software.
kruskal.test(x ~ g, dat)

g <- result_cadeau_spatb$group
x <- result_cadeau_spatb[6:11]
library(PMCMRplus)
kruskal <- kruskalTest(x$o2, g, dist = "Chisquare") 

kruskal <- kruskalTest(x$o2, g, dist = "Chisquare") 
kruskal_chl <- kruskalTest(x$chl, g, dist = "Chisquare") 

dunno2<- kwAllPairsDunnTest(x$o2,g,p.adjust.method = "bonferroni")
dunndin<- kwAllPairsDunnTest(x$din,g,p.adjust.method = "bonferroni")


kruskal_lapply <- lapply(x, kruskal.test, g, p.adjust.methods="bonferroni")
 
dunn_lapply <- lapply(x,kwAllPairsDunnTest, g,p.adjust.method = "bonferroni") 


###con 8
result_cadeau_spat <- cbind(clusters_cadeau_8$Cluster,cadeau_00_st_var)
# Interpreting result
result_cadeau_spat$group <- as.factor(clusters_cadeau_8$Cluster) 
result_cadeau_spat$'cluster_cadeau_8$Cluster'<-NULL
result_cadeau_spatb <- cbind(clusters_cadeau_8$Cluster,cadeau_00_st)
result_cadeau_spatb$group <- as.factor(clusters_cadeau_8$Cluster) 
write.csv(result_cadeau_spatb,file.path(dir_cluster, "result_cadeau_spatb_8trial.csv"))

result_cadeau_8trial_spatb_sf <- st_as_sf(result_cadeau_spatb, coords = c("x", "y"), crs = my.projection)
st_crs(result_cadeau_8trial_spatb_sf)
result_cadeau_8trial_spatb_sf <-st_rasterize(result_cadeau_8trial_spatb_sf  %>% dplyr::select(group, geometry))
stars::write_stars(result_cadeau_8trial_spatb_sf, file.path(dir_cluster, "result_cadeau_8trial_full-comp_spatb_sf.tif"))


kruskal.test(x ~ g, dat)

g <- result_cadeau_spatb$group
x <- result_cadeau_spatb[5:10]
library(PMCMRplus)
#kruskal <- kruskalTest(x$o2, g, dist = "Chisquare") 
#
#kruskal <- kruskalTest(x$o2, g, dist = "Chisquare") 
#kruskal_chl <- kruskalTest(x$chl, g, dist = "Chisquare") 
#
#dunno2<- kwAllPairsDunnTest(x,g,p.adjust.method = "bonferroni")
#dunndin<- kwAllPairsDunnTest(x$din,g,p.adjust.method = "bonferroni")
#

kruskal_lapply <- lapply(x, kruskal.test, g, p.adjust.methods="bonferroni")

dunn_lapply <- lapply(x,kwAllPairsDunnTest, g,p.adjust.method = "bonferroni") 
summary(dunn_lapply)

# Box plots
# ++++++++++++++++++++
# Plot weight by group and color by group
library("ggpubr")
library(wesanderson)
col = wes_palette("Zissou1", 10, type = "continuous"))
#ripetuto per ciascuna colonna
ggboxplot(result_cadeau_spatb, x = "group", y = "sst", 
          color = "group", palette = c("#00AFBB", "#E7B800", "#FC4E07","#851194", "#bb6a00", "#948511","#00AFBB", "#E7B800", "#FC4E07"),
          #  order = c("ctrl", "trt1", "trt2"),
          ylab = "SST", xlab = "Cluster")

summary(result_cadeau_spatb)

#giro la tabella
library(tidyr)
result_cadeau_spatb_2<-result_cadeau_spatb %>% dplyr::select(-c(1:4,10))# %>% gather(Variable,value="o2","chl") %>% 
head(result_cadeau_spatb_2)

summary(result_cadeau_spatb )

result_cadeau_spatb_spread <- result_cadeau_spatb_2 %>% group_by(group) %>% 
 tidyr::gather(key="Variable",value="measurment",o2,chl, tp, din,ss,sst) 
head(result_cadeau_spatb_spread)

ggboxplot(result_cadeau_spatb_spread, x = "Variable", y = "measurment",fill="group")+
  facet_wrap(~group,scales="free")

ggboxplot(result_cadeau_spatb_spread, x = "group", y = "measurment",fill="group")+
  facet_wrap(~Variable, scales="free")
median <- result_cadeau_spatb_spread %>% group_by(group, Variable)%>%  summarise(median=median(measurment)) 
b <- result_cadeau_spatb_spread %>% group_by(group) %>% count(Variable)
summary_8trial <- left_join(median, b)
write.csv(summary_8trial,file.path(dir_cluster,"summary_8trial.csv"))

result_cadeau_spatb_8trial <- read.csv(file.path(dir_cluster, "result_cadeau_spatb_8trial.csv"))
result_cadeau_spatb_8trial_spread <- result_cadeau_spatb_8trial%>% dplyr::select(-(1:4)) %>% group_by(group) %>% 
  tidyr::gather(key="Variable",value="measurment",o2,chl, tp, din,ss,sst) 
head(result_cadeau_spatb_8trial_spread)
#analisi con tutti i dati 77392. elimino outliers
ggboxplot(result_cadeau_spatb_8trial_spread, x = "group", y = "measurment",fill="group",outlier.shape = NA)+ 
  facet_wrap(~Variable, scales="free")


g <- result_cadeau_spatb_8trial$group
x <- result_cadeau_spatb_8trial[6:11]

kruskal_lapply <- lapply(x, kruskal.test, g, p.adjust.methods="bonferroni")
kruskal_lapply 
dunn_lapply <- lapply(x,kwAllPairsDunnTest, g,p.adjust.method = "bonferroni") 

summary.PMCMR(dunn_lapply)
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


