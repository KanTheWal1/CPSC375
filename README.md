# CPSC375
## Data Science Using RStudio

**1)	Data preparation/wrangling to get all the data into one table that can be used for linear modeling:**

  a)	reading the data files using read_csv()
  
  b)	Removing unneeded rows (e.g., countries like Brazil and India report Province_State-level data that is not needed as we are studying only country-level rates) and columns. 
  
  c)	tidying tables, as needed. For example, the vaccinations data is not tidy.
  
  d)	Calculate the vaccination rate: vaccinations/population
  
  e)	Since the most important factor affecting vaccination rate is the number of days since vaccination began (vaccination rate always increases), calculate a variable that is: number of days since first non-zero vaccination number. This variable will be important for modeling. 
  
  f)	Discard data that is not needed. For example, only the number of hospital beds from the most recent year is necessary.
  
  g)	You can ignore sex-related differences in demographics in this project, so add the male/female population numbers together (already done in HW #5).
  
  h)	Merge all tables (Hint: Join using the country name)
   
At the end of these steps, the data should be in one table, in a format ready for linear regression:

**2)	Linear modeling the Covid vaccination rate:**
Make a list of all predictor variables that are available. The challenge is to identify which combination of these predictors will give the best predictive model. You should also try transforming some of the variables (e.g., transforming population counts to proportion of total population). Run linear regression with at least 5 different combinations of predictor variables. 

Note: each day becomes one data point, i.e., the vaccination rate is calculated for each day for each country. The number of vaccinations should not be used as an independent variable as this is essentially what you are predicting.
