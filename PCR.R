### Code for Principal Components Regression


### PCR is too intensive for laptop

i.train <- sample(c(1:nrow(training), .7*nrow(training), replace = FALSE))
train2 <- training[i.train,]
test2 <- training[-i.train,]

library(pls)

set.seed(123)
m.pca <- pcr(elapsed_time~.,data=train2, scale=TRUE, validation="CV")
summary(m.pca)


