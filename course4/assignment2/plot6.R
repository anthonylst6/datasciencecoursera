library(ggplot2)
library(dplyr)
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
index <- grep("Mobile(.*)Vehicles", SCC$EI.Sector)
scc_motor <- SCC$SCC[index]
motor <- subset(NEI, SCC %in% scc_motor & (fips == "24510" | fips == "06037"))
motor_summary <- motor %>%
        group_by(fips, year) %>%
        summarise(motor_totals = sum(Emissions))
png(file = "plot6.png")
g <- ggplot(motor_summary, aes(year, motor_totals))
to_string <- as_labeller(c(`06037` = "Los Angeles County, California", `24510` = "Baltimore City, Maryland"))
g + geom_point() + facet_wrap(. ~ fips, labeller = to_string) + geom_line() + labs(x = "Year", y = "PM2.5 emissions (tons)", title = "PM2.5 motor emissions in Los Angeles and Baltimore City (1999 - 2008)")
dev.off()