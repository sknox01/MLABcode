# Specify path for loading functions
fx_path <- "/Users/sara/Code/MLABcode/database_functions/"
# Read functions
p <- sapply(list.files(pattern="[.]R$", path=fx_path, full.names=TRUE), source)

# Specify data path, years, level, and variables 
basepath <- "/Users/sara/Library/CloudStorage/OneDrive-UBC/UBC/database"
yrs <- c(2022) # for multiple years use c(year1,year2)
site <- "DSM"
level <- "clean/SecondStage" 
vars <- c("NEE","H","LE","SW_IN_1_1_1","TA_1_1_1","RH_1_1_1","VPD","USTAR")
tv_input <- "clean_tv"

export <- 0 # 1 to save a csv file of the data, 0 otherwise

# Create data frame for years & variables of interest
data <- load.export.data(basepath,yrs,site,level,vars,tv_input,export)
