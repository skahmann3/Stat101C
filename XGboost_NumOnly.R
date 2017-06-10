## XG Boost Numerical Variables Only

## Load data like in DataManipulation.R

###### Use this code to practice with 25% of the original training data
# practice.train <- sample(c(1:2317430), 2317430*.25, replace=FALSE)
# training2 <- training[practice.train,]

i.train <- sample(c(1:nrow(training2)), nrow(training2)*.75, replace=FALSE)

test2 <- training2[-i.train,]
train2 <- training2[i.train,]


### XG Boost doesn't use categorical variables, only numeric
### Need to convert our factors/categories to numbers



### Building the model

library(xgboost)

### If want to implement feature selection, try out commands here:
# https://cran.r-project.org/web/packages/xgboost/vignettes/discoverYourData.html

# selecting numeric variables only
# train2 <- train2[,c(1:3,7:10)]
# test2 <- test2[,c(1:3,7:10)]


## Everything must be "numeric", "integer" doesn't work
train2 <- as.data.frame(apply(train2, 2, as.numeric))
test2 <- as.data.frame(apply(test2, 2, as.numeric))

################## CODE FOR NUMERIC VARIABLES ONLY
## Making the model, switch out the column numbers when more variables are added
## Data = should point to all variables but the elapsed time variable
## Label = should point to the elapsed time variable
xg = xgboost(data=data.matrix(train2[,c(1:5,7:9)]), label=data.matrix(train2[,6]),
             nrounds = 100, early_stopping_rounds = 20, eta=.1)
preds.xgb=predict(xg, newdata=data.matrix(test2[,c(1:5,7:9)]))
mse.xgb=mean((preds.xgb-test2[,6])^2)
mse.xgb ## training MSE


### Making predictions for submission using all data to train

# train2 <- training2[,c(1:3,7:10)]
# train2 <- as.data.frame(apply(train2, 2, as.numeric))

xg = xgboost(data=data.matrix(training2[,c(1:6,8:10)]), label=data.matrix(training2[,7]),
             nrounds = 100, early_stopping_rounds = 20, eta=.1)
# XG boost. Variables: Year, incident count, avg.travel, avg.turnout, dispatch seq, hour, min, seconds to predict elapsed_time from dataset added. nrounds = 500.

## no incident count var
xg2 = xgboost(data=data.matrix(training2[,c(1,3:5,7:9)]), label=data.matrix(training2[,6]),
             nrounds = 200, early_stopping_rounds = 20, eta=.1)
# XG boost. Variables: Year, avg.travel, avg.turnout, dispatch seq, hour, min, seconds to predict elapsed_time from dataset na_added. nrounds = 500.






test2 <- testing2[,c(1:3,7:9)]
test2 <- as.data.frame(apply(test2, 2, as.numeric))

preds.xgb=predict(xg, newdata=data.matrix(testing2))

## no incident count var
preds.xgb2=predict(xg2, newdata=data.matrix(testing2[,-2]))


## Create the csv for submission
## I then delete out the extra row number variable and save the columns in
########## number format in Excel
result <- cbind(row.names(testing2), preds.xgb)
colnames(result) <- c("row.id", "prediction")
write.csv(result, file = "C:/Users/Sydney/Desktop/xgboost.csv")

result2 <- cbind(row.names(testing2), preds.xgb2)
colnames(result2) <- c("row.id", "prediction")
write.csv(result2, file = "C:/Users/Sydney/Desktop/xgboost2.csv")
