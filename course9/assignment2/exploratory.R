# Load necessary libraries
suppressPackageStartupMessages(library(plotly))
suppressPackageStartupMessages(library(dplyr))
library(tidyr)

# Download data if it doesn't exist
if(!file.exists("lgas_41d2.csv")) {
        url <- "https://d284f79vx7w9nf.cloudfront.net/attachments/analysis/13/lgas_41d2.csv"
        download.file(url, destfile = "lgas_41d2.csv")
}
if(!file.exists("ABS_SEIFA2016_LGA_19022020125819856 (seifa).csv")) {
        url <- "http://stat.data.abs.gov.au/Download.ashx?type=csv&Delimiter=%2c&IncludeTimeSeriesIdentifiers=False&LabelType=CodeAndLabel&LanguageCode=en"
        download.file(url, destfile = "ABS_SEIFA2016_LGA_19022020125819856 (seifa).csv")
}

# Load data
pv <- read.csv("lgas_41d2.csv")
seifa <- read.csv("ABS_SEIFA2016_LGA_19022020125819856 (seifa).csv")

# Create dataframe for plotting
seifa <- seifa %>%
        filter(SEIFA_MEASURE == "SCORE") %>%
        select(LGA = Local.Government.Areas...2016, SEIFAINDEXTYPE, Score = Value) %>%
        pivot_wider(names_from = SEIFAINDEXTYPE, values_from = Score)
pv <- pv %>%
        select(LGA = lga_name, Density = density_lga)
df <- merge(pv, seifa, by = "LGA") %>%
        pivot_longer(IEO:IRSD, names_to = "Index", values_to = "Score") %>%
        na.omit()

# Make plot
g <- ggplot(df, aes(x = Score, y = Density, z = LGA)) + facet_wrap(. ~ Index) + 
        geom_point(alpha = 0.4) + geom_smooth(mapping = aes(x = Score, y = Density), formula = y ~ x, method = "loess", inherit.aes = FALSE)
ggplotly(g)