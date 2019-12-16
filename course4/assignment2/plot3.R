library(ggplot2)
library(dplyr)
NEI <- readRDS("summarySCC_PM25.rds")
balti <- subset(NEI, fips == "24510")
balti_summary <- balti %>%
        group_by(type, year) %>%
        summarise(totals = sum(Emissions))
png(file = "plot3.png")
qplot(year, totals, data = balti_summary, facets = . ~ type) + geom_line() + labs(x = "Year", y = "PM2.5 emissions (tons)", title = "PM2.5 emissions in Baltimore City by type of source (1999 - 2008)")
dev.off()