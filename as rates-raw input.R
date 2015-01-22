###
###Calculating age standardized rates, using the Canadian Standard 1991 Population
###
###takes as input the BC and Cad Std Population references files, and raw data 
###straight outta tosca for the counts.
###

library("plyr")
library("dplyr")
library("reshape2")

setwd("T:/A - Data-Research/Sara Weinstein Research/R Scripts/AgeStandardizedRates")
popdata <- read.csv("150122 BC Population Data.csv")
stdpop <- read.csv("141114 Canada Standard 1991 Pop.csv")
counts <- read.csv("150116 Suicide.csv")

###replace "19-Oct" with "10-19"
stdpop[, "AgeGrp"] <- as.character(stdpop[, "AgeGrp"])
stdpop[2, "AgeGrp"] <- "10-19"
stdpop[, "AgeGrp"] <- factor(stdpop[, "AgeGrp"])

###
###data prep
###