# Lattice Plotting System (part 1)

library(lattice)
library(datasets)
xyplot(Ozone ~ Wind, data = airquality)

library(datasets)
library(lattice)
airquality <- transform(airquality, Month = factor(Month))
xyplot(Ozone ~ Wind | Month, data = airquality, layout = c (5, 1))

p <- xyplot(Ozone ~ Wind, data = airquality)
print(p)


# Lattice Plotting System (part 2)

set.seed(10)
x <- rnorm(100)
f <- rep(0:1, each = 50)
y <- x + f - f * x + rnorm(100, sd = 0.5)
f <- factor(f, labels = c("Group 1", "Group 2"))
xyplot(y ~ x | f, layout = c(2, 1))

xyplot(y ~ x | f, panel = function(x, y, ...) {
        panel.xyplot(x, y, ...)
        panel.abline(h = median(y), lty = 2)
})
xyplot(y ~ x | f, layout = c(2, 1), panel = function(x, y, ...) {
        panel.xyplot(x, y, ...)
        panel.lmline(x, y, col = 2)
})


# ggplot2 (part 1)


# ggplot2 (part 2)

library(ggplot2)
str(mpg)
qplot(displ, hwy, data = mpg)
qplot(displ, hwy, data = mpg, color = drv)
qplot(displ, hwy, data = mpg, geom = c("point", "smooth"))
qplot(hwy, data = mpg, fill = drv)
qplot(displ, hwy, data = mpg, facets = .~drv)
qplot(hwy, data = mpg, facets = drv~., binwidth = 2)

download.file("https://github.com/lupok2001/datasciencecoursera/raw/master/maacs.Rda", "./data/maacs.rda", mode = "wb")
load(file = "./data/maacs.rda")
str(maacs)
qplot(log(eno), data = maacs)
qplot(log(eno), data = maacs, fill = mopos)
qplot(log(eno), data = maacs, geom = "density")
qplot(log(eno), data = maacs, geom = "density", color = mopos)
qplot(log(pm25), log(eno), data = maacs)
qplot(log(pm25), log(eno), data = maacs, shape = mopos)
qplot(log(pm25), log(eno), data = maacs, color = mopos)
qplot(log(pm25), log(eno), data = maacs, color = mopos) + geom_smooth(method = "lm")
qplot(log(pm25), log(eno), data = maacs, facets = .~mopos) + geom_smooth(method = "lm")


# ggplot2 (part 3)

qplot(logpm25, NocturnalSympt, data = maacs, facets = .~bmicat, geom = c("point", "smooth"), method = "lm")
head(maacs[, 6:8])
g <- ggplot(maacs, aes(logpm25, NocturnalSympt))
summary(g)
print(g)
p <- g + geom_point()
print(p)
g + geom_point()


# ggplot2 (part 4)

g + geom_point() + geom_smooth()
g + geom_point() + geom_smooth(method = "lm")
g + geom_point() + facet_grid(.~bmicat) + geom_smooth(method = "lm")
g + geom_point(color = "steelblue", size = 4, alpha = 1/2)
g + geom_point(aes(color = bmicat), size = 4, alpha = 1/2)
g + geom_point(aes(color = bmicat)) + labs(title = "MAACS Cohort") + labs(x = expression("log " * PM[2.5]), y = "Nocturnal Symptoms")
g + geom_point(aes(color = bmicat), size = 2, alpha = 1/2) + geom_smooth(size = 4, linetype = 3, method = "lm", se = FALSE)
g + geom_point(aes(color = bmicat)) + theme_bw(base_family = "Times")


# ggplot2 (part 5)

testdat <- data.frame(x = 1:100, y = rnorm(100))
testdat[50, 2] <- 100
plot(testdat$x, testdat$y, type = "l", ylim = c(-3, 3))
g <- ggplot(testdat, aes(x = x, y = y))
g + geom_line()
g + geom_line() + ylim(-3, 3)
g + geom_line() + coord_cartesian(ylim = c(-3, 3))
cutpoints <- quantile(maacs$logno2_new, seq(0, 1, length = 4), na.rm = TRUE)
maacs$no2dec <- cut(maacs$logno2_new, cutpoints)
levels(maacs$no2dec)

g <- ggplot(maacs, aes(logpm25, NocturnalSympt))
g + geom_point(alpha = 1/3) + facet_wrap(bmicat ~ no2dec, nrow = 2, ncol = 4) + geom_smooth(method = "lm", se = FALSE, col = "steelblue") + theme_bw(base_family = "Avenir", base_size = 10) + labs(x = expression("log " * PM[2.5])) + labs(y = "Nocturnal Symptoms") + labs(title = "MAACS Cohort")