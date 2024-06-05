# CPSC 375-01
# --------------------------------- Project 1 -------------------------------------
# libraries Initialized: 
library(ggplot2)
library(modelr)
library(class)
library(tidyverse)

# **************************** Part 1: Tidying tables *****************************
# ---------------------------------------------------------------------------------

# A. Importing dataset using RStudio:
# 1) 
hospitalbeds <- hospitalbeds <- read_csv("C:/Users/KanAh/Desktop/CSUF/CSUF Fall 2022/CPSC 375 - Big Data & Data Science/Project 1 & Midterm/hospitalbeds.csv")
# check for NAs: sum(is.na(hospitalbeds)) && which(is.na(hospitalbeds))

# 2)
demographics <- read_csv("C:/Users/KanAh/Desktop/CSUF/CSUF Fall 2022/CPSC 375 - Big Data & Data Science/Project 1 & Midterm/demographics.csv")
# check for NAs: sum(is.na(demographics)) && which(is.na(demographics))
# found staggered btw elements 15586:19196 and this code didn't work to remove the values: 
#                 "demographics <- demographics %>% filter(values_drop_na = TRUE)"
#                 "demo1 <- demographics %>% filter(is.na(demographics) == TRUE)"
# 
# This works --> demo1 <- demographics %>% na.omit() %>% view()
# Check: > which(is.na(demo1))
# integer(0)
# ------------------------------------------------ NOTE -----------------------------------------------------
# To Drop Rows with NA's in All Columns
# To remove observations with missing values in at least one column, you can use the na.omit() function.
# 
# The na.omit() function in the R language inspects all columns from a data frame and drops rows that have NA's in one or more columns.
# ----------------------------------------------------------------------------------------------------------------------------------------  
# demographics <- demographics %>% na.omit() %>% view()

# 3)
vaccine <- time_series_covid19_vaccine_doses_admin_global <- read_csv("https://raw.githubusercontent.com/govex/COVID-19/master/data_tables/vaccine_data/global_data/time_series_covid19_vaccine_doses_admin_global.csv")
# > sum(is.na(vaccine))
# [1] 273140
# 
# Can't omit NAs like this because RStudio removes all rows 
# vac1 <- vaccine %>% na.omit() %>% view()


# ----------------------------------------------------------

# B.	For Demographics.csv: 
demographics <- demographics %>% pivot_wider(-c(`Series Name`),names_from=`Series Code`,values_from = YR2015) %>% view()
# demographics <- demographics %>% mutate(SP.POP.80UP=SP.POP.80UP.FE+SP.POP.80UP.MA) %>% mutate(SP.POP.1564.IN=SP.POP.1564.MA.IN+SP.POP.1564.FE.IN) %>% mutate(SP.POP.0014.IN=SP.POP.0014.MA.IN+SP.POP.0014.FE.IN) %>% mutate(SP.DYN.AMRT=SP.DYN.AMRT.MA+SP.DYN.AMRT.FE) %>% mutate(SP.POP.TOTL.IN=SP.POP.TOTL.FE.IN+SP.POP.TOTL.MA.IN) %>% mutate(SP.POP.65UP.IN=SP.POP.65UP.FE.IN+SP.POP.65UP.MA.IN) %>% select(-contains(".FE")) %>% select(-contains(".MA"))
demographics <- demographics %>% filter(values_drop_na = TRUE)
demographics <- demographics %>% mutate(SP.POP.80UP=(SP.POP.80UP.FE+SP.POP.80UP.MA)) %>% mutate(SP.POP.1564.IN=(SP.POP.1564.FE.IN+SP.POP.1564.MA.IN)) %>% mutate(SP.POP.0014.IN=(SP.POP.0014.FE.IN+SP.POP.0014.MA.IN)) %>% mutate(SP.DYN.AMRT=(SP.DYN.AMRT.FE+SP.DYN.AMRT.MA)) %>% mutate(SP.POP.65UP.IN=(SP.POP.65UP.FE.IN+SP.POP.65UP.MA.IN))
demographics <- demographics %>% select(-c(SP.POP.80UP.FE, SP.POP.80UP.MA, SP.POP.1564.FE.IN, SP.POP.1564.MA.IN, SP.POP.0014.FE.IN, SP.POP.0014.MA.IN, SP.DYN.AMRT.FE, SP.DYN.AMRT.MA, SP.POP.TOTL.FE.IN, SP.POP.TOTL.MA.IN, SP.POP.65UP.FE.IN, SP.POP.65UP.MA.IN, `Country Code`))
colnames(demographics)[colnames(demographics) == "Country Name"] = "Country"

