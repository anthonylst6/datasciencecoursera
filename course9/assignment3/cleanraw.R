# Load necessary libraries
suppressPackageStartupMessages(library(dplyr))
library(tidyr)

# Load data
pv <- read.csv("rawdata/lgas_41d2.csv")
seifa <- read.csv("rawdata/ABS_SEIFA2016_LGA_19022020125819856 (seifa).csv")
pop <- read.csv("rawdata/ABS_REGIONAL_LGA2018_19022020132231122 (population).csv")
edu <- read.csv("rawdata/ABS_REGIONAL_LGA2018_19022020132647134 (education).csv")

# Create dataframe for plotting
seifa <- seifa %>%
        filter(SEIFAINDEXTYPE == "IRSAD" & SEIFA_MEASURE == "SCORE") %>%
        select(LGA = Local.Government.Areas...2016, IRSAD = Value)
pv <- pv %>%
        select(LGA = lga_name, Density = density_lga, Installations = instals_lga, Capacity = capacity_lga)
pop <- pop %>%
        filter(Time == 2016) %>%
        filter(Data.item == "Median Age - Persons (years)" | Data.item == "Population density (persons/km2)" | Data.item == "Total born overseas (%)") %>%
        select(LGA = Region, Predictor = Data.item, Value) %>%
        pivot_wider(names_from = Predictor, values_from = Value)

edu <- edu %>%
        filter(Time == 2016) %>%
        filter(Data.item == "Completed Year 12 or equivalent (%)" | Data.item == "Bachelor Degree (%)") %>%
        select(LGA = Region, Predictor = Data.item, Value) %>%
        pivot_wider(names_from = Predictor, values_from = Value)

data <- merge(pv, seifa, by = "LGA") %>%
        merge(pop, by = "LGA") %>%
        merge(edu, by = "LGA") %>%
        na.omit()

# Output file as CSV
write.csv(data, "application/data.csv", row.names = FALSE)