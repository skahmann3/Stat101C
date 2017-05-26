### Code for Principal Components Regression


### PCR is too intensive for our large dataset

i.train <- sample(c(1:nrow(training), .7*nrow(training), replace = FALSE))
train2 <- training[i.train,]
test2 <- training[-i.train,]

library(pls)

set.seed(123)
m.pca <- pcr(elapsed_time~.,data=train2, scale=TRUE, validation="CV")
summary(m.pca)


### Lasso Regression is too intensive for our large dataset

library(glmnet)

mm2 <- model.matrix(elapsed_time ~., data=train2)
cvlasso2 <- cv.glmnet(x=mm2, y=train2$elapsed_time, alpha=1)

mm3 <- model.matrix(elapsed_time ~., data=test2)
preds = predict(cvlasso2, newx= mm3, type="response", s=best2)
cv.mse = mean((test2$elapsed_time - preds)^2)
cv.mse