colnames(demographics)[colnames(demographics) == "SP.DYN.LE00.IN"] = "Life expectancy at birth"
colnames(demographics)[colnames(demographics) == "SP.URB.TOTL"] = "Urban population"
colnames(demographics)[colnames(demographics) == "SP.POP.TOTL"] = "Population Total"
colnames(demographics)[colnames(demographics) == "SP.POP.80UP"] = "Population ages 80 and above"
colnames(demographics)[colnames(demographics) == "SP.POP.1564.IN"] = "Population ages 15-64"
colnames(demographics)[colnames(demographics) == "SP.POP.0014.IN"] = "Population ages 0-14"
colnames(demographics)[colnames(demographics) == "SP.DYN.AMRT"] = "Adult Mortality rate"
colnames(demographics)[colnames(demographics) == "SP.POP.65UP.IN"] = "Population ages 65 and above"

# **** colnames(demographics)[colnames(demographics) == "SP.POP.TOTL.IN"] = "Population Total" ***** # Deleting duplicate #

# demo1 <- demographics %>% na.omit() %>% view()
# ----------------------------------------------------------

# C. For time_series_covid19_vaccine_doses_admin_global:
vaccine <- vaccine %>% filter(is.na(Province_State) == TRUE) %>% select(-c(UID,iso2,iso3,code3,FIPS,Admin2,Lat,Long_,Combined_Key,Province_State))
vaccine <- vaccine %>% pivot_longer(cols = starts_with("202"), names_to = "date", values_to = "shots", values_drop_na = TRUE)
vaccine <- vaccine %>% filter(shots > 0)
vaccine <- vaccine %>% mutate(vacRate=(shots/Population)) 
colnames(vaccine)[colnames(vaccine) == "Country_Region"] = "Country"
vaccine <- vaccine %>% group_by(Country) %>% mutate(daysSinceStart = 1:n()) %>% select(-c(date)) 

#vaccine <- vaccine %>% select(-c(date)) %>% view()
#filter(shots > 0 is.na(shots) == TRUE //, is.na(Population) == TRUE
# -----------------------------------------------------------------------------------------------------
# filter(is.na(shots) == TRUE, is.na(Population) == TRUE) %>%
# vaccine <- vaccine %>% drop_na() %>% view() // 
# vacCheck <- vaccine %>% filter(is.na(Population) ==TRUE , is.na(vacRate) == TRUE)
# vaccine[4436:70000,] %>% view()
# vaccine_rate_data <- vaccine_rate_data %>% mutate(Population = if_else(condition = is.na(Population), true = total_pop, false = Population)) 
# -----------------------------------------------------------------------------------------------------

# D.	For hospitalbeds:
colnames(hospitalbeds)[colnames(hospitalbeds) == "Hospital beds (per 10 000 population)"] = "beds"
hospitalbeds <- hospitalbeds %>% group_by(Country) %>% top_n(1, Year)
hospitalbeds <- hospitalbeds %>% select(-c(Year)) 
# ----------------------------------------------------------

# E.	Fix for Names, all tables(hospitalbeds, demographics, vaccine):
hospitalbeds <- hospitalbeds %>% mutate(Country = replace(Country, Country == "Republic of Korea", "South Korea")) %>% view()
hospitalbeds <- hospitalbeds %>% mutate(Country = replace(Country, Country == "Iran (Islamic Republic of)", "Iran")) %>%  view()
hospitalbeds <- hospitalbeds %>% mutate(Country = replace(Country, Country == "United Kingdom of Great Britain and Northern Ireland" , "United Kingdom")) %>% view()
hospitalbeds <- hospitalbeds %>% mutate(Country = replace(Country, Country == "United States of America", "United States"))
demographics <- demographics %>% mutate(Country = replace(Country, Country == "Iran, Islamic Rep." , "Iran"))
demographics <- demographics %>% mutate(Country = replace(Country, Country == "Korea, Rep." , "South Korea"))
vaccine<- vaccine%>% mutate(Country = replace(Country, Country == "Korea, South" , "South Korea"))
vaccine <- vaccine %>% mutate(Country = replace(Country, Country == "US", "United States"))
# ----------------------------------------------------------

# F.	Inner Join Fn: 
vaccineJoin <- vaccine%>% inner_join(hospitalbeds, by=c("Country")) %>% view()
vaccineJoin  <- vaccineJoin %>% inner_join(demographics, by=c("Country")) %>% view()

#G.	Dropping all NA values:
# Test Code:
# vacEx <- vaccineJoin
# vacEx <- vacEx %>% drop_na() %>% view()
# vaccineJoin <- vaccineJoin %>% drop_na() %>% view()
vaccineJoin2 <- vaccineJoin %>% drop_na() %>% view() # *!TEST!* #
# check vaccineJoin NA values with this code:
# > which(is.na(vaccineJoin))
#
# ---------------------------------------------------------- END CODE Part 1 ------------------------------------------------------------------------------------------- 







