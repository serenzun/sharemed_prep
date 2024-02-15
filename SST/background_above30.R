source(here::here("R","setup.R"))
source(here::here("R","directories_pcOffice_TAMARA.R"))
sst_folder<-file.path (dir_B,"prep_med/cmems/sst/raw")#da modificare
sst=list.files(sst_folder,pattern=".nc$", full.names=TRUE)


sst84_04_d<-  stack(file.path(sst_folder, 'dataset_subset84_04.nc'))
sst04_24_d<-  stack(file.path(sst_folder, 'dataset_subset04_24.nc'))
sst84_24_d <- stack(sst84_04_d,sst04_24_d)

years <- format(as.Date(names(sst84_24_d), format = "X%Y.%m.%d"), format = "%Y")
years <- as.numeric(years)#these are the months
months <- format(as.Date(names(sst84_24_d), format = "X%Y.%m.%d"), format = "%m")
months<- as.numeric(months)#these are the months
#names_int <- seq(as.Date("1984/1/1"), by = "month", length.out = 480)
#names(sst04_24_d_C)=names_int 

x <- format(as.Date(names(sst84_24_d), format = "X%Y.%m.%d"))
names(sst84_24_d) <- years

fun <- function(x,  na.rm = TRUE) {
  sum(x > 302.15, na.rm = na.rm)
}

annual_days_above_threshold_29C_84_24 <- stackApply(sst84_24_d, indices = years, 
                                                    fun = fun, 
                                                    progress = 'text')