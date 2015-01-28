###
###Calculating age standardized rates, using the Canadian Standard 1991 Population
###
###takes as input the BC and Cad Std Population references files, and raw data 
###straight outta tosca for the counts.
###

library("plyr")
library("dplyr")
library("reshape2")

setwd("T:/A - Data-Research/Sara Weinstein Research/R Scripts/
      AgeStandardizedRates/age-std-rates")
popdata <- read.csv("150122 BC Population Data.csv")
stdpop <- read.csv("141114 Canada Standard 1991 Pop.csv")
input = ("150116 Suicide.csv")
regions <- read.csv("T:/A - Data-Research/Sara Weinstein Research/
                    Reference Files/List of Townships.csv")

###
###Read in data, make corrections including remove duplicates, recode 
###'head office',change Oct-19 to 10-19
###

case_data <- read.csv(input)
case_data <- subset(case_data, !duplicated(case_data$CaseNumber))
case_data <- subset(case_data, "Age" != "" | !duplicated(case_data$CaseNumber))

###Replace 'Head Office' with region corresponding to Township of Death, and
###remove Head Office as a factor level
head_office <- case_data$Region == 'Head Office'
case_data$Region[head_office] <- regions$RecodeRegion[match(case_data$Death.Township[head_office], 
                                                           regions$Township)]
case_data <- droplevels(case_data)
rm(head_office)
rm(regions)

###take subset of case_data
case_data <- case_data[, c("CaseNumber", "AgeGrp", "Region", "DateOfDeath..Year")]
#with dplyr case_data <- select(case_data, CaseNumber, AgeGrp, Region, DateOfDeath..Year)
case_data <- rename(case_data, c("DateOfDeath..Year" = "DeathYear"))

###replace "19-Oct" with "10-19", add factor level "Uk" for missing age group
stdpop <- within(stdpop, levels(AgeGrp)[levels(AgeGrp) == "19-Oct"] <- "10-19")
case_data <- within(case_data, levels(AgeGrp)[levels(AgeGrp) == "19-Oct"] <- "10-19")
case_data <- within(case_data, levels(AgeGrp)[levels(AgeGrp) == ""] <- "Uk")

###
###data tidying
###

###Population Data: contains BC pop by region and age group. Melt data to
###long format and rename variable and value columns. Subset to remove 
###unwanted years
popdataL <- melt(popdata, id.vars = c("Region", "Year"))
popdataL <- rename(popdataL, c("variable" = "AgeGrp", "value" = "Pop"))
popdataL <- 

###aggregate case data by region, year & age group  
counts <- count(case_data, c("Region", "DeathYear", "AgeGrp"))

###remove all rows with AgeGrp 'uk', and reset factor levels   <- better to remove UK during subsetting
counts <- subset(counts[counts$AgeGrp != "Uk",])
counts$AgeGrp <- as.factor(counts$AgeGrp)
counts$DeathYear <- as.factor(counts$DeathYear)



