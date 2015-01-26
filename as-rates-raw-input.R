###
###Calculating age standardized rates, using the Canadian Standard 1991 Population
###
###takes as input the BC and Cad Std Population references files, and raw data 
###straight outta tosca for the counts.
###

library("plyr")
library("dplyr")
library("reshape2")

setwd("T:/A - Data-Research/Sara Weinstein Research/R Scripts/AgeStandardizedRates/age-std-rates")
popdata <- read.csv("150122 BC Population Data.csv")
stdpop <- read.csv("141114 Canada Standard 1991 Pop.csv")
input = ("150116 Suicide.csv")
regions <- read.csv("T:/A - Data-Research/Sara Weinstein Research/Reference Files/List of Townships.csv")

###Read in data, remove duplicates
tosca_data <- read.csv(input)
tosca_data <- subset(tosca_data, !duplicated(tosca_data$CaseNumber))

###Replace 'Head Office' with region corresponding to Township of Death, and
###remove Head Office as a factor level
head_office <- tosca_data$Region == 'Head Office'
tosca_data$Region[head_office] <- regions$RecodeRegion[match(tosca_data$Death.Township[head_office], 
                                                           regions$Township)]
tosca_data <- droplevels(tosca_data)
rm(head_office)
rm(regions)

###take subset of tosca_data
data <- tosca_data[, c("CaseNumber", "AgeGrp", "Region", "DateOfDeath..Year")]
data <- rename(data, c("DateOfDeath..Year" = "DeathYear"))

###replace "19-Oct" with "10-19", add factor level "Uk" for missing age group
stdpop <- within(stdpop, levels(AgeGrp)[levels(AgeGrp) == "19-Oct"] <- "10-19")
data <- within(data, levels(AgeGrp)[levels(AgeGrp) == "19-Oct"] <- "10-19")
data <- within(data, levels(AgeGrp)[levels(AgeGrp) == ""] <- "Uk")


###
###data prep
###
