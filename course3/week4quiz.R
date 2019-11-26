# Question 1
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(url, "./data/communities.csv")
data <- read.csv("./data/communities.csv")
datanames_split <- strsplit(names(data), "wgtp")
datanames_split[[123]]

# Question 2
url2 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
download.file(url2, "./data/FGDP.csv", method = "curl")
data2 <- read.csv("./data/FGDP.csv", skip = 4)
data2 <- data2[1:190, c(1, 2, 4, 5)]
colnames(data2) <- c("CountryCode", "Rank", "Economy", "GDP")
data2$GDP <- as.numeric(gsub("," ,"", as.character(data2$GDP)))
mean(data2$GDP)

# Question 3
countryNames <- data2$Economy
length(grep("^United", countryNames))

# Question 4
url3 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
download.file(url3, "./data/FEDSTATS_Country.csv", method = "curl")
data3 <- read.csv("./data/FEDSTATS_Country.csv")
data_merged <- merge(data2, data3, by.x = "CountryCode", by.y = "CountryCode")
length(grep("Fiscal year end: June", data_merged$Special.Notes))

# Question 5
library(quantmod)
amzn = getSymbols("AMZN",auto.assign = FALSE)
sampleTimes = index(amzn)
sum(year(sampleTimes) == 2012)
sum(wday(sampleTimes) == 2 & year(sampleTimes) == 2012)