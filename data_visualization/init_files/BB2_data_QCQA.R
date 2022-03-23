# This is our external R script for the analyses being called in the R markdown file

## @knitr LoadData

# Load data
opts_knit$set(root.dir = "/Users/sara/Code/MLABcode/data_visualization") # Specify directory

basepath <- "/Volumes/GoogleDrive/My Drive/UBC/Micromet Lab/database"
yrs <- c(2019:2022)
site <- "BB2"
level <- "L3"
vars <- c("wind_dir","wind_speed","u_","pitch","year","w_var","WIND_VELOCITY_CUP","WIND_VELOCITY_EC",
          "sonic_temperature","AIR_TEMP_2M","air_temperature","air_t_mean","RH_2M","RH","e","es_x","es_y",
          "SHORTWAVE_IN","SHORTWAVE_OUT","LONGWAVE_IN","LONGWAVE_OUT","NR","INCOMING_PAR","REFLECTED_PAR",
          "air_pressure","air_p_mean","PA_1_5M","PA_EC_AIR2_5M")
export <- 0 

# Create dataframe for years & variables of interest
# Path to function to load data
source("/Users/sara/Code/MLABcode/database_functions/read_database.R")

data <- load.export.data(basepath,yrs,site,level,vars,export)

# Remove missing data (should be -9999 so FIX eventually)
data <- replace(data, data == -9999, NA)

# Remove empty columns for the end of the year (and start in some cases)
ind <- !is.nan(data$year)
data <- data[ind, ]

# Path to plotting functions
data_visualization_path <- "/Users/sara/Code/MLABcode/data_visualization/"

p <- sapply(list.files(pattern="[.]R$", path=data_visualization_path, full.names=TRUE), source)

# Specify variables for sonic_data_plotting.R
vars_WS <- c("wind_speed","WIND_VELOCITY_CUP") # Include sonic wind speed first
vars_WD <- "wind_dir"
vars_other_sonic <- c("u_","pitch") # include u* (u_) first
units_other_sonic <- c("m/s","degrees")
pitch_ind <- 2

# Specify other sonic variables
wind_variance <- "w_var" # If using all variances, make sure w_var is first

# Specify variables for temp_RH_data_plotting.R

# Temperature variables
# Make sure that all temperature variables are in the same units (e.g., Celsius)
data$sonic_temperature_C <- data$sonic_temperature-273.15
data$air_t_mean_C <- data$air_t_mean-273.15
data$air_temperature_C <- data$air_temperature-273.15

# Now specify variables
vars_temp <- c("AIR_TEMP_2M","sonic_temperature_C","air_t_mean_C") # Order should be HMP, sonic temperature, 7700 temperature

# RH variables

# Now specify variables
vars_RH <- c("RH_2M","RH") # Order should be HMP then 7200

# Radiation variables
vars_radiometer <- c("SHORTWAVE_IN","SHORTWAVE_OUT","LONGWAVE_IN","LONGWAVE_OUT") # note that SW_IN and SW_OUT should always be listed as variables 1 and 2, respectively
vars_NETRAD <- "NR"
vars_PPFD <- c("INCOMING_PAR","REFLECTED_PAR") #Note incoming PAR should always be listed first.

# Pressure variables
# Make sure that all pressure variables are in the same units (e.g., kPa)
data$air_pressure_kPa <- data$air_pressure/1000
data$air_p_mean_kPa <- data$air_p_mean/1000

vars_pressure <- c("air_pressure_kPa","air_p_mean_kPa","PA_1_5M","PA_EC_AIR2_5M") # note that 

