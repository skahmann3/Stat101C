### All data manipulation

### Maybe should make district a factor?

### Training
# load("C:/Users/Sydney/Desktop/training.RData")

library(readr)
train_added <- read_csv("C:/Users/Sydney/Google Drive/101_Kaggle/train.NA.added.csv")


library(lubridate)
train_added$Incident.Creation.Time..GMT. <- 
  hms(train_added$Incident.Creation.Time..GMT.)

train_added$hour <- hour(train_added$Incident.Creation.Time..GMT.)
train_added$min <- minute(train_added$Incident.Creation.Time..GMT.)
train_added$second <- second(train_added$Incident.Creation.Time..GMT.)

# Model did way worse with these variables (like 18 million worse for the MSE!)
# so, maybe the correlation between the variables is a problem?
# or, maybe the incident.ids got scrambled somehow?
# library(dplyr) 
# training <- training %>% group_by(incident.ID) %>% mutate(NumUnits = n(), MaxDispatch = max(`Dispatch Sequence`))

# removing some columns
training2 <- train_added[,-c(1,7,8,9,11,12,13,14)]
training2 <- as.data.frame(training2)
row.names(training2) <- train_added$row.id

### One hot encoding -- converting the categoricals to numerical variables

###  taking out spaces in variable names 
# colnames(training2) <- c("year", "First_in_District",
                      "Dispatch_Sequence", "Dispatch_Status",
                      "Unit_Type", "PPE_Level", 
                      "elapsed_time", "hour", "min", "second")

# training2[,c("Dispatch_Status", "Unit_Type", "PPE_Level")] <- as.data.frame(apply(training2[,c("Dispatch_Status", "Unit_Type", "PPE_Level")], 2, as.factor))




### Testing
# load("C:/Users/Sydney/Desktop/testing.RData")

library(readr)
testing_added <- read_csv("C:/Users/Sydney/Google Drive/101_Kaggle/testing.added.csv", 
   col_types = cols(Incident.Creation.Time..GMT. = col_character(), 
   X1 = col_skip()))

testing_added$Incident.Creation.Time..GMT. <- 
  hms(testing_added$Incident.Creation.Time..GMT.)

testing_added$hour <- hour(testing_added$Incident.Creation.Time..GMT.)
testing_added$min <- minute(testing_added$Incident.Creation.Time..GMT.)
testing_added$second <- second(testing_added$Incident.Creation.Time..GMT.)

# Model did worse with these variables
# testing <- testing %>% group_by(incident.ID) %>% mutate(NumUnits = n(), MaxDispatch = max(`Dispatch Sequence`))

# removing some columns
testing2 <- testing_added[,-c(6,7,9,10,11,12)]
testing2 <- as.data.frame(testing2)
row.names(testing2) <- testing_added$row.id

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



