# Codebook for **dataset.txt** text file

## Project Description
This project sources and analyses accelerometry data from an experiment where 30 volunteer subjects performed 6 different activities in a lab setting. The data from the original experiment was sourced and analysed, outputting a new dataset which contains the averages of various measurements and measurement statistics for eacch subject and activity. This project is the course assignment for the Getting and Cleaning Data online course as part of the Data Science Specialization by John Hopkins University on Coursera.

## Study design and data processing

### Collection of the raw data
The raw data was downloaded from: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip. Information about the original data and experimental setup is found here: https://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones.

### Notes on the original (raw) data
The original experiment involved using the built-in accelerometer and gyroscope within a Samsung Galaxy S II smartphone to measure the linear acceleration and angular velocity of 30 volunteer subjects performing 6 different activities. The smartphone was worn on the waist of the volunteers and the subjects performed 6 different activities: WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING. Because the measured acceleration included a gravitational component, the features (described later) included removing this component to obtain the "body acceleration". The linear acceleration and angular velocity were measured over 3 axial components. The features also contain the signal data in both time and frequency domain.

The accelerometer and gyroscope data are sampled in the original (raw) data at regular intervals to produce a "feature vector" with 561 components at each sampled point. The features within each feature vector contain both measured and derived quantities, many of which are statistical estimates. For example, one of these features is "tBodyAcc-mean()-X" - which describes the estimated mean (denoted by 'mean()' in middle) of the body acceleration in the x direction (denoted by 'X' at the end), described in the time domain (denoted by 't' in beginning). Other statistical estimates such as standard deviation, maximum, minimum, etc are also present in the features vector.

## Creating the **dataset.txt** text file

### Guide to create the **dataset.txt** text file
1. Download the data from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
2. Extract the **UCI HAR Dataset** folder from the zip folder
3. Open R console and set the working directory to the directory containing the **UCI HAR Dataset** subdirectory
4. Run the **run_analysis.R** R script and the output **dataset.txt** text file should appear in the working directory

### Cleaning of the data
The **run_analysis.R** script first reads the measured data, activity labels for each data point and subject labels for each data point from both the test and training data sets within the **UCI HAR Dataset** subdirectory. It then appends the activity, subject and set (test or training) labels onto the measured data, row binds the test and training data, subsets only the columns/features (and also activity, subject or set) that contain the exact strings "mean()" or "std()", relabels the activity column values from classification integers to descriptive activity names, relabels the names of the columns to descriptive variable names, groups the data according to subject and activity, collapses the data set to the mean of the subsetted features in each of these groups, and finally outputs the new data set as the **dataset.txt** text file.

