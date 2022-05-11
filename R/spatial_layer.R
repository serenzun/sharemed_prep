
#Download of Adriatic boundaries from:

https://www.marineregions.org/download_file.php?name=World_Seas_IHO_v3.zip

world <- st_read ("G:/Il mio Drive/ASSEGNO DI RICERCA/SHAREMED_mio/World_Seas_IHO_v3/World_Seas_IHO_v3.shp")
adr_sh <- st_read("G:/Il mio Drive/ASSEGNO DI RICERCA/SHAREMED_mio/mediterranean_sea.shp") %>% 
  filter(NAME=="Adriatic Sea")

plot(adr_sh)
library("ggspatial")
library("rnaturalearth")
library("rnaturalearthdata")


library("rnaturalearth")
library("rnaturalearthdata")

world <- ne_countries(scale = "medium", returnclass = "sf")
library("ggspatial")
adriatic_plot <- ggplot(data = world) +
  geom_sf() +
  annotation_scale(location = "bl", width_hint = 0.5) +
  annotation_north_arrow(location = "bl", which_north = "true", 
                         pad_x = unit(0.75, "in"), pad_y = unit(0.5, "in"),
                         style = north_arrow_fancy_orienteering) +
  coord_sf(xlim = c(11,16), ylim = c(43,46))

#ggsave("adriatic_plot.tiff")
#ggplot(data = world) +
#  geom_sf() +
#  annotation_scale(location = "bl", width_hint = 0.5) +
#  annotation_north_arrow(location = "bl", which_north = "true", 
#                         pad_x = unit(0.75, "in"), pad_y = unit(0.5, "in"),
#                         style = north_arrow_fancy_orienteering) +
#  coord_sf(xlim = c(-102.15, -74.12), ylim = c(7.65, 33.97))#



mne_19_golfotrieste <- mne_19_golfotrieste %>% 
  mutate(day = as.Date(day, "%d/%m/%Y")) %>%
  arrange(day)