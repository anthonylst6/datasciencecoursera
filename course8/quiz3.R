# Set RNG version

RNGversion("3.0.0")

# Question 1

library(AppliedPredictiveModeling)
data(segmentationOriginal)
library(caret)

str(segmentationOriginal)
train <- subset(segmentationOriginal, Case = "Train")
test <- subset(segmentationOriginal, Case = "Test")
set.seed(125)
model1 <- train(Class ~ ., method = "rpart", data = train)
library(rattle)
fancyRpartPlot(model1$finalModel)

# Question 3

library(pgmm)
data(olive)
olive = olive[,-1]

str(olive)
model2 <- train(Area ~ ., method = "rpart", data = olive)
predict(model2, newdata = as.data.frame(t(colMeans(olive))))

# Question 4

url <- "https://cran.r-project.org/src/contrib/Archive/ElemStatLearn/ElemStatLearn_2015.6.26.tar.gz"
pkgFile <- "ElemStatLearn_2015.6.26.tar.gz"
download.file(url = url, destfile = pkgFile)
install.packages(pkgs=pkgFile, type="source", repos=NULL)
library(ElemStatLearn)
unlink(pkgFile)

data(SAheart)
set.seed(8484)
train = sample(1:dim(SAheart)[1],size=dim(SAheart)[1]/2,replace=F)
trainSA = SAheart[train,]
testSA = SAheart[-train,]
set.seed(13234)

str(trainSA)
model3 <- train(chd ~ age + alcohol + obesity + tobacco + typea + ldl, method = "glm", family = "binomial", data = trainSA)
missClass = function(values,prediction){sum(((prediction > 0.5)*1) != values)/length(values)}
missClass(trainSA$chd, as.numeric(predict(model3, newdata = trainSA)))
missClass(testSA$chd, as.numeric(predict(model3, newdata = testSA)))

# Question 5

data(vowel.train)
data(vowel.test)

str(vowel.train)
vowel.train$y <- as.factor(vowel.train$y)
vowel.test$y <- as.factor(vowel.test$y)
set.seed(33833)
model4 <- train(y ~ ., method = "rf", data = vowel.train)
varImp(model4)