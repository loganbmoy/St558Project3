#
# Best Model API
#

library(plumber)
library(bundle)
library(tidymodels)
library(lubridate)

#* @apiTitle Plumber Example API
#* @apiDescription Plumber example description.

mhData <- readRDS("data/mhData.rds")

rf_bundle <- readRDS("data/rf_bundle.rds")

rf_model <- unbundle(rf_bundle)

#* Predict a value using the best model, uses most prevalent value for categorical values
#* and average for numeric variables for the default. These values come from the original full dataset.
#* @param Suburb Which Suburb used in prediction
#* @param Rooms Number of Rooms used in prediction
#* @param Type Type of home used in prediction
#* @param Method Method of sale used in prediction
#* @param Distance Distance from CBD used in prediction
#* @param Postcode Postcode of property used in prediction
#* @param Bedroom2 Number of Bedroom2 used in prediction
#* @param Bathroom Number of Bathroom used in prediction
#* @param Car Number of Car used in prediction
#* @param Landsize Landsize of property used in prediction
#* @param BuildingArea BuildingArea of property used in prediction
#* @param Lattitude Lattitude used in prediction
#* @param Longtitude Longtitude used in prediction
#* @param Regionname Regionname of property used in prediction
#* @param Propertycount Propertycount of suburb used in prediction
#* @param Date_month Date month of sale used in prediction
#* @param Date_day Date day of sale used in prediction
#* @param Date_year Date year of sale used in prediction
#* @get /pred
function(Suburb = names(which.max(table(mhData$Suburb))),
         Rooms = mean(mhData$Rooms),
         Type = names(which.max(table(mhData$Type))),
         Method = names(which.max(table(mhData$Method))),
         Distance = mean(mhData$Distance, na.rm = TRUE),
         Postcode = mean(mhData$Postcode, na.rm = TRUE),
         Bedroom2 = mean(mhData$Bedroom2, na.rm = TRUE),
         Bathroom = mean(mhData$Bathroom, na.rm = TRUE),
         Car = mean(mhData$Car, na.rm = TRUE),
         Landsize = mean(mhData$Landsize, na.rm = TRUE),
         BuildingArea = mean(mhData$BuildingArea, na.rm = TRUE),
         YearBuilt = mean(mhData$YearBuilt, na.rm = TRUE),
         CouncilArea = names(which.max(table(mhData$CouncilArea))),
         Lattitude = mean(mhData$Lattitude, na.rm = TRUE),
         Longtitude = mean(mhData$Longtitude, na.rm = TRUE),
         Regionname = names(which.max(table(mhData$Regionname))),
         Propertycount = mean(mhData$Propertycount, na.rm = TRUE),
         Date_month = names(which.max(table(month(as.Date(mhData$Date))))),
         Date_day = names(which.max(table(day(as.Date(mhData$Date))))),
         Date_year = names(which.max(table(year(as.Date(mhData$Date)))))
         ) {
  date_complete = make_date(Date_year, Date_month, Date_day)
  property <- tibble(Suburb = Suburb,
                     Rooms = as.numeric(Rooms),
                     Type = Type,
                     Method = Method,
                     Distance = as.numeric(Distance),
                     Postcode = as.numeric(Postcode),
                     Bedroom2 = as.numeric(Bedroom2),
                     Bathroom = as.numeric(Bathroom),
                     Car = as.numeric(Car),
                     Landsize = as.numeric(Landsize),
                     BuildingArea = as.numeric(BuildingArea),
                     YearBuilt = as.numeric(YearBuilt),
                     CouncilArea = CouncilArea,
                     Lattitude = as.numeric(Lattitude),
                     Longtitude = as.numeric(Longtitude),
                     Regionname = Regionname,
                     Propertycount = as.numeric(Propertycount),
                     Date =  date_complete
  )
  
  list(predicted_price = predict(rf_model, new_data = property) %>% pull(.pred) %>%
    exp())
}

#* Examples
#* http://127.0.0.1:7968/pred?Suburb=Richmond&Rooms=3&Bathroom=2&Car=1
#* 
#* http://127.0.0.1:7968/pred?Suburb=Abbotsford&Rooms=3&Type=h&Method=S&Distance=2.5&Postcode=3121&Bedroom2=2&Bathroom=2&Car=2&Landsize=150&BuildingArea=150&YearBuilt=2000&CouncilArea=Yarra%20City%20Council&Lattitude=-37&Longtitude=150&Regionname=Eastern%20Metropolitan&Propertycount=4019&Date_month=2&Date_day=3&Date_year=2017
#* 
#* http://127.0.0.1:7968/pred?Type=t&Bathroom=2&Car=1&YearBuilt=1990

#* Info about the API
#* @get /info
function() {
    list(Author = "Logan Moy", url = "https://loganbmoy.github.io/St558Project3/St558Project3.html") 
}

