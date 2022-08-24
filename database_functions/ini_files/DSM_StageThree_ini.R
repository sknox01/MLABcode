# Written by Sara Knox
# Aug 11, 2022

#paths
fx_path <- "/Users/sara/Code/MLABcode/database_functions/" # Specify path for loading functions
basepath <- "/Users/sara/Library/CloudStorage/OneDrive-UBC/UBC/database" # Specify base path

# Specify data path, years, level, and variables 
yrs <- c(2021,2022) # for multiple years use c(year1,year2)
site <- "DSM"
level_in <- "clean/SecondStage" #which folder you are loading variables from
vars <- c("NEE","LE","H","FCH4","SW_IN_1_1_1","TA_1_1_1","RH_1_1_1","VPD_1_1_1","USTAR") 
tv_input <- "clean_tv"
lat <- -12.8314 # Site latitude
long <- -69.2836 # Site longitude

export <- 0 # 1 to save a csv file of the data, 0 otherwise

# Specify variables only relevant variables for input into REddyProc 
col_order <- c("year","DOY","HHMM","NEE","LE","H","FCH4","SW_IN_1_1_1","TA_1_1_1","RH_1_1_1","VPD_1_1_1","USTAR")

# Specify variable names in REddyProc
var_names<-c('Year','DoY','Hour','NEE','LE','H','FCH4','Rg','Tair','rH','VPD','Ustar')

#Specify units to use in REddyPro input file
UNITS<-list('-','-','-','umol_m-2_s-1','Wm-2','Wm-2','nmol_m-2_s-1','Wm-2','degC','%','hPa','ms-1')

# Specify names for ThirdStage_REddyScript
level_REddyProc <- 'REddyProc_RF'
file_name <- 'data_EP.txt'

# Specify if running full Ustar scenarios ('full' - needed for better uncertainty estimation) or reduced Ustar scenarios ('fast' - runs faster)

Ustar_scenario <- 'full' # use 'full' or 'fast'

# Define variables to save in third stage
level_out <- "clean/ThirdStage"
vars_third_stage_REddyProc <- c('GPP_uStar_f','GPP_DT_uStar','NEE_uStar_orig','NEE_uStar_f','LE_uStar_orig','LE_uStar_f','H_uStar_orig','H_uStar_f','FCH4_uStar_orig','FCH4_uStar_f','Reco_uStar','Reco_DT_uStar')
vars_names_third_stage <- c('GPP_PI_F_NT','GPP_PI_F_DT','NEE','NEE_PI_F_MDS','LE','LE_PI_F_MDS','H','H_PI_F_MDS','FCH4','FCH4_PI_F_MDS','Reco_PI_F_NT','Reco_PI_F_DT')

# Gap-filling FCH4 
fill_RF_FCH4 <- 1 # 0 (no) or 1 (yes) to fill FCH4 and long gaps with RF from Kim et al., 2019 GCB 
level_RF_FCH4 <- "clean/ThirdStage" # which folder you are loading variables from for RF gap-filling

# variable we need for FCH4 gap-filling (if implementing)
# df includes FCH4 and predictor variables.
# FCH4 should be quality controlled. Other variables should be fully gap-filled (maybe gap-fill long gaps for CO2 fluxes first!! ADD LATER)
predictors_FCH4 <- c("FCH4", "USTAR","NEE_PI_F_MDS","LE_PI_F_MDS","H_PI_F_MDS","SW_IN_1_1_1","TA_1_1_1","TS_1",
                "RH_1_1_1","VPD_1_1_1","PA_1_1_1")
plot_RF_results <- 0
vars_third_stage_RF_FCH4 <- c('FCH4_PI_F_RF')

# Gap-filling and long gaps with RF (add later!!)

# Remove all non-relevant variables needed to run StageThree script
# rm(vars,var_names,min, col_order)
