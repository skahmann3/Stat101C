### All data manipulation


### Training
load("C:/Users/Sydney/Desktop/training.RData")

library(lubridate)
training$`Incident Creation Time (GMT)` <- 
  hms(training$`Incident Creation Time (GMT)`)

training$hour <- hour(training$`Incident Creation Time (GMT)`)
training$min <- minute(training$`Incident Creation Time (GMT)`)
training$second <- second(training$`Incident Creation Time (GMT)`)

# Model did way worse with these variables (like 18 million worse for the MSE!)
# library(dplyr) 
# training <- training %>% group_by(incident.ID) %>% mutate(NumUnits = n(), MaxDispatch = max(`Dispatch Sequence`))


### Testing
load("C:/Users/Sydney/Desktop/testing.RData")

testing$`Incident Creation Time (GMT)` <- 
  hms(testing$`Incident Creation Time (GMT)`)

testing$hour <- hour(testing$`Incident Creation Time (GMT)`)
testing$min <- minute(testing$`Incident Creation Time (GMT)`)
testing$second <- second(testing$`Incident Creation Time (GMT)`)

# Model did worse with these variables
# testing <- testing %>% group_by(incident.ID) %>% mutate(NumUnits = n(), MaxDispatch = max(`Dispatch Sequence`))


### External Data

library(readr)
FireStations <- read_csv("C:/Users/Sydney/Downloads/FireStations.csv")

length(table(FireStations$FS_CD)) ### 106 stations
length(table(training$`First in District`)) ### 102 stations

## Our data doesn't include Stations	80	(LAX),	110	(Boat	5), 111	(Boat	1)	&	114	(Air	Operations)