## Description of the variables in the **dataset.txt** text file
The data set is a table with 180 rows and 69 columns. It is a tidy data set in that each variable forms a column, each observation/instance of calculation forms a row and each type of observational unit forms a table (definition of tidy data by Hadley Wickham: https://vita.had.co.nz/papers/tidy-data.pdf). Because there are 30 subjects and each performed 6 activities, there are altogether 180 unique groups of subject and activity to calculate the mean of the features over, and these represent each of the 180 rows. The first three columns indicate the subject (repesented by an integer between 1-30), the set the subject belonged to ("TEST" or "TRAINING"), and the activity being performed by the subject (one of "LAYING", "SITTING", "STANDING", "WALKING", "WALKING_DOWNSTAIRS", "WALKING_UPSTAIRS"). The remaining 66 columns/variables represent the averages of each feature. Note that some features are themselves the mean of a measurement so the columns of the data set in that case represent the average of the mean. That is, it is the average of the estimated means of the measurement at each sampling point in the original experiment. The values of the variables are standardised between -1 and 1.

### Schema for variable/column names
Again, each column represents the average of the values of each subsetted feature from the original data set. There exists a simple schema for interpreting the name of the feature columns in the dataset (i.e. names of columns other than subject, set and activity). The first letter denotes the domain: "t" for time domain and "f" for frequency domain. The next part denotes the component of the measured values: "Body" for the component of the measurement attributable to the motion of the subject and "Gravity" for the component of the measurement due to gravity. The third part denotes which device the measurement pertains to: "Acc" for accelerometer (which measures linear acceleration) and "Gyro" for gyroscope (which measures angular velocity). In the remaining parts, "X", "Y" and "Z" and refer to the component of the measurement in the x direction, y direction and z direction respectively, while "Mag" indicates we are talking about the magnitude of the measurement. "Jerk" refers to the time derivative of the acceleration.

### List of variables
1. subject
2. set
3. activity
4. tBodyAcc-mean()-X
5. tBodyAcc-mean()-Y
6. tBodyAcc-mean()-Z
7. tBodyAcc-std()-X
8. tBodyAcc-std()-Y
9. tBodyAcc-std()-Z
10. tGravityAcc-mean()-X
11. tGravityAcc-mean()-Y
12. tGravityAcc-mean()-Z
13. tGravityAcc-std()-X
14. tGravityAcc-std()-Y
15. tGravityAcc-std()-Z
16. tBodyAccJerk-mean()-X
17. tBodyAccJerk-mean()-Y
18. tBodyAccJerk-mean()-Z
19. tBodyAccJerk-std()-X
20. tBodyAccJerk-std()-Y
21. tBodyAccJerk-std()-Z
22. tBodyGyro-mean()-X
23. tBodyGyro-mean()-Y
24. tBodyGyro-mean()-Z
25. tBodyGyro-std()-X
26. tBodyGyro-std()-Y
27. tBodyGyro-std()-Z
28. tBodyGyroJerk-mean()-X
29. tBodyGyroJerk-mean()-Y
30. tBodyGyroJerk-mean()-Z
31. tBodyGyroJerk-std()-X
32. tBodyGyroJerk-std()-Y
33. tBodyGyroJerk-std()-Z
34. tBodyAccMag-mean()
35. tBodyAccMag-std()
36. tGravityAccMag-mean()
37. tGravityAccMag-std()
38. tBodyAccJerkMag-mean()
39. tBodyAccJerkMag-std()
40. tBodyGyroMag-mean()
41. tBodyGyroMag-std()
42. tBodyGyroJerkMag-mean()
43. tBodyGyroJerkMag-std()
44. fBodyAcc-mean()-X
45. fBodyAcc-mean()-Y
46. fBodyAcc-mean()-Z
47. fBodyAcc-std()-X
48. fBodyAcc-std()-Y
49. fBodyAcc-std()-Z
50. fBodyAccJerk-mean()-X
51. fBodyAccJerk-mean()-Y
52. fBodyAccJerk-mean()-Z
53. fBodyAccJerk-std()-X
54. fBodyAccJerk-std()-Y
55. fBodyAccJerk-std()-Z
56. fBodyGyro-mean()-X
57. fBodyGyro-mean()-Y
58. fBodyGyro-mean()-Z
59. fBodyGyro-std()-X
60. fBodyGyro-std()-Y
61. fBodyGyro-std()-Z
62. fBodyAccMag-mean()
63. fBodyAccMag-std()
64. fBodyBodyAccJerkMag-mean()
65. fBodyBodyAccJerkMag-std()
66. fBodyBodyGyroMag-mean()
67. fBodyBodyGyroMag-std()
68. fBodyBodyGyroJerkMag-mean()
69. fBodyBodyGyroJerkMag-std()

#### Notes on variables
Only the features from the original (raw) data set containing the exact strings "mean()" or "std()" were used in the creation of this data set. Equivalently, only the means and standard deviations of measurements were taken. Note that features containing exact strings such as "meanFreq()" were not taken since the assignment specified to only take the means and standard deviations of *each measurement*. The means of measurements containing both a mean and meanFreq by default is then only the mean and not the meanFreq.

## Sources
- Template for this codebook by Joris Schut: https://gist.github.com/JorisSchut/dbc1fc0402f28cad9b41
- Tidy data paper by Hadley Wickham: https://vita.had.co.nz/papers/tidy-data.pdf
