# Written to execute Stage Three clean
# By Sara Knox
# Aug 11, 2022

# Load function
source('/Users/sara/Code/MLABcode/database_functions/StageThree_REddyProc.R')
       
# Run Stage Three for DSM
ini_file_name <- 'DSM_StageThree_ini.R'
ini_path <- '/Users/sara/Code/MLABcode/database_functions/ini_files/'

StageThree_REddyProc(ini_file_name,ini_path)