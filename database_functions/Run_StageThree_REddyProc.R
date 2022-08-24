# Written to execute Stage Three clean
# By Sara Knox
# Aug 11, 2022

# Load function
source('/Users/sara/Code/MLABcode/database_functions/StageThree_REddyProc.R')
       
# Run Stage Three for DSM
ini_file_name <- 'DSM_StageThree_ini.R'
ini_path <- '/Users/sara/Code/MLABcode/database_functions/ini_files/'

StageThree_REddyProc(ini_file_name,ini_path)

# #To delete
# df <- data_RF
# fill_var <- predictors_FCH4[1]
# predictor_vars <- predictors_FCH4
# plot_results <- plot_RF_results
# year_of_interest <- yrs[j]
# years_all <- yrs