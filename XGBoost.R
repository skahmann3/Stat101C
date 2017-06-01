## XG Boost

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

output_vector = train2[,"elapsed_time"]
train2 <- train2[,-7] # taking out elapsed time

### Make sure you switch back these global options commands below
previous_na_action <- options('na.action')
options(na.action='na.pass')

library(Matrix)
sparse_matrix <- sparse.model.matrix(~.-1, data = train2)

### Switch back here! (or will screw up rest of code)
options(na.action=previous_na_action$na.action)


xg = xgboost(data=sparse_matrix, label=output_vector, 
             nrounds = 50, early_stopping_rounds = 20, eta=.1)


### If want to implement feature selection, try out commands here:
# https://cran.r-project.org/web/packages/xgboost/vignettes/discoverYourData.html

test_elapsed = test2[,"elapsed_time"]
test2 <- test2[,-7] # taking out elapsed time


previous_na_action <- options('na.action')
options(na.action='na.pass')

sparse_test <- sparse.model.matrix(~.-1, data = test2)

### Switch back here! (or will screw up rest of code)
options(na.action=previous_na_action$na.action)


preds.xgb=predict(xg, newdata=sparse_test)
mse.xgb=mean((preds.xgb-test_elapsed)^2)
mse.xgb ## training MSE


### Making predictions for submission


previous_na_action <- options('na.action')
options(na.action='na.pass')

sparse_test <- sparse.model.matrix(~.-1, data = testing2)

### Switch back here! (or will screw up rest of code)
options(na.action=previous_na_action$na.action)


## The prediction column
preds.xgb=predict(xg, newdata=sparse_test)

## Create the csv for submission
## I then delete out the extra row number variable and save the columns in
########## number format in Excel
result <- cbind(testing$row.id, preds.xgb)
colnames(result) <- c("row.id", "prediction")
write.csv(result, file = "C:/Users/Sydney/Desktop/xgboost.csv")
