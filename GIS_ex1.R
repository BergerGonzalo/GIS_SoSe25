
#title: "Exercise 1"
#Author: Gonzalo Berger
#GITHub: https://github.com/BergerGonzalo/GIS_SoSe25

#Installing packages and loading libraries

install.packages("pacman")
library(pacman)
install.packages("sf")
library(sf)
install.packages("ggplot2")
library(ggplot2)
install.packages("readr")
library(readr)
options(device = "windows")

#Importing the data from GADM

deu_4 <- st_read("data/gadm41_DEU_shp/gadm41_DEU_4.shp")

admin_4 <- ggplot()+
  geom_sf(data = deu_4)+
  theme_minimal()

#Visualizing the map of Dresden

names(deu_4)
Dresden <- deu_4[8760, ]

Dresden_plot <- ggplot()+
  geom_sf(data = Dresden)

print(Dresden_plot)

#Cemeteries

cemeteries <- read_delim("Friedhöfe.csv", delim = ";")
names(cemeteries)
cemeteries_sf <- st_as_sf(cemeteries, wkt = "geom")

cemeteries_area_plot <- ggplot()+
  geom_sf(data=Dresden, colour="grey")+
  geom_sf(data= cemeteries_sf, aes(fill= "Cemeteries"),show.legend = "point",colour="red")+
  labs(fill="")+
  theme_minimal()

print(cemeteries_area_plot)

#Houses

houses <- read_delim("data_houses/dresden.json")
houses_names <- colnames(houses)
houses <- rbind(houses_names, houses)
colnames(houses) <- c("None", "street", "lat", "house", "lon")
houses <- houses[,-1]
houses$street <- sub(",.*", "", houses$street)
houses$lat <- sub(",.*", "", houses$lat)
houses$house <- sub(",.*", "", houses$house)
houses$lon <- sub("}.*", "", houses$lon)
colSums(is.na(houses))

houses$lon[is.na(houses$lon)] <- houses$house[is.na(houses$lon)]
houses$lon <- sub("}.*", "", houses$lon)
colSums(is.na(houses))
houses <- houses[,-3]
houses <- houses[houses$lon >= 13.5 & houses$lon <= 14.0, ]

houses_sf <- st_as_sf(houses, coords = c("lon", "lat"), crs = 4326)

houses_area_plot <- ggplot()+
  geom_sf(data=Dresden, colour="grey")+
  geom_sf(data= houses_sf, aes(fill= "Houses"),show.legend = "point",colour="darkgrey", size = 0.0001)+
  labs(fill="")+
  theme_minimal()
print(houses_area_plot)

#Green and open spaces

green_spaces <- read_delim("Grün- und Freiflächen.csv", delim = ";")
green_spaces_sf <- st_as_sf(green_spaces, wkt = "shape")

green_spaces_area_plot <- ggplot()+
  geom_sf(data=Dresden, colour="grey")+
  geom_sf(data = green_spaces_sf, fill = "darkgreen", colour = "darkgreen")+
  labs(fill="")+
  theme_minimal()

print(green_spaces_area_plot)

#Bodies of water

bodies_of_water <- read_delim("Elbe und stehende Gewässer.csv", delim = ";")
bodies_of_water_sf <- st_as_sf(bodies_of_water, wkt = "shape")

bodies_of_water_area_plot <- ggplot()+
  geom_sf(data=Dresden, colour="grey")+
  geom_sf(data= bodies_of_water_sf, fill = "blue",colour="blue")+
  labs(fill="")+
  theme_minimal()

print(bodies_of_water_area_plot)

#Tram lines

tram_lines <- read_delim("Straßenbahntrassen.csv", delim = ";")
tram_lines_sf <- st_as_sf(tram_lines, wkt = "geom")

tram_lines_area_plot <- ggplot()+
  geom_sf(data=Dresden, colour="grey")+
  geom_sf(data= tram_lines_sf, aes(fill= "Tram lines"),show.legend = "point",colour="black")+
  labs(fill="")+
  theme_minimal()
print(tram_lines_area_plot)

#Bus lines

bus_lines <- read_delim("Buslinien.csv", delim = ";")
bus_lines_sf <- st_as_sf(bus_lines, wkt = "shape")

bus_lines_area_plot <- ggplot()+
  geom_sf(data=Dresden, colour="grey")+
  geom_sf(data= bus_lines_sf, aes(fill= "Bus lines"),show.legend = "point",colour="gold")+
  labs(fill="")+
  theme_minimal()
print(bus_lines_area_plot)

#Bike paths

bike_paths <- read_delim("Anlagen des Radverkehrs.csv", delim = ";")
bike_paths_sf <- st_as_sf(bike_paths, wkt = "geom")

bike_paths_area_plot <- ggplot()+
  geom_sf(data=Dresden, colour="grey")+
  geom_sf(data= bike_paths_sf, aes(fill= "Bike paths"),show.legend = "point",colour="purple")+
  labs(fill="")+
  theme_minimal()
print(bike_paths_area_plot)

#Libraries

libraries <- read_delim("Bibliotheken.csv", delim = ";")
libraries_sf <- st_as_sf(libraries, wkt = "geom")

libraries_area_plot <- ggplot()+
  geom_sf(data=Dresden, colour="grey")+
  geom_sf(data= libraries_sf, aes(fill= "Libraries"),show.legend = "point",colour="cyan")+
  labs(fill="")+
  theme_minimal()
print(libraries_area_plot)

#Combining all the layers into one plot

Dresden_area_plot <- ggplot()+
  geom_sf(data=Dresden, colour="grey")+
  geom_sf(data = green_spaces_sf, aes(fill = "Green and open spaces"), colour = "darkgreen")+
  geom_sf(data= bodies_of_water_sf, aes(fill = "Water bodies"),colour="blue")+
  geom_sf(data= houses_sf, fill= "darkgrey",colour="darkgrey", size = 0.0001)+
  geom_sf(data= bike_paths_sf, aes(fill= "Bike paths"), colour = "purple")+
  geom_sf(data= cemeteries_sf, aes(fill= "Cemeteries"), shape = 17, colour="red", size = 1.5)+
  geom_sf(data= libraries_sf, aes(fill = "Libraries"), shape = 17, colour="cyan", size = 1.5)+
  geom_sf(data= bus_lines_sf, aes(fill= "Bus lines"), colour = "gold")+
  geom_sf(data= tram_lines_sf, aes(fill = "Tram lines"), size = 2.0)+
  scale_fill_manual(
    name = "Legend",
    values = c(
      "Green and open spaces" ="darkgreen",
      "Water bodies" = "blue",
      "Bus lines" = "gold",
      "Bike paths" = "purple",
      "Cemeteries" = "red",
      "Libraries" = "cyan",
      "Tram lines" = "black"))+
  labs(fill="",
       title = "Map of Dresden")+
  theme_minimal()+
  theme(plot.title = element_text(hjust = 0.5))

#Output

print(Dresden_area_plot)

