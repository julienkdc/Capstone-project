#install.packages("ncdf4")
#install.packages("lubridate")
setwd("C:\Users\jkuhn\Documents\organized\School\Northwestern_Masters\Capstone_Thesis\CO2_satellite\tobedeleted")

library(ncdf4)
library(dplyr)
ncpath <- "C:/Users/jkuhn/Documents/organized/School/Northwestern_Masters/Capstone_Thesis/CO2_satellite/Processed_afterJanuary/"
ncname <- "oco2_LtCO2_211130_B10206Ar_220212202113s.nc4"
ncfname <- paste(ncpath, ncname, sep="")
ncin <- nc_open(ncfname)

xco2 <- as.numeric(ncvar_get(ncin, "xco2"))
latitude <- as.numeric(ncvar_get(ncin, "latitude"))
longitude <- as.numeric(ncvar_get(ncin, "longitude"))
date <- paste('20', substr(gsub("[A-z \\.\\(\\)]", "", ncname), start = 3, stop = 8), sep="")
date <- rep(date, length(longitude))
nc_df <- data.frame(cbind(latitude, longitude, xco2, date))
names(nc_df) <- c("latitude", "longitude", "xco2","date")

nc_df2 <- nc_df[(nc_df$latitude < 30.5),]
nc_df2 <- nc_df2[(nc_df2$latitude > 25),]
nc_df2 <- nc_df2[(nc_df2$longitude < -97),]
nc_df2 <- nc_df2[(nc_df2$longitude > -87),]

nc_df2 <- subset(nc_df2, longitude < 0)
nc_df2$longitude = as.numeric(nc_df2$longitude)*-1


nc_df2 <- subset(nc_df2, longitude > -97)

nc_df2 <- subset(nc_df, latitude <= 30.5 & latitude >= 27)
nc_df2 <- subset(nc_df2, longitude >= -97 & longitude <= -87)
#nc_df <- filter(nc_df, longitude > -97)
#nc_df <- filter(nc_df, longitude < -87)
#nc_df

csv_fname <- "C:/Users/jkuhn/Documents/organized/School/Northwestern_Masters/Capstone_Thesis/CO2_satellite/tobedeleted/test.csv"
write.table(nc_df, csv_fname, row.names=FALSE, sep=";")

#ncpath <- "C:/Users/jkuhn/Documents/organized/School/Northwestern_Masters/Capstone_Thesis/CO2_satellite/Processed_afterJannuary/"
ncpath <- "C:/Users/jkuhn/Documents/organized/School/Northwestern_Masters/Capstone_Thesis/CO2_satellite/"
files <- list.files(path=ncpath, pattern=".nc4", all.files=T, full.names=T)

for (file in 561:length(files)) {
 # ncfname <- paste(ncpath, file, sep="")
  ncin <- nc_open(files[file])
  
  xco2 <- ncvar_get(ncin, "xco2")
  latitude <- ncvar_get(ncin, "latitude")
  longitude <- ncvar_get(ncin, "longitude")
  date <- paste('20', substr(gsub("[A-z \\.\\(\\)/:]", "", files[file]), start = 4, stop = 9), sep="")
  date <- rep(date, length(longitude))
  nc_df <- data.frame(cbind(latitude, longitude, xco2, date))
  names(nc_df) <- c("latitude", "longitude", "xco2","date")
  nc_df2 <- nc_df[(nc_df$latitude < 30.5),]
  nc_df2 <- nc_df2[(nc_df2$latitude > 25),]
  nc_df2 <- nc_df2[(nc_df2$longitude < -97),]
  nc_df2 <- nc_df2[(nc_df2$longitude > -87),]
  
  csv_fname <- paste(files[file], '.csv', sep="")
  write.table(nc_df2, csv_fname, row.names=FALSE, sep=";")
}



