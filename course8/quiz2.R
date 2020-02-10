# Set RNG version

RNGversion("3.0.0")

# Question 2

training$cement <- cut2(training$Cement, g = 5)
training$blast <- cut2(training$BlastFurnaceSlag, g = 5)
training$fly <- cut2(training$FlyAsh, g = 5)
training$water <- cut2(training$Water, g = 5)
training$super <- cut2(training$Superplasticizer, g = 5)
training$coarse <- cut2(training$CoarseAggregate, g = 5)
training$fine <- cut2(training$FineAggregate, g = 5)
training$age <- cut2(training$Age, g = 5)

qplot(inTrain, CompressiveStrength, col = cement, data = training)
qplot(inTrain, CompressiveStrength, col = blast, data = training)
qplot(inTrain, CompressiveStrength, col = fly, data = training)
qplot(inTrain, CompressiveStrength, col = water, data = training)
qplot(inTrain, CompressiveStrength, col = super, data = training)
qplot(inTrain, CompressiveStrength, col = coarse, data = training)
qplot(inTrain, CompressiveStrength, col = fine, data = training)
qplot(inTrain, CompressiveStrength, col = age, data = training)

# Question 3

hist(training$Superplasticizer)

# Question 4 and 5

index <- grep("^IL", names(training))
preProc <- preProcess(training[, index], method = "pca", pcaComp = 12)
trainPC <- predict(preProc, training[, index])

vars <- apply(trainPC, 2, var)
x <- vars/sum(vars)
sum(x[1:7])

data1 <- trainPC[, 1:7]
data1$diagnosis <- training[, 1]
model1 <- train(diagnosis ~ ., method = "glm", data = data1)
testPC <- predict(preProc, testing[, index])
confusionMatrix(testing$diagnosis, predict(model1, testPC[1:7]))

data2 <- training[, c(index, 1)]
model2 <- train(diagnosis ~ ., method = "glm", data = data2)
confusionMatrix(testing$diagnosis, predict(model2, testing[, index]))