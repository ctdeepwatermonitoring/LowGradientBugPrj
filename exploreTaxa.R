setwd("/home/mkozlak/Documents/Projects/GitHub/LowGradientBugPrj")#Set your working directory

##Libraries to Load
library(leaflet)
library(ggplot2)

##Import the data
mastertaxa<-read.csv("data/masterTaxalist.csv",header=TRUE,stringsAsFactors = FALSE)
taxa<-read.csv("data/highGradientTaxaData_2011_2015.csv",header=TRUE,stringsAsFactors = FALSE)

taxa[1:10,] #check out the first ten rows of the taxa data
dim(taxa) #get number of rows and columns
taxa<-taxa[taxa$Rep==1&taxa$Subsample.Rep=="First",]  #Filter out only rep 1 subsample 1 data

##Get all unique sites and make a quick interactive map (if using RStudio can see in viewer)
sites<-unique(taxa[c("STA_SEQ","Station_Name","YLat","XLong")])
sitemap<-leaflet(data=sites) %>%
            addTiles() %>%
            addCircleMarkers(lng=sites$XLong,lat =sites$YLat,label=paste(sites$STA_SEQ," ",sites$Station_Name))
sitemap

##Merge the taxa data with the Master Taxa List
taxaM <- merge(taxa,mastertaxa,by.x="TaxonNameCurrent",by.y="finalID")

########AGGREGATE and Plot Occurence Counts at Specified Taxa Level#####################
names(taxaM)
TaxaL<-"GENUS"  ##Specify the taxa level of interest to explore and then run code below to get plot

length(unique(taxaM[,TaxaL]))##Get the total number of unique taxa
length(unique(taxaM$VisitNum))##Get the total number of unique samples
sumTaxa<-unique(taxaM[c("VisitNum",TaxaL)])
sumTaxa<-sumTaxa[sumTaxa[,TaxaL]!='Na',]##Filter out Taxa listed as 'Na'

sumTaxa <- aggregate(sumTaxa$VisitNum,by=list(TaxaNm=sumTaxa[,TaxaL]),FUN=length)##Count the number of times observed in a sample
colnames(sumTaxa)[1]<-TaxaL
sumTaxa<-sumTaxa[order(-sumTaxa$x),]
sumTaxa10<-sumTaxa[1:10,] ##Parse out the top 10 highest occurring taxa to plot
sumTaxa10[,TaxaL]<-factor(sumTaxa10[,TaxaL],levels=sumTaxa10[,TaxaL])#Need to transform data type to factor to get ggplot to plot in correct order
sumTaxa10$Pct<-(sumTaxa10$x/length(unique(taxaM$VisitNum)))*100 ##Calculate the percent of occurence across all samples

##Plot the top 10 highest occurring taxa
ggplot(sumTaxa10,aes(sumTaxa10[,TaxaL],Pct))+
  geom_col()+
  coord_flip()+
  labs(y="Percent of Taxa Occurence Across All Samples",x=TaxaL)