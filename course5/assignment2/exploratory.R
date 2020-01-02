# Load libraries and files
library(data.table)
library(dplyr)
library(stringr)
library(tidyr)
library(ggplot2)

# Read file
if(!file.exists("repdata_data_StormData.csv.bz2")) {
        url <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2"
        download.file(url, destfile = "repdata_data_StormData.csv.bz2", method = "curl")
}
data <- fread("repdata_data_StormData.csv.bz2")

# Reshape data
data <- data %>% # rough initial cleaning before treating fatalities, injuries, crop damage and property damage separately
        mutate(BGN_DATE = as.Date(str_extract(BGN_DATE, "^[^ ]+"), "%m/%d/%Y")) %>% # convert date strings to date format
        select(BGN_DATE, EVTYPE, FATALITIES, INJURIES, CROPDMG, CROPDMGEXP, PROPDMG, PROPDMGEXP, REMARKS) %>% # select relevant columns
        filter(year(BGN_DATE) >= 1996 & (FATALITIES != "0" | INJURIES != "0" | (CROPDMG != "0" & CROPDMGEXP != "") | (PROPDMG != "0" & PROPDMGEXP != ""))) %>% # select data from 1996 onwards, when there were 48 standardised event types
        mutate(EVTYPE = toupper(EVTYPE)) %>% # convert event types to uppercase
        mutate(EVTYPE = gsub("-", " ", EVTYPE)) %>% # convert hyphens to spaces
        mutate(EVTYPE = gsub("^ +", "", EVTYPE)) %>% # remove spaces at beginning
        mutate(EVTYPE = gsub("  +", " ", EVTYPE)) %>% # convert multiple spaces to single space
        mutate(EVTYPE = gsub("IES$", "Y", EVTYPE)) %>% # convert plural ending with IES to singular
        mutate(EVTYPE = gsub("S$", "", EVTYPE)) %>% # convert plural ending with S to singular
        mutate(EVTYPE = gsub("COASTALSTORM", "COASTAL STORM", EVTYPE)) %>% # add missing spaces
        mutate(EVTYPE = gsub("CSTL", "COASTAL", EVTYPE)) %>% # extend out abbreviations
        mutate(EVTYPE = gsub("FLD", "FLOOD", EVTYPE)) %>% # extend out abbreviations
        mutate(EVTYPE = gsub("FLOODING", "FLOOD", EVTYPE)) %>% # standardise synonyms
        mutate(EVTYPE = gsub("HVY", "HEAVY", EVTYPE)) %>% # extend out abbreviations
        mutate(EVTYPE = gsub("PRECIP$", "PRECIPITATION", EVTYPE)) %>% # extend out abbreviations
        mutate(EVTYPE = gsub("SML", "SMALL", EVTYPE)) %>% # extend out abbreviations
        mutate(EVTYPE = gsub("TSTM", "THUNDERSTORM", EVTYPE)) %>% # extend out abbreviations
        mutate(EVTYPE = gsub("UNSEASONABLE", "UNSEASONABLY", EVTYPE)) %>% # standardise synonyms
        mutate(EVTYPE = gsub("WINDCHILL", "WIND CHILL", EVTYPE)) %>% # change for consistency
        mutate(EVTYPE = gsub("WINTRY", "WINTERY", EVTYPE)) %>% # change for consistency
        mutate(EVTYPE = gsub("(.*)COAST(.*)", "COASTAL FLOOD", EVTYPE)) %>% # group together differently named event types
        mutate(EVTYPE = gsub("^COLD(.*)", "COLD/WIND CHILL", EVTYPE)) %>% # group together differently named event types
        mutate(EVTYPE = gsub("^EXTREME(.*)", "EXTREME COLD/WIND CHILL", EVTYPE)) %>% # group together differently named event types
        mutate(EVTYPE = gsub("(.*)FLASH(.*)", "FLASH FLOOD", EVTYPE)) %>% # group together differently named event types
        mutate(EVTYPE = gsub("(.*)SURF(.*)", "HIGH SURF", EVTYPE)) %>% # group together differently named event types
        mutate(EVTYPE = gsub("^HIGH WIND(.*)", "HIGH WIND", EVTYPE)) %>% # group together differently named event types
        mutate(EVTYPE = gsub("(.*)HURRICANE(.*)|(.*)TYPHOON(.*)", "HURRICANE/TYPHOON", EVTYPE)) %>% # group together differently named event types
        mutate(EVTYPE = gsub("^IC(.*)ROAD$", "FROST/FREEZE", EVTYPE)) %>% # group together differently named event types
        mutate(EVTYPE = gsub("^THUNDERSTORM WIND(.*)", "THUNDERSTORM WIND", EVTYPE)) %>% # group together differently named event types
        mutate(EVTYPE = gsub("^STORM SURGE(.*)", "STORM SURGE/TIDE", EVTYPE)) %>% # group together differently named event types
        mutate(EVTYPE = gsub("^WIND(.*)", "STRONG WIND", EVTYPE)) %>% # group together differently named event types
        mutate(EVTYPE = gsub("^WINTER WEATHER(.*)", "WINTER WEATHER", EVTYPE)) # group together differently named event types

data_fatalities <- data %>% # processing fatalities data
        filter(FATALITIES != "0") %>% # select only rows which have injuries
        group_by(EVTYPE) %>% # group by event type
        summarise(FATALITIES = sum(FATALITIES)) %>% # calculate total fatalities for each event type
        arrange(desc(FATALITIES)) # arrange in descending order by total fatalities

data_injuries <- data %>% # processing injuries data
        filter(INJURIES != "0") %>% # only select rows which have injuries
        group_by(EVTYPE) %>% # group by event type
        summarise(INJURIES = sum(INJURIES)) %>% # calculate total injuries for each event type
        arrange(desc(INJURIES)) # arrange in descending order by total injuries

