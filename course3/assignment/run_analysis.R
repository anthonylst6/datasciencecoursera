# Load packages and data
library(dplyr)
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
features <- read.table("./UCI HAR Dataset/features.txt")

# Merge the training and the test sets to create one data set:
X_test <- X_test %>%
        mutate(activity = y_test$V1, subject = subject_test$V1, set = "TEST")
X_train <- X_train %>%
        mutate(activity = y_train$V1, subject = subject_train$V1, set = "TRAINING")
data <- bind_rows(X_test, X_train)

# Extract only the measurements on the mean and standard deviation for each measurement:
index <- sort(c(grep("mean()", features$V2, fixed = TRUE), grep("std()", features$V2, fixed = TRUE)))
data <- data %>%
        select(index, activity, subject, set)

# Use descriptive activity names to name the activities in the data set:
f <- function(x) {
        as.character(activity_labels$V2[x])
}
data <- data %>%
        mutate(activity = f(activity))

# Label the data set with descriptive variable names:
varnames <- c(as.character(features$V2[index]), "activity", "subject", "set")
colnames(data) <- varnames

# From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject:
data2 <- data %>%
        group_by(subject, set, activity) %>%
        summarise_at(varnames[1:66], mean) %>%
        arrange(subject, activity)

# Output created data set
write.table(data2, "dataset.txt", row.names = FALSE)