## XG Boost

### Practicing with 25% of the original training data

practice.train <- sample(c(1:2317430), 2317430*.25, replace=FALSE)
training2 <- training[practice.train,]

i.train <- sample(c(1:579357), 579357*.75, replace=FALSE)

test2 <- training2[-i.train,]
train2 <- training2[i.train,]


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

#using one hot encoding 



labels <- train2$elapsed_time 
ts_label <- test2$elapsed_time

# new_tr <- matrix(train2)
# new_ts <- matrix(test2)

# new_tr <- model.matrix(~.+0,data = train2[,-8]) 
# new_ts <- model.matrix(~.+0,data = test2[,-8])

str(train2)
train2 <- as.data.frame(train2)

#preparing matrix 
new_tr[] <- lapply(train2, as.numeric)
xgb.DMatrix(data=data.matrix(new_tr))

dtrain <- xgb.DMatrix(data = new_tr,label = labels) 
dtest <- xgb.DMatrix(data = new_ts,label=ts_label)


library(Matrix)
sparse_matrix <- sparse.model.matrix(elapsed_time~.-1, data = train2)

head(sparse_matrix)

response = train2$elapsed_time


### Building the model

library(xgboost)

bst <- xgboost(data = sparse_matrix, label = response, max.depth = 4,
               eta = 1, nthread = 2, nround = 10, objective = "reg:linear")
