### Code for Principal Components Regression

## Other methods are more suitable for mixed data types than PCA

# practice.train <- sample(c(1:2317430), 2317430*.25, replace=FALSE)
# training2 <- training[practice.train,]

# i.train <- sample(c(1:nrow(training2)), nrow(training2)*.7, replace=FALSE)
i.train <- sample(c(1:nrow(training)), nrow(training)*.7, replace=FALSE)

test2 <- training[-i.train,-c(1,2,9)]
train2 <- training[i.train,-c(1,2,9)]

train2 <- train2[complete.cases(train2),]
test2 <- test2[complete.cases(test2),]

library(pls)

summary(train2)
train2 <- train2[,-c(4:6)]
test2 <- test2[,-c(4:6)]
summary(test2)

set.seed(123)
m.pca <- pcr(elapsed_time~.,data=train2, scale=TRUE, validation="CV")
summary(m.pca)

prediction2 <- predict(m.pca, newdata=test2, type="response")
mse.pca <- mean((prediction2-test2$elapsed_time)^2)
mse.pca

prediction2 <- predict(m.pca, newdata=testing2, type="response")

