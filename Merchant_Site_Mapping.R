#           Raghav Sharma             #
#           June 25, 2023             #
#     Merchant Site Mapping - AtoB    #
#######################################

#Install and Load Necessary Packages
install.packages("tidyverse")
install.packages("xlsx")
library(xlsx)
library(tidyverse)
library(dplyr)


#Import the files
merchants <- read.csv("merchants.csv", header = TRUE, sep = ",")
OPIS <- read.csv("OPIS.csv", header = TRUE, sep = ",")
CircleK <- read.csv("CircleK.csv", header = TRUE, sep=",")


#Clean the Datasets
CircleK_concise <- CircleK[ , names(CircleK) %in% c("Store.Number", "OPIS.ID")]
OPIS_concise <- OPIS[ , names(OPIS) %in% c ("OPIS.STATION.ID", "STATION_NAME")]
merchants_concise <- merchants[ , names(merchants) %in% c ("MERCHANT.ID", "NAME")]

#####################################################################################
#extract string lengths 
#Circle K
OPIS_concise$len <- nchar(OPIS_concise$STATION_NAME)
OPIS_concise$lenmin3 <- OPIS_concise$len - 3

#Merchant List
merchants_concise$len <- nchar(merchants_concise$NAME)
merchants_concise$lenmin3 <- merchants_concise$len - 3

#Circle K
CircleK_concise$len <- nchar(CircleK_concise$Store.Number)
CircleK_concise$lenmin3 <- nchar(CircleK_concise$Store.Number) - 3


#make ID variable of last 4 characters in station name
OPIS_concise$id <- substr(OPIS_concise$STATION_NAME,OPIS_concise$lenmin3,OPIS_concise$len)

CircleK_concise$id <- substr(CircleK_concise$Store.Number, CircleK_concise$lenmin3, CircleK_concise$len)

merchants_concise$id <- substr(merchants_concise$NAME, merchants_concise$lenmin3, merchants_concise$len)

##################################################
#checking OPIS and Merchant IDs against each other
##################################################
merchants_concise$OPIS_id <- NA
merchants_concise$OPIS_id <- ifelse(merchants_concise$id == merchants_concise$id, 
                                    OPIS_concise$OPIS.STATION.ID,
                                    all(na.rm = FALSE))

#####################################################################################
#Extra steps for Circle K Dataset

#merging into a new dataset
OPIS_CIRCLEK <- merge(CircleK_concise,OPIS_concise, by="id", na.rm = FALSE)

#cleaning columns
OPIS_CIRCLEK_2 <- OPIS_CIRCLEK %>%
  select(id,OPIS.STATION.ID,Store.Number,OPIS.ID)


###################################################
#export
###################################################

write.xlsx(OPIS_CIRCLEK_2, file="merged_OPIS_CircleK.xlsx", sheetName="Sheet A", append=FALSE)
write.xlsx(merchants_concise, file="merged_OPIS_Merchants.xlsx", sheetName="Sheet A", append=FALSE)

#Done!
######################################################################################################