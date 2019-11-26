# README

## Contents of this directory

1. **UCI HAR Dataset**
  * subdirectory containing the original test data, training data, activity_labels, features, feature information and description of experiment
  * original data from: https://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
  * downloaded from: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
2. **CodeBook.md**
  * markdown file that describes the **dataset.txt** text file, the variables within that file, and how it was derived from the original test and training data in the **UCI HAR Dataset** subdirectory
3. **dataset.txt**
  * text file containing the clean data set outputted by running the **run_analysis.R** R script file over the contents of the **UCI HAR Dataset** subdirectory
  * detailed description of this text file available within the **CodeBook.md** markdown file
4. **README.md**
  * markdown file explaining the contents of this directory and how the scripts within this directory work
5. **run_analysis.R**
  * R script file that runs over the contents of the **UCI HAR Dataset** subdirectory to output the **dataset.txt** text file
  * detailed description available below

## Tidy data and descriptive labels
The outputted **dataset.txt** text file is a tidy data set in that each row in that each variable forms a column, each observation/instance of calculation forms a row and each type of observational unit forms a table (definition of tidy data by Hadley Wickham: https://vita.had.co.nz/papers/tidy-data.pdf). Furthermore, the activity labels are descriptive in that they straightforwardly outline the activity being performed by the subject ("LAYING", "SITTING", "STANDING", "WALKING", "WALKING_DOWNSTAIRS", "WALKING_UPSTAIRS"). The variable names are also descriptive as they follow a simple schema (outlined in the **CodeBook.md** markdown file) to be easily interpreted. They are also intuitive in that they are named exactly the same as the features in the original data set. Although one could argue that these labels could be even more descriptive by explicitly spelling out the terms, for example using "time-Body-Accelerometer-mean()-X" instead of "tBodyAcc-mean()-X", the level of interpretability does not change significantly since one must refer to the original (raw) data set to contextualise the meaning of each term like 'time' and 'Body'. Thus, the used variable labels are sufficiently descriptive while still maintaining a level of correspondence with the original data set.

## How **run_analysis.R** works

The **run_analysis.R** R script file runs over the contents of the **UCI HAR Dataset** subdirectory to output the **dataset.txt** text file. Specifically, the script performs the following:
1. Merges the training and the test sets from the **UCI HAR Dataset** subdirectory to create one data set
2. Extracts only the measurements on the mean and standard deviation for each measurement
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
6. Outputs the data set created in step 5 as the **dataset.txt** text file

For a more technical breakdown, the **run_analysis.R** script first reads the measured data, activity labels for each data point and subject labels for each data point from both the test and training data sets within the **UCI HAR Dataset** subdirectory. It then appends the activity, subject and set (test or training) labels onto the measured data, row binds the test and training data, subsets only the columns/features (and also activity, subject or set) that contain the exact strings "mean()" or "std()", relabels the activity column values from classification integers to descriptive activity names, relabels the names of the columns to descriptive variable names, groups the data according to subject and activity, collapses the data set to the mean of the subsetted features in each of these groups, and finally outputs the new data set as the **dataset.txt** text file.

## How to read **dataset.txt** into R
1. Set working directory in R to the directory containing **dataset.txt**
2. Run the code `dataset <- read.table("dataset.txt", header = TRUE); View(dataset)`
