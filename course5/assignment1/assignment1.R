library(ggplot2)
library(dplyr)

# Loading and preprocessing the data
data <- read.csv("activity.csv", header = TRUE)

# What is mean total number of steps taken per day?
data1 <- data %>%
        group_by(date) %>%
        summarise(steps_total = sum(steps))
ggplot(data1, aes(steps_total)) + geom_histogram(bins = 10) + labs(x = "Number of steps", y = "Frequency", title = "Frequency of total steps per day (excluding missing values)")
mean(data1$steps_total, na.rm = TRUE)
median(data1$steps_total, na.rm = TRUE)

# What is the average daily activity pattern?
data2 <- data %>%
        group_by(interval) %>%
        summarise(steps_avg = mean(steps, na.rm = TRUE))
ggplot(data2, aes(interval, steps_avg)) + geom_line() + labs(x = "Interval", y = "Number of steps", title = "Average number of steps in 5 minute intervals (excluding missing values)")
data2$interval[which.max(data2$steps_avg)]

# Imputing missing values
sum(is.na(data$steps))
data_imputed <- data %>%
        group_by(interval) %>%
        mutate(steps = ifelse(is.na(steps), mean(steps, na.rm = TRUE), steps)) %>%
        arrange(date)
data3 <- data_imputed %>%
        group_by(date) %>%
        summarise(steps_total = sum(steps))
ggplot(data3, aes(steps_total)) + geom_histogram(bins = 10) + labs(x = "Number of steps", y = "Frequency", title = "Frequency of total steps per day (with imputed missing values)")
mean(data3$steps_total)
median(data3$steps_total)

# Are there differences in activity patterns between weekdays and weekends?
day <- gsub("^S(.*)day", "weekend", weekdays(as.Date(data3$date)))
day <- as.factor(gsub("(.*)day", "weekday", day))
data_imputed <- data_imputed %>%
        mutate(day_type = day)
data4 <- data_imputed %>%
        group_by(day_type, interval) %>%
        summarise(steps_avg = mean(steps))
ggplot(data4, aes(interval, steps_avg)) + geom_line() + facet_grid(day_type ~ .) + labs(x = "Interval", y = "Number of steps", title = "Average number of steps in 5 minute intervals (with imputed missing values)")
