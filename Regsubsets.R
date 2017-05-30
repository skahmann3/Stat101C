### Best Subsets


### Loaded training and testing RData files generated in the RMD file

practice.train <- sample(c(1:2317430), 2317430*.5, replace=FALSE)
training2 <- training[practice.train,]

# i.train <- sample(c(1:nrow(training2)), nrow(training2)*.7, replace=FALSE)
i.train <- sample(c(1:nrow(training)), nrow(training)*.7, replace=FALSE)


test2 <- training2[-i.train,-c(1,2,9)]
train2 <- training2[i.train,-c(1,2,9)]

library(leaps)
all <- regsubsets(elapsed_time ~ ., data=train2, method="forward", nvmax=8)
allsum <- summary(all)

plot(allsum$cp) 
lines(allsum$cp)


## picking 4 variables using BIC regsubsets

predict.regsubsets=function(object, newdata, id,...){
  form=as.formula(object$call[[2]])
  mat = model.matrix(form, model.frame(~ ., newdata, na.action=na.pass))
  # mat=model.matrix(form, newdata)
  coefi=coef(object, id=id)
  mat[, names(coefi)]%*%coefi
}

pred <- predict.regsubsets(all, newdata= test2, id=4)
CP_MSE = mean((test2$elapsed_time - pred)^2, na.rm = TRUE)
CP_MSE


testing2 <- testing[,-c(1,2,9)]
testing2$elapsed_time <- NA
pred <- predict.regsubsets(all, newdata= testing2, id=4)

result <- cbind(testing$row.id, pred)
colnames(result) <- c("row.id", "prediction")

dim(result[complete.cases(result),])
result <- data.frame(result)
summary(result$prediction)

for(i in 1:length(result$prediction)){
  if(is.na(result$prediction[i])==TRUE){
    result$prediction[i] <- median(result$prediction, na.rm = TRUE)
  }
}
sum(is.na(result$prediction)==TRUE)

# result[!complete.cases(result),] <- median(result$prediction, na.rm = TRUE)
summary(result$prediction)

write.csv(result, file = "C:/Users/Sydney/Desktop/regsubsets.csv")



