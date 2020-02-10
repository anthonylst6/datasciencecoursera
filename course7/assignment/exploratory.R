# Load and explore data

data(mtcars)
str(mtcars)
head(mtcars)
?mtcars
library(car)
?vif
plot(mtcars$am, mtcars$mpg)
cor(mtcars)
# am has high correlation with drat, wt and gear: possible collinearity

# Fit multiple nested models then use anova to find relevant variables

fit1 <- lm(mpg ~ factor(am), data = mtcars)
fit2 <- lm(mpg ~ factor(am) + cyl, data = mtcars)
fit3 <- lm(mpg ~ factor(am) + cyl + disp, data = mtcars)
fit4 <- lm(mpg ~ factor(am) + cyl + disp + hp, data = mtcars)
fit5 <- lm(mpg ~ factor(am) + cyl + disp + hp + drat, data = mtcars)
fit6 <- lm(mpg ~ factor(am) + cyl + disp + hp + drat + wt, data = mtcars)
fit7 <- lm(mpg ~ factor(am) + cyl + disp + hp + drat + wt + qsec, data = mtcars)
fit8 <- lm(mpg ~ factor(am) + cyl + disp + hp + drat + wt + qsec + factor(vs), data = mtcars)
fit9 <- lm(mpg ~ factor(am) + cyl + disp + hp + drat + wt + qsec + factor(vs) + gear, data = mtcars)
fit10 <- lm(mpg ~ factor(am) + cyl + disp + hp + drat + wt + qsec + factor(vs) + gear + carb, data = mtcars)

anova(fit1, fit2, fit3, fit4, fit5, fit6, fit7, fit8, fit9, fit10)
# cyl, hp and wt are significant but possibly so is disp since it has high correlation with cyl, hp and wt 
# i.e. significance of cyl, hp and wt may be partially due to disp but attributed to these variables

# Test models which include some or all of cyl, wt, hp and disp

fit11 <- lm(mpg ~ factor(am) + cyl + wt, data = mtcars)
fit12 <- lm(mpg ~ factor(am) + cyl + wt + disp, data = mtcars)
fit13 <- lm(mpg ~ factor(am) + cyl + wt + hp, data = mtcars)
fit14 <- lm(mpg ~ factor(am) + cyl + wt + disp + hp, data = mtcars)

anova(fit11, fit12)
anova(fit11, fit13)
anova(fit11, fit14)

vif(fit11)
vif(fit12)
vif(fit13)
vif(fit14)

# fit11 wins: it seems only cyl, wt and hp are necessary to describe data

summary(fit11)
par(mfrow = c(2, 2))
plot(fit11)
confint(fit11)

# Test models that include cyl, wt and hp but also interaction terms

fit15 <- lm(mpg ~ factor(am) + cyl * wt, data = mtcars)
fit16 <- lm(mpg ~ factor(am) + cyl * wt + hp, data = mtcars)
fit17 <- lm(mpg ~ factor(am) + cyl + wt * hp, data = mtcars)
fit18 <- lm(mpg ~ factor(am) + cyl * hp + wt, data = mtcars)

anova(fit15, fit16)
anova(fit15, fit17)
anova(fit15, fit18)

vif(fit15)
vif(fit16)
vif(fit17)
vif(fit18)

# fit17 wins

anova(fit11, fit17)
# fit17 is an improvement from fit11
summary(fit17)
plot(fit17)
confint(fit17)
vif(fit17)

# Plot predicted values vs actual values

par(mfrow = c(1, 1))
?predict
plot(predict(fit17, mtcars[c('am', 'cyl', 'wt', 'hp')]), mtcars$mpg)
abline(a = 0, b = 1, col = 'red')

# Testing square roots, logs, polynomial terms

fit19 <- lm(sqrt(mpg) ~ factor(am) + cyl + wt * hp, data = mtcars)
fit20 <- lm(log(mpg) ~ factor(am) + cyl + wt * hp, data = mtcars)
summary(fit19)
summary(fit20)