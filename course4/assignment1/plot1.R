header <- as.character(read.table("household_power_consumption.txt", sep = ";", nrows = 1, as.is = TRUE))
data <- read.table("household_power_consumption.txt", sep = ";", na.strings = "?", skip = 66637, nrows = 2880, col.names = header)
png(file = "plot1.png")
hist(data$Global_active_power, col = "#FC3119", main = "Global Active Power", xlab = "Global Active Power (kilowatts)", ylab = "Frequency")
dev.off()