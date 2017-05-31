## XG Boost

# ## Practicing with 25% of the original training data
# practice.train <- sample(c(1:2317430), 2317430*.25, replace=FALSE)
# training2 <- training[practice.train,]

i.train <- sample(c(1:nrow(training)), nrow(training)*.75, replace=FALSE)

test2 <- training[-i.train,]
train2 <- training[i.train,]


### XG Boost doesn't use categorical variables, only numeric
### Need to convert our factors/categories to numbers


# removing the row.id, incident.id, incident creation time variable
test2 <- test2[,-c(1,2,6,7,8,9)]
train2 <- train2[,-c(1,2,6,7,8,9)]


### Now all variables are factors or numeric variables
# train2$`Dispatch Status` <- factor(train2$`Dispatch Status`)
# train2$`Unit Type` <- factor(train2$`Unit Type`)
# train2$`PPE Level` <- factor(train2$`PPE Level`)
# test2$`Dispatch Status` <- factor(test2$`Dispatch Status`)
# test2$`Unit Type` <- factor(test2$`Unit Type`)
# test2$`PPE Level` <- factor(test2$`PPE Level`)

###  taking out spaces in variable names 
# colnames(train2) <- c("year", "First_in_District", 
#                       "Dispatch_Sequence", "Dispatch_Status", 
#                       "Unit_Type", "PPE_Level", "elapsed_time")
# colnames(test2) <- c("year", "First_in_District", 
#                       "Dispatch_Sequence", "Dispatch_Status", 
#                       "Unit_Type", "PPE_Level", "elapsed_time")


### Building the model

library(xgboost)

train2 <- as.data.frame(apply(train2, 2, as.numeric))
test2 <- as.data.frame(apply(test2, 2, as.numeric))


xg = xgboost(data=data.matrix(train2[,1:3]), label=data.matrix(train2[,4]), nrounds = 500, early_stopping_rounds = 20, eta=.1)
preds.xgb=predict(xg, newdata=data.matrix(test2[,1:3]))
mse.xgb=mean((preds.xgb-test2[,4])^2)
mse.xgb


testing2 <- testing[,-c(1,2,6,7,8,9)]
testing2 <- as.data.frame(apply(testing2, 2, as.numeric))

preds.xgb=predict(xg, newdata=data.matrix(testing2[,1:3]))

result <- cbind(testing$row.id, preds.xgb)
colnames(result) <- c("row.id", "prediction")
write.csv(result, file = "C:/Users/Sydney/Desktop/xgboost.csv")

