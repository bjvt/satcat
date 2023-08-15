# https://www.space-track.org/basicspacedata/query/class/satcat/orderby/INTLDES%20asc/emptyresult/show
# found the merged discussion at https://stackoverflow.com/questions/51328147/
# 
setwd("~/Dropbox/work/IntlSpace/satcat")

# setwd("/media/bvt/913d2c1c-f3d7-4c30-9b83-eca903c169dd/R/ebd_US_relDec-2019")
#install.packages("ebirdst")
#library(ebirdst)
#library(viridis)
#library(raster)
#library(sf)
#library(rnaturalearth)
#library(rjson)
#library(jsonlite)
library(tibble)
#library(ggmap)
library(dplyr)
# df.satcat reads in the latest satcat csv file from ST
df.satcat <- read.csv("satcat.21Sep20.csv", header=TRUE)
# df.country.list is a mapping of the SpaDoc and the ISO-3166 country codes.
df.country.list <- read.csv("country.list.21Sep20.csv", header=TRUE)

# take the df.satcat datafram and make a table (like a pivot table) to find number of
# assetts per country code.
df.unique <- as.data.frame(table(df.satcat$COUNTRY))
# write to a csv file
write.csv(df.unique, file = 'countries.csv')
# using Base R merged the two dataframs, aligning them by "Country" and "SpaDoc"
# similar to a vlookup, this mapps ALL the catalog entries
merged1 <- merge(df.satcat, df.country.list, by.x = "COUNTRY", by.y = "SpaDoc.Code", sort = F, all.x = T)
# merged2 maps the country list with the Frequency providing assetts per country's
# ISO codes.w
merged2 <- merge(df.unique, df.country.list, by.x = "Var1", by.y = "SpaDoc.Code", sort = F, all.x = T)
write.csv(merged1, file = 'merged1.csv')
write.csv(merged2, file = 'merged2.csv')
#find the object type's quantities for the AOR'
# seems easiest to create an AOR unique dataframe,  the AOR member can be changed in the satcat csv file
df.aor <- subset(merged1, AOR == "Y")
# find the pivot for object type (row) and country (column)
df.aor.objtype <- table(df.aor$OBJECT_TYPE, df.aor$Alpha.3.Code, exclude = NULL)
df.aor.objtype
write.csv(df.aor.objtype, file = 'aor.object.type.csv')


# df.country %>% 
#   mutate(abb = state.name[match(STATE, state.abb)])
# 
# 
# df.unique %>%
#   select(unique_id, amount_due) %>%
#   distinct() %>%
#   right_join(df1, by = 'unique_id')

library(rworldmap)
newmap <- getMap(resolution = "low")
plot(newmap, xlim = c(-20, 59), ylim = c(35, 71), asp = 1)
worldmap <- getMap(resolution = "low")
plot(worldmap)

df.lat_long <- subset(df.sensors, df.sensors$entity.location.lat>0, 
                      c(sensorName, entity.countryCode, entity.location.lat, entity.location.lon))

points(df.lat_long$entity.location.lat, df.lat_long$entity.location.lon, col = "red", cex = .6)
points(38.5, -90, col = "green", cex = .9)
write.csv(df.lat_long, file = 'sensor.cords.csv')
