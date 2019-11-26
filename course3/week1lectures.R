# Reading local files

if(!file.exists("data")) {
        dir.create("data")
}
fileURL <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.csv?accessType=DOWNLOAD"
download.file(fileURL, destfile = "./data/cameras.csv")
list.files("./data")

dateDownloaded <- Sys.time()
dateDownloaded

cameraData <- read.table("./data/cameras.csv")
head(cameraData)

cameraData <- read.table("./data/cameras.csv", sep = ",", header = TRUE)
head(cameraData)

# Reading Excel files

if(!file.exists("data")) {
        dir.create("data")
}
fileURL <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.xlsx?accessType=DOWNLOAD"
download.file(fileURL, destfile = "./data/cameras.xlsx", method = "curl")
list.files("./data")

dateDownloaded <- Sys.time()
dateDownloaded

# Reading XML

library(XML)
fileUrl <- "http://www.w3schools.com/xml/simple.xml"
download.file(fileUrl, "./Data/simple.xml")
doc <- xmlTreeParse("./Data/simple.xml", useInternal = TRUE)
rootNode <- xmlRoot(doc)
xmlName(rootNode)
names(rootNode)
rootNode[[1]]
rootNode[[1]][[1]]
rootNode[1]

xmlSApply(rootNode, xmlValue)
xpathSApply(rootNode, "//name", xmlValue)
xpathSApply(rootNode, "//price", xmlValue)

fileurl <- "http://www.espn.com.au/nfl/team/_/name/bal/baltimore-ravens"
download.file(fileurl, "./Data/baltimore.html")
doc <- htmlTreeParse("./Data/baltimore.html", useInternal = TRUE)
scores <- xpathSApply(doc, "//div[@class='score']", xmlValue)
scores
teams <- xpathSApply(doc, "//div[@class='game-info']", xmlValue)
teams

# Reading JSON

library(jsonlite)
jsonData <- fromJSON("https://api.github.com/users/jtleek/repos")
names(jsonData)
names(jsonData$owner)
jsonData$owner$login
myjson <- toJSON(iris, pretty = TRUE)
cat(myjson)
iris2 <- fromJSON(myjson)
head(iris2)

# data.table

library(data.table)
DF <- data.frame(x = rnorm(9), y = rep(c("a", "b", "c"), each = 3), z = rnorm(9))
head(DF, 3)
DT <- data.table(x = rnorm(9), y = rep(c("a", "b", "c"), each = 3), z = rnorm(9))
head(DT, 3)

tables()
DT[2,]
DT[DT$y == "a",]
DT[c(2,3)]
DT[, c(2,3)]
DT[, list(mean(x), sum(z))]
DT[, table(y)]
DT[, w:=z^2]
DT2 <- DT
DT[, y:=2]
DT[, m:= {tmp <- (x+z); log2(tmp + 5)}]
DT[, a := x > 0]
DT[, b := mean(x+w), by = a]

set.seed(123);
DT <- data.table(x = sample(letters[1:3], 1E5, TRUE))
DT[, .N, by = x]

DT <- data.table(x = rep(c("a", "b", "c"), each = 100), y = rnorm(300))
setkey(DT, x)
DT['a']

DT1 <- data.table(x = c('a', 'a', 'b', 'dt1'), y = 1:4)
DT2 <- data.table(x = c('a', 'b', 'dt2'), z = 5:7)
setkey(DT1, x); setkey(DT2, x)
merge(DT1, DT2)

big_df <- data.frame(x = rnorm(1E6), y = rnorm(1E6))
file <- tempfile()
write.table(big_df, file=file, row.names = FALSE, col.names = TRUE, sep = "\t", quote = FALSE)
system.time(fread(file))
system.time(read.table(file, header = TRUE, sep = "\t"))
