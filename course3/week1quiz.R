# Week 1 Quiz

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv", destfile = "./data/housing.csv")
housing <- read.csv("./data/housing.csv")
sum(housing$VAL == 24, na.rm = TRUE)

library(openxlsx)
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx", destfile = "./data/gas.xlsx")
dat <- read.xlsx("./data/gas.xlsx", rows = 18:23, cols = 7:15)
sum(dat$Zip*dat$Ext,na.rm=T)

library(XML)
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml", destfile = "./data/restaurants.xml")
doc <- xmlTreeParse("./Data/restaurants.xml", useInternal = TRUE)
sum(xpathSApply(doc, "//zipcode", xmlValue) == 21231)

library(data.table)
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv", destfile = "./data/community.csv")
DT <- fread("./data/community.csv")
system.time(DT[, mean(pwgtp15), by = SEX])