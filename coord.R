install.packages("measurements")

library("measurements")
x = read.table(text = "
   lat     long
105252 30°25.264 9°01.331
105253 30°39.237 8°10.811
105255 31°37.760 8°06.040
105258 31°41.190 8°06.557
105259 31°41.229 8°06.622
105260 31°38.891 8°06.281",
               header = TRUE, stringsAsFactors = FALSE)

# change the degree symbol to a space



x$lat = gsub('°', ' ', x$lat)
x$long = gsub('°', ' ', x$long)
x
# convert from decimal minutes to decimal degrees
x$lat = measurements::conv_unit(x$lat, from = 'deg_dec_min', to = 'dec_deg')
x$long = measurements::conv_unit(x$long, from = 'deg_dec_min', to = 'dec_deg')

x

#------------
 lat <- c( "36°00'52.31"	,"36°00'32.36","36°00'19.55","36°00'39.49",	"36°00'40.43",
           "36°00'33.01",	"36°00'31.43",	"36°00'38.84")

long <- c("14° 25'23.09"	,"14° 25'54.62",	"14°25'42.38"	,
         "14°25'10.85",	"14°25'27.62"	,"14°25'39.36",	"14°25'37.88",	"14°25'26.11")

chd = substr( lat , 3, 3)[1]
chm = substr(lat, 6, 6)[1]
 chs = substr(coords, 9, 9)[1]

x <- data.frame(long, lat)
x$lat = gsub('°', ' ', x$lat)
x$lat = gsub("'", ' ', x$lat)
x$long = gsub('°', ' ', x$long)
x$long = gsub("'", ' ', x$long)
x
# convert from decimal minutes to decimal degrees
x$lat = measurements::conv_unit(x$lat, from = 'deg_min_sec', to = 'dec_deg')
x$long = measurements::conv_unit(x$long, from = 'deg_dec_min', to = 'dec_deg')

x


x <- read.table(text="DdM     DMS_lat      DMS_lon        DMS
                45°12.123'  45°12'7.38''S  45°12'7.38''W  45°12'7.38
                31°29.17'   31°29'10.2''N  31°29'10.2''E  31°29'10.2 ",
                header=TRUE, stringsAsFactors=FALSE)
dg2dec(varb=x$DdM, Dg="°", Min="'")
