# Question 1
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(url, "./data/communities.csv")
data <- read.csv("./data/communities.csv")
agricultureLogical <- (data$ACR == 3) & (data$AGS == 6)
which(agricultureLogical)

# Question 2
library(jpeg)
url2 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"
download.file(url2, "./data/jeff.jpg", method = "curl")
data2 <- readJPEG("./data/jeff.jpg", native = TRUE)
quantile(data2, c(0.3, 0.8))

# Question 3
url3 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
url4 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
download.file(url3, "./data/FGDP.csv", method = "curl")
download.file(url4, "./data/FEDSTATS_Country.csv", method = "curl")
data3 <- read.csv("./data/FGDP.csv", skip = 4)
data3 <- data3[1:190, c(1, 2, 4, 5)]
colnames(data3) <- c("CountryCode", "Rank", "Economy", "GDP")
data4 <- read.csv("./data/FEDSTATS_Country.csv")
data_merged <- merge(data3, data4, by.x = "CountryCode", by.y = "CountryCode")
data_merged$Rank <- as.numeric(as.character(data_merged$Rank))
data_merged$GDP <- as.numeric(gsub("," ,"", as.character(data_merged$GDP)))
data_merged_ranked <- data_merged[order(data_merged$Rank, decreasing = TRUE), ]
print(nrow(data_merged_ranked))
print(data_merged_ranked$Economy[13])

# Question 4
tapply(data_merged_ranked$Rank, data_merged_ranked$Income.Group, mean)[3:2]

# Question 5
library(Hmisc)
GDP_groups <- cut2(data_merged_ranked$Rank, g = 5)
table(GDP_groups, data_merged_ranked$Income.Group)