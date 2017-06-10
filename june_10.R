training1 <- train_na_in_dispatch_Unit_cats

set.seed(456)
training1 <- as.data.frame(apply(training1[,c(1:5,7,10,12:29)], 2, as.numeric))
i.train <- sample(c(1:nrow(training1)), nrow(training1)*.75, replace=FALSE)
test2 <- training1[-i.train,]
train2 <- training1[i.train,]

library(xgboost)

################## CODE FOR NUMERIC VARIABLES ONLY
## Making the model, switch out the column numbers when more variables are added
## Data = should point to all variables but the elapsed time variable
## Label = should point to the elapsed time variable

set.seed(123)
xg = xgboost(data=data.matrix(train2[,c(1:7,9:25)]), label=data.matrix(train2[,8]),
             nrounds = 150, early_stopping_rounds = 20, eta=.1)
preds.xgb=predict(xg, newdata=data.matrix(testing2)
mse.xgb=mean((preds.xgb-test2[,8])^2)
mse.xgb ## training MSE

table(train_na_in_dispatch_Unit_cats$Unit.Type)
testing2 <- as.data.frame(apply(testing2, 2, as.numeric))

training1[,c(1,2,7,14:16,19,4,10,12)] <- as.data.frame(apply(training1[,c(1,2,7,14:16,19,4,10,12)], 2, as.numeric))


xg = xgboost(data=data.matrix(training1[,c(1,2,7,14:16,19,4,10)]), label=data.matrix(training1[,12]),
             nrounds = 100, early_stopping_rounds = 20, eta=.1)

testing1 <- testing1 %>%  mutate(total.time = hour*3600 + min*60 + second)
testing1$PPE.Level <- recode(testing1$PPE.Level, "EMS" = 1, "Non-EMS" = 0)
table(testing1$PPE.Level)

testin1_ugly_name_for_sydney[,c(1:5,7:10,12:26)] <- as.data.frame(apply(testin1_ugly_name_for_sydney[,c(1:5,7:10,12:26)], 2, as.numeric))
preds.xgb=predict(xg, newdata=data.matrix(testing1[,c(1,2,7,12:14,17,4,10)]))

result <- cbind(testing1$row.id, preds.xgb)
colnames(result) <- c("row.id", "prediction")
write.csv(result, file = "C:/Users/Sydney/Desktop/xgboost_best_ppe_ttime_travel.csv")


# Compute feature importance matrix
importance_matrix <- xgb.importance(names(train2[,c(1:7,9:25)]), model = xg)
# Nice graph
xgb.plot.importance(importance_matrix)
