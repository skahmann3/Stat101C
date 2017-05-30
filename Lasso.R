### Lasso

# practice.train <- sample(c(1:2317430), 2317430*.25, replace=FALSE)
# training2 <- training[practice.train,]

# i.train <- sample(c(1:nrow(training2)), nrow(training2)*.7, replace=FALSE)
i.train <- sample(c(1:nrow(training)), nrow(training)*.7, replace=FALSE)


test2 <- training[-i.train,-c(1,2,9)]
train2 <- training[i.train,-c(1,2,9)]


# practice.train <- sample(c(1:2317430), 2317430*.001, replace=FALSE)
# training2 <- training[practice.train,]
# i.train <- sample(c(1:nrow(training2)), nrow(training2)*.5, replace=FALSE)
# test2 <- training2[-i.train,]
# train2 <- training2[i.train,]

train2 <- train2[complete.cases(train2),]
test2 <- test2[complete.cases(test2),]

library(glmnet)
# mm2 <- model.matrix(elapsed_time ~., data=train2)
mm2 = model.matrix(elapsed_time~., model.frame(~ ., train2, na.action=na.pass))
cvlasso2 <- cv.glmnet(x=mm2, y=train2$elapsed_time, alpha=1)

# mm3 <- model.matrix(elapsed_time ~., data=test2)
mm3 = model.matrix(elapsed_time~., model.frame(~ ., test2, na.action=na.pass))

dim(mm2)
dim(mm3)

best2=cvlasso2$lambda.min
preds = predict(cvlasso2, newx= mm3, type="response", s=best2)
cv.mse = mean((test2$elapsed_time - preds)^2)
cv.mse

predict(cvlasso2, newx= mm3, type="coefficient", s=best2)
