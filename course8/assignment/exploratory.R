# Download training and testing sets
if(!file.exists("pml-training.csv")) {
        fileURL <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
        download.file(fileURL, destfile = "pml-training.csv")
}
if(!file.exists("pml-testing.csv")) {
        fileURL <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"
        download.file(fileURL, destfile = "pml-testing.csv")
}

# Load libraries and data
library(caret)
library(parallel)
library(doParallel)
training <- read.csv("pml-training.csv")
testing <- read.csv("pml-testing.csv")

# Exploratory data analysis
dim(training)
str(training)

# Clean data
nonNA <- !is.na(training[1, ]) # indexing columns with NAs
training <- training[, nonNA] # remove columns with NAs
nonEmpty <- !training[1, ] == "" # indexing columns with empty values
training <- training[, nonEmpty] # remove columns with empty values
training <- subset(training, select = -(1:7)) # remove columns irrelevant for prediction
testing <- testing[, nonNA] # remove columns with NAs
testing <- testing[, nonEmpty] # remove columns with empty values
testing <- subset(testing, select = -(1:7)) # remove columns irrelevant for prediction
dim(training) # check dimensions of cleaned dataset

# (A) Train-test-(validation) split of data

## (A.1) Further divide up training set into train and test sets
set.seed(1)
inTrain <- createDataPartition(training$classe, p = 0.7, list = FALSE)
train <- training[inTrain, ]
test <- training[-inTrain, ]

## (A.2) Further divide up training set into train, test and validation sets
# set.seed(1)
# inTrain <- createDataPartition(training$classe, p = 0.6, list = FALSE)
# train <- training[inTrain, ]
# nonTrain <- training[-inTrain, ]
# inTest <- createDataPartition(nonTrain, p = 0.5, list = FALSE)
# test <- nonTrain[inTest, ]
# valid <- nonTrain[-inTest, ]

# Standardise values
standardObj <- preProcess(train[, -53], method = c("center", "scale"))
train[, 1:52] <- predict(standardObj, train[, -53])
test[, 1:52] <- predict(standardObj, test[, -53])
# valid[, 1:52] <- predict(standardObj, valid[, -53])
testing[, 1:52] <- predict(standardObj, testing[, -53])

# Find number of pairs of highly correlated predictors
# M <- abs(cor(train[, -53]))
# diag(M) <- 0
# M[upper.tri(M)] <- 0
# dim_redundant <- nrow(which(M > 0.9, arr.ind=T))

# Perform principal component transformation
# pcaObj <- preProcess(train[, -53], method = "pca", pcaComp = 52 - dim_redundant)
# trainPC <- cbind(predict(pcaObj, train[, -53]), classe = train$classe)
# testPC <- cbind(predict(pcaObj, test[, -53]), classe = test$classe)
# # validPC <- cbind(predict(pcaObj, valid[, -53]), classe = valid$classe)
# testingPC <- cbind(predict(pcaObj, testing[, -53]), problem_id = testing$problem_id)

# Configure parallel processing
cluster <- makeCluster(detectCores() - 1)
registerDoParallel(cluster)

# (C) Model selection
fitControl <- trainControl(method = "cv", number = 5, allowParallel = TRUE)

## (C.1) Linear discriminant analysis
# lda <- train(classe ~ ., method = "lda", data = train, trControl = fitControl)
# pred_lda <- predict(lda, test)
# confusionMatrix(pred_lda, test$classe)
# predict(lda, testing)

## (C.2) Decision tree
# tree <- train(classe ~ ., method = "rpart", data = train, trControl = fitControl)
# pred_tree <- predict(tree, test)
# confusionMatrix(pred_tree, test$classe)
# predict(tree, testing)

## (C.3) K nearest neighbours
# knn <- train(classe ~ ., method = "knn", data = train, trControl = fitControl)
# pred_knn <- predict(knn, test)
# confusionMatrix(pred_knn, test$classe)
# predict(knn, testing)

## (C.4) Support vector machine
# svm <- train(classe ~ ., method = "svmLinear", data = train, trControl = fitControl)
# pred_svm <- predict(svm, test)
# confusionMatrix(pred_svm, test$classe)
# predict(svm, testing)

## (C.5) Gradient boosting machine
# gbm <- train(classe ~ ., method = "gbm", data = train, verbose = FALSE, trControl = fitControl)
# pred_gbm <- predict(gbm, test)
# confusionMatrix(pred_gbm, test$classe)
# predict(gbm, testing)

## (C.6) Random forest
rf <- train(classe ~ ., method = "rf", data = train, trControl = fitControl)
pred_rf <- predict(rf, test)
confusionMatrix(pred_rf, test$classe)
predict(rf, testing)

## (C.1.1) Linear discriminant analysis using principal components
# ldaPC <- train(classe ~ ., method = "lda", data = trainPC, trControl = fitControl)
# pred_ldaPC <- predict(ldaPC, testPC)
# confusionMatrix(pred_ldaPC, testPC$classe)
# predict(ldaPC, testingPC)

## (C.2.1) Decision tree using principal components
# treePC <- train(classe ~ ., method = "rpart", data = trainPC, trControl = fitControl)
# pred_treePC <- predict(treePC, testPC)
# confusionMatrix(pred_treePC, testPC$classe)
# predict(treePC, testingPC)

## (C.3.1) K nearest neighbours using principal components
# knnPC <- train(classe ~ ., method = "knn", data = trainPC, trControl = fitControl)
# pred_knnPC <- predict(knnPC, testPC)
# confusionMatrix(pred_knnPC, testPC$classe)
# predict(knnPC, testing)

## (C.4.1) Support vector machine using principal components
# svmPC <- train(classe ~ ., method = "svmLinear", data = trainPC, trControl = fitControl)
# pred_svmPC <- predict(svmPC, testPC)
# confusionMatrix(pred_svmPC, testPC$classe)
# predict(svmPC, testing)

## (C.5.1) Gradient boosting machine using principal components
# gbmPC <- train(classe ~ ., method = "gbm", data = trainPC, verbose = FALSE, trControl = fitControl)
# pred_gbmPC <- predict(gbmPC, testPC)
# confusionMatrix(pred_gbmPC, testPC$classe)
# predict(gbmPC, testing)

## (C.6.1) Random forest using principal components
# rfPC <- train(classe ~ ., method = "rf", data = trainPC, trControl = fitControl)
# pred_rfPC <- predict(rfPC, testPC)
# confusionMatrix(pred_rfPC, testPC$classe)
# predict(rfPC, testing)

# De-register parallel processing cluster
stopCluster(cluster)
registerDoSEQ()