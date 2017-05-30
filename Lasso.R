### Lasso and Ridge regression code

set.seed(234)
# creating testing and training sets from training data
i.train <- sample(c(1:nrow(training)), nrow(training)*.7, replace=FALSE)

# taking out id and time variable, removing observations with NAs
test2 <- training[-i.train,-c(1,2,9)] 
train2 <- training[i.train,-c(1,2,9)]
train2 <- train2[complete.cases(train2),]
test2 <- test2[complete.cases(test2),]

length(unique(training$`Unit Type`))
length(unique(testing$`Unit Type`))
length(unique(training$`PPE Level`))
length(unique(testing$`PPE Level`))
length(unique(training$`First in District`))
length(unique(testing$`First in District`))

levels(testing$`Unit Type`) <- unique(training$`Unit Type`)
levels(testing$`PPE Level`) <- unique(training$`PPE Level`)

### Lasso
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

### Ridge, does worse than lasso code above
# library(glmnet)
# # mm2 <- model.matrix(elapsed_time ~., data=train2)
# mm2 = model.matrix(elapsed_time~., model.frame(~ ., train2, na.action=na.pass))
# cvlasso2 <- cv.glmnet(x=mm2, y=train2$elapsed_time, alpha=0)
# # mm3 <- model.matrix(elapsed_time ~., data=test2)
# mm3 = model.matrix(elapsed_time~., model.frame(~ ., test2, na.action=na.pass))
# 
# dim(mm2)
# dim(mm3)
# 
# best2=cvlasso2$lambda.min
# preds = predict(cvlasso2, newx= mm3, type="response", s=best2)
# cv.mse = mean((test2$elapsed_time - preds)^2)
# cv.mse




### making predictions using lasso model from the testing dataset


testing2 <- testing[,-c(1,2,9)]
# dim(testing2[complete.cases(testing2),])
# testing2 <- testing2[complete.cases(testing2),]
testing2$elapsed_time <- 0
# testing2 <- as.matrix(testing2)
# mmtest = model.matrix(elapsed_time~., model.frame(~ ., testing2, na.action=na.pass))
# dim(mmtest)

mm4 <- model.matrix(~., model.frame(~ ., testing2, na.action=na.pass))
preds <- predict(cvlasso2, newx = mm4, type="response", s=best2)


result <- cbind(testing$row.id, preds)
colnames(result) <- c("row.id", "prediction")

dim(result[complete.cases(result),])
result <- data.frame(result)
summary(result$prediction)

for(i in 1:length(result$prediction)){
  if(is.na(result$prediction[i])==TRUE){
    result$prediction[i] <- mean(result$prediction, na.rm = TRUE)
  }
}

sum(is.na(result$prediction)==TRUE)

# result[!complete.cases(result),] <- median(result$prediction, na.rm = TRUE)
summary(result$prediction)

write.csv(result, file = "C:/Users/Sydney/Desktop/lasso.csv")
