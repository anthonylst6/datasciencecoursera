# Question 1

library(httr)

oauth_endpoints("github")

myapp <- oauth_app("github",
                   key = "(deleted for privacy)",
                   secret = "(deleted for privacy)"
)

github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

gtoken <- config(token = github_token)
req <- GET("https://api.github.com/users/jtleek/repos", gtoken)
stop_for_status(req)
content <- content(req)

for(i in 1:length(content)) {
        if(content[[i]]$url == "https://api.github.com/repos/jtleek/datasharing") {
                print(content[[i]]$created_at)
        }
        else next
}


# Question 2 and 3

library(sqldf)
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv", "./data/acs.csv")
acs <- read.csv("./data/acs.csv")
sqldf("select PWGTP from acs where AGEP < 50")
sqldf("select distinct AGEP from acs")


# Question 4

con <- url("http://biostat.jhsph.edu/~jleek/contact.html")
htmlCode <- readLines(con)
close(con)
nchar(htmlCode[c(10, 20, 30, 100)])


# Question 5

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for", "./data/wksst8110.for")
data <- read.fwf(file = "./data/wksst8110.for", widths = c(10, 9, 4, 9, 4, 9, 4, 9, 4), skip = 4)
sum(data[, 4])