setwd("P:/Projects/GitHub_Prj/LowGradientBugPrj")#Set your working directory

library(leaflet)

##Import the data
mastertaxa<-read.csv("data/masterTaxalist.csv",header=TRUE)
taxa<-read.csv("data/highGradientTaxaData_2011_2015.csv",header=TRUE)

taxa[1:10,] #check out the first ten rows of the taxa data

##Get all unique sites and make a quick interactive map (if using RStudio can see in viewer)
sites<-unique(taxa[c("STA_SEQ","Station_Name","YLat","XLong")])
sitemap<-leaflet(data=sites) %>%
            addTiles() %>%
            addCircleMarkers(lng=sites$XLong,lat =sites$YLat,label=paste(sites$STA_SEQ," ",sites$Station_Name))
sitemap

taxaM <- merge(taxa,mastertaxa,by.x="TaxonNameCurrent",by.y="finalID")