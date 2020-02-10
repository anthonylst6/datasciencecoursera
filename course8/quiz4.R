# Set RNG version

RNGversion("3.0.0")

# Question 1

library(ElemStatLearn)
data(vowel.train)
data(vowel.test)

vowel.train$y <- as.factor(vowel.train$y)
vowel.test$y <- as.factor(vowel.test$y)
set.seed(33833)
library(caret)
model1 <- train(y ~ ., method = "rf", data = vowel.train)
model2 <- train(y ~ ., method = "gbm", data = vowel.train, verbose = FALSE)
predict1 <- predict(model1, vowel.test)
predict2 <- predict(model2, vowel.test)
mean(predict1 == vowel.test$y)
mean(predict2 == vowel.test$y)
mean(predict1[predict1 == predict2] == vowel.test$y[predict1 == predict2])

# Question 2

library(caret)
library(gbm)
set.seed(3433)
library(AppliedPredictiveModeling)
data(AlzheimerDisease)
adData = data.frame(diagnosis,predictors)
inTrain = createDataPartition(adData$diagnosis, p = 3/4)[[1]]
training = adData[ inTrain,]
testing = adData[-inTrain,]

set.seed(62433)
model3 <- train(diagnosis ~ ., method = "rf", data = training)
model4 <- train(diagnosis ~ ., method = "gbm", data = training, verbose = FALSE)
model5 <- train(diagnosis ~ ., method = "lda", data = training)
predict3 <- predict(model3, testing)
predict4 <- predict(model4, testing)
predict5 <- predict(model5, testing)
predDF <- data.frame(predict3, predict4, predict5, diagnosis = testing$diagnosis)
model6 <- train(diagnosis ~ ., method = "rf", data = predDF)
predict6 <- predict(model6, testing)
mean(predict3 == testing$diagnosis)
mean(predict4 == testing$diagnosis)
mean(predict5 == testing$diagnosis)
mean(predict6 == testing$diagnosis)

# Question 3

set.seed(3523)
library(AppliedPredictiveModeling)
data(concrete)
inTrain = createDataPartition(concrete$CompressiveStrength, p = 3/4)[[1]]
training = concrete[ inTrain,]
testing = concrete[-inTrain,]

set.seed(233)
model7 <- train(CompressiveStrength ~ ., method = "lasso", data = training)
plot(model7$finalModel, xvar = "penalty", use.color = T)

# Question 4

if(!file.exists("gaData.csv")) {
        fileURL <- "https://d396qusza40orc.cloudfront.net/predmachlearn/gaData.csv"
        download.file(fileURL, destfile = "gaData.csv")
}

library(lubridate) # For year() function below
dat = read.csv("gaData.csv")
training = dat[year(dat$date) < 2012,]
testing = dat[(year(dat$date)) > 2011,]
tstrain = ts(training$visitsTumblr)

library(forecast)
model8 <- bats(tstrain)
fcast <- forecast(tstrain, model = model8, h = 235)
mean(testing$visitsTumblr > fcast$lower[, 2] & testing$visitsTumblr < fcast$upper[, 2])

# Question 5

set.seed(3523)
library(AppliedPredictiveModeling)
data(concrete)
inTrain = createDataPartition(concrete$CompressiveStrength, p = 3/4)[[1]]
training = concrete[ inTrain,]
testing = concrete[-inTrain,]

set.seed(325)
library(e1071)
model9 <- svm(CompressiveStrength ~ ., data = training)
RMSE <- function(y, yhat) sqrt(mean((y - yhat)^2))
RMSE(testing$CompressiveStrength, predict(model9, newdata = testing))