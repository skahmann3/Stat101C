### All data manipulation

### Maybe should make district a factor?

### Training
load("C:/Users/Sydney/Desktop/training.RData")

library(lubridate)
training$`Incident Creation Time (GMT)` <- 
  hms(training$`Incident Creation Time (GMT)`)

training$hour <- hour(training$`Incident Creation Time (GMT)`)
training$min <- minute(training$`Incident Creation Time (GMT)`)
training$second <- second(training$`Incident Creation Time (GMT)`)

# Model did way worse with these variables (like 18 million worse for the MSE!)
# so, maybe the correlation between the variables is a problem?
# or, maybe the incident.ids got scrambled somehow?
# library(dplyr) 
# training <- training %>% group_by(incident.ID) %>% mutate(NumUnits = n(), MaxDispatch = max(`Dispatch Sequence`))

# removing the row.id, incident.id, time
training2 <- training[,-c(1,2, 9)]

### One hot encoding -- converting the categoricals to numerical variables

###  taking out spaces in variable names 
colnames(training2) <- c("year", "First_in_District",
                      "Dispatch_Sequence", "Dispatch_Status",
                      "Unit_Type", "PPE_Level", 
                      "elapsed_time", "hour", "min", "second")

training2[,c("Dispatch_Status", "Unit_Type", "PPE_Level")] <- as.data.frame(apply(training2[,c("Dispatch_Status", "Unit_Type", "PPE_Level")], 2, as.factor))



### Now all variables are factors 

##### CODE FOR MODEL USING NO CATEGORICAL FACTORS
## Everything must be "numeric", "integer" doesn't work
# train2 <- as.data.frame(apply(train2, 2, as.numeric))

### Testing
load("C:/Users/Sydney/Desktop/testing.RData")

testing$`Incident Creation Time (GMT)` <- 
  hms(testing$`Incident Creation Time (GMT)`)

testing$hour <- hour(testing$`Incident Creation Time (GMT)`)
testing$min <- minute(testing$`Incident Creation Time (GMT)`)
testing$second <- second(testing$`Incident Creation Time (GMT)`)

# Model did worse with these variables
# testing <- testing %>% group_by(incident.ID) %>% mutate(NumUnits = n(), MaxDispatch = max(`Dispatch Sequence`))

# removing the row.id, incident.id, time
testing2 <- testing[,-c(1,2, 9)]

colnames(testing2) <- c("year", "First_in_District",
                         "Dispatch_Sequence", "Dispatch_Status",
                         "Unit_Type", "PPE_Level", 
                         "hour", "min", "second")

testing2[,c("Dispatch_Status", "Unit_Type", "PPE_Level")] <- as.data.frame(apply(testing2[,c("Dispatch_Status", "Unit_Type", "PPE_Level")], 2, as.factor))




### External Data

library(readr)
FireStations <- read_csv("C:/Users/Sydney/Downloads/FireStations.csv")

length(table(FireStations$FS_CD)) ### 106 stations
length(table(training$`First in District`)) ### 102 stations

## Our data doesn't include Stations	80	(LAX),	110	(Boat	5), 111	(Boat	1)	&	114	(Air	Operations)

test2 <- as.data.frame(apply(test2, 2, as.numeric))


