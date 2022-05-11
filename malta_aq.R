malta <- read.csv("G:/Il mio Drive/ASSEGNO DI RICERCA/SHAREMED_mio/wp4_atlas/acquacultura/malta.csv", sep=";")

#Decimal Degrees = degrees + (minutes/60) + (seconds/3600)

#DD = d + (min/60) + (sec/3600)

#here we have both degrees decimal minutes (DDM) and Degrees decima minutes second

#Decimal degrees = Degrees + (Minutes/60) + (Seconds/3600)

malta_conv <-   malta %>% 
  mutate(Lat=Latitude)
library(dplyr)
matla_lat <- malta %>% 
  select(Latitude)
matla_lat <- matla_lat[1:33,]
chd = substr(matla_lat, 3, 3)[1]
#chm = substr(matla_lat, 6, 6)[1]
chM = substr(matla_lat, 9, 9)[1]
library(sp)
cd = char2dmm(matla_lat,chd=chd,chm=chM)
as.numeric(cd)
??char2dms

malta_dms <- malta[34:49,]
chd = substr(malta_dms$Latitude, 3, 3)[1]
chm = substr(malta_dms$Latitude, 6, 6)[1]
chs = '"'
cd = char2dms(malta_dms$Latitude,chd=chd,chm=chm,chs=chs)
as.numeric(cd)