data_cropdmg <- data %>% # processing crop damage data
        filter(CROPDMG != "0" & CROPDMGEXP != "") %>% # only select rows which have crop damage
        mutate(CROPDMGEXP = sub("K", 0.000001, CROPDMGEXP)) %>% # convert character to multiplier (in billions)
        mutate(CROPDMGEXP = sub("M", 0.001, CROPDMGEXP)) %>% # convert character to multiplier (in billions)
        mutate(CROPDMGEXP = sub("B", 1, CROPDMGEXP)) %>% # convert character to multiplier (in billions)
        group_by(EVTYPE) %>% # group by event type
        summarise(CROP = sum(CROPDMG * as.numeric(CROPDMGEXP))) %>% # calculate total crop damage for each event type
        arrange(desc(CROP)) # arrange in descending order by total crop damage

data_propdmg <- data %>% # processing crop damage data
        filter(PROPDMG != "0" & PROPDMGEXP != "") %>% # only select rows which have crop damage
        mutate(PROPDMGEXP = sub("K", 0.000001, PROPDMGEXP)) %>% # convert character to multiplier (in billions)
        mutate(PROPDMGEXP = sub("M", 0.001, PROPDMGEXP)) %>% # convert character to multiplier (in billions)
        mutate(PROPDMGEXP = sub("B", 1, PROPDMGEXP)) %>% # convert character to multiplier (in billions)
        group_by(EVTYPE) %>% # group by event type
        summarise(PROPERTY = sum(PROPDMG * as.numeric(PROPDMGEXP))) %>% # calculate total crop damage for each event type
        arrange(desc(PROPERTY)) # arrange in descending order by total property damage

data_harm <- merge(data_fatalities, data_injuries, all = TRUE) %>% # merge fatalities and injuries data (full outer join)
        pivot_longer(-EVTYPE, names_to = "CONDITION", values_to = "COUNT") %>% # convert data to long format for ggplot
        arrange(CONDITION, desc(COUNT)) %>% # arrange data to see top counts
        filter((CONDITION == "FATALITIES" & COUNT > 500) | (CONDITION == "INJURIES" & COUNT > 4000)) # only select top 5 counts for each condition

data_cost <- merge(data_cropdmg, data_propdmg, all = TRUE) %>% # merge crop damage and property damage data (full outer join)
        rowwise() %>% # rowwise function for next step
        mutate(TOTAL = sum(CROP, PROPERTY, na.rm = TRUE)) %>% # create column containing total damage for each event type
        pivot_longer(-EVTYPE, names_to = "DAMAGE", values_to = "COST") %>% # convert data to long format for ggplot
        arrange(DAMAGE, desc(COST)) %>% # arrange data to see top costs
        filter((DAMAGE == "CROP" & COST > 1.330) | (DAMAGE == "PROPERTY" & COST > 15) | (DAMAGE == "TOTAL" & COST > 17)) # only select top 5 costs for each damage category

# Plot graphs
if(!file.exists("reorder_within.R")) {
        url <- "https://raw.githubusercontent.com/dgrtwo/drlib/master/R/reorder_within.R"
        download.file(url, destfile = "reorder_within.R", method = "curl")
} # download R package that allows for reordering bars within facets in ggplot
source("reorder_within.R") # source the R package
ggplot(data_harm, aes(reorder_within(EVTYPE, -COUNT, CONDITION), COUNT)) + geom_col() + scale_x_reordered() + facet_wrap(. ~ CONDITION, scales = "free_x") + theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1, vjust = 1)) + labs(x = "Event type", y = "Number of occurrences", title = "Top 5 harmful weather events by fatalities and injuries (1996-2011)")
ggplot(data_cost, aes(reorder_within(EVTYPE, -COST, DAMAGE), COST)) + geom_col() + scale_x_reordered() + facet_wrap(. ~ DAMAGE, scales = "free_x") + theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1, vjust = 1)) + labs(x = "Event type", y = "Cost (in billions of dollars)", title = "Top 5 costly weather events by crop, property and total damage expenses (1996-2011)")

# Exploratory analysis
head(data)
tail(data)
str(data)
unique(data$EVTYPE)
unique(data$PROPDMGEXP)
unique(data$CROPDMGEXP)
sum(data$PROPDMGEXP == "0")
data[grep("0", data$PROPDMGEXP), ]
x <- unique(data$EVTYPE)
y <- x[order(x)]
y
x1 <- unique(data_fatalities$EVTYPE)
y1 <- x1[order(x1)]
y1
x2 <- unique(data_injuries$EVTYPE)
y2 <- x2[order(x2)]
y2
x3 <- unique(data_cropdmg$EVTYPE)
y3 <- x3[order(x3)]
y3
x4 <- unique(data_propdmg$EVTYPE)
y4 <- x4[order(x4)]
y4
table(data$EVTYPE, data$PROPDMGEXP)
tapply(data_fatalities$FATALITIES, data_fatalities$EVTYPE, sum)
table(data_injuries$EVTYPE, data_injuries$INJURIES)
table(data_cropdmg$EVTYPE, data_cropdmg$CROPDMGEXP)
table(data_propdmg$EVTYPE, data_propdmg$PROPDMGEXP)
par(mfrow = c(1, 2))
with(data_fatalities, barplot(height = FATALITIES_TOTAL[1:5], names.arg = EVTYPE[1:5], xlab = "Event Type", ylab = "Total Fatalities", main = "Top 5 events by fatalities (1996-2011)"))
with(data_injuries, barplot(height = INJURIES_TOTAL[1:5], names.arg = EVTYPE[1:5], xlab = "Event Type", ylab = "Total Injuries", main = "Top 5 events by injuries (1996-2011)"))