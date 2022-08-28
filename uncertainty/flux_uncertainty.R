# Written to calculate uncertainty for fluxes for annual sums
# Based on 'Aggregating uncertainty to daily and annual values' (see: https://github.com/bgctw/REddyProc/blob/master/vignettes/aggUncertainty.md)
# By Sara Knox
# Aug 26, 2022

# Inputs 
# ini_file_name <- name of your ini file (e.g., "DSM_StageThree_ini.R")
# ini_path <- path to the ini file (e.g., "/Users/sara/Code/MLABcode/database_functions/ini_files/")

#paths
fx_path <- "/Users/sara/Code/MLABcode/database_functions/" # Specify path for loading functions
basepath <- "/Users/sara/Library/CloudStorage/OneDrive-UBC/UBC/database" # Specify base path

# Specify data path, years, level, and variables 
yrs <- c(2021,2022) # for multiple years use c(year1,year2)
site <- "DSM"
level_in <- "REddyProc_RF" #which folder you are loading variables from
vars <- list.files(path = paste(basepath,"/",yrs[1],"/",site,"/",level_in,sep = "")) # Assumes variables are the same for all years
tv_input <- "clean_tv"
start_dates <- as.Date("2021-09-04") # GENERALIZE TO LOOP OVER MULTIPLE YEARS
end_dates <- as.Date("2022-09-04") # GENERALIZE TO LOOP OVER MULTIPLE YEARS

export <- 0 # 1 to save a csv file of the data, 0 otherwise

# Load required libraries
library("dplyr")
library("lubridate")

# Load ini file - create ini file
#source(paste(ini_path,ini_file_name,sep = ""))

# Read function for loading data
p <- sapply(list.files(pattern="read_database.R", path=fx_path, full.names=TRUE), source)

# Loop through each year
df <- data.frame()
for (j in 1:length(yrs)) {
  
  # Load ini file
 # source(paste(ini_path,ini_file_name,sep = ""))
  
  # Create data frame for years & variables of interest to import into REddyProc
  df.now <- load.export.data(basepath,yrs[j],site,level_in,vars,tv_input,export)
  df <- dplyr::bind_rows(df,df.now)
}

# LOOP OVER YEARS
start_ind <- which(df$datetime==start_dates[1])+1 #+1 added to start at 30 min 
end_ind <- which(df$datetime==end_dates[1])
data <- df[c(start_ind:end_ind), ]

# NEE uncertainty

# Random error
# Considering correlations

# REddyProc flags filled data with poor gap-filling by a quality flag in NEE_<uStar>_fqc > 0 but still reports the fluxes. For aggregation we recommend computing the mean including those gap-filled records, i.e. using NEE_<uStar>_f instead of NEE_orig. However, for estimating the uncertainty of the aggregated value, the the gap-filled records should not contribute to the reduction of uncertainty due to more replicates.
# Hence, first we create a column 'NEE_orig_sd' similar to 'NEE_uStar_fsd' but where the estimated uncertainty is set to missing for the gap-filled records.
data <- data %>% 
  mutate(
    NEE_orig_sd = ifelse(
      is.finite(NEE_uStar_orig), NEE_uStar_fsd, NA), # NEE_orig_sd includes NEE_uStar_fsd only for measured values
    NEE_uStar_fgood = ifelse(
      NEE_uStar_fqc <= 1, NEE_uStar_f, NA), # Only include filled values for the most reliable gap-filled observations. Note that is.finite() shouldn't be used here.
    resid = ifelse(NEE_uStar_fqc == 0, NEE_uStar_orig - NEE_uStar_fall, NA), # quantify the error terms, i.e. model-data residuals.
    resid_not_filtered = NEE_uStar_orig - NEE_uStar_fall # quantify the error terms, i.e. model-data residuals but not filtered.
  ) #QUESTION - NEE_uStar_fqc == 0 doesn't apply to NEE_uStar_orig since orig has no gap-filled data. Does bad-quality data mean the foken flags? Otherwise what is meant by 'Note that this function needs to be applied to the series including all records, i.e.  not filtering quality flag before.'?

# plot_ly(data = data, x = ~datetime, y = ~NEE_uStar_f, name = 'filled', type = 'scatter', mode = 'markers',marker = list(size = 3)) %>%
#   add_trace(data = data, x = ~datetime, y = ~NEE_uStar_orig, name = 'orig', mode = 'markers') %>% 
#   toWebGL()

autoCorr <- lognorm::computeEffectiveAutoCorr(data$resid_not_filtered)
nEff <- lognorm::computeEffectiveNumObs(data$resid_not_filtered, na.rm = TRUE)
c(nEff = nEff, nObs = sum(is.finite(data$resid_not_filtered))) #Check which resid to use!

# Note, how we used NEE_uStar_f for computing the mean, but NEE_orig_sd instead of NEE_uStar_fsd for computing the uncertainty.
resRand <- data %>% summarise(
  nRec = sum(is.finite(NEE_orig_sd))
  , NEEagg = mean(NEE_uStar_f, na.rm = TRUE)
  , varMean = sum(NEE_orig_sd^2, na.rm = TRUE) / nRec / (!!nEff - 1)
  , sdMean = sqrt(varMean) 
  , sdMeanApprox = mean(NEE_orig_sd, na.rm = TRUE) / sqrt(!!nEff - 1)
) %>% select(NEEagg, sdMean, sdMeanApprox)
resRand

# can also compute Daily aggregation -> but not done here.

# u* threshold uncertainty
ind <- which(grepl("NEE_U*", names(data)) & grepl("_f$", names(data)))
column_name <- names(data)[ind] 

#calculate column means of specific columns
NEEagg <- colMeans(data[ ,column_name], na.rm=T)

#compute uncertainty across aggregated values
sdNEEagg_ustar <- sd(NEEagg)
sdNEEagg_ustar

# Combined aggregated uncertainty

#Assuming that the uncertainty due to unknown u*threshold is independent from the random uncertainty, the variances add.
NEE_sdAnnual <- data.frame(
  sdRand = resRand$sdMean,
  sdUstar = sdNEEagg_ustar,
  sdComb = sqrt(resRand$sdMean^2 + sdNEEagg_ustar^2) 
)

data.mean_NEE_uStar_f <- data.frame(mean(data$NEE_uStar_f, na.rm = TRUE)_

# Convert to annual sums
conv <- 

# GPP uncertainty (only u* for now)
computeMeanGPP <- function(ds, suffix){
  column_name <- paste0("GPP_",suffix,"_f")
  mean(ds[[column_name]],na.rm = TRUE) # REMOVE na.rm = TRUE
}
#FilledEddyData <- EProc$sExportResults()
GPPagg <- unlist(EProc$sApplyUStarScen(computeMeanGPP, data))
GPPagg

#compute uncertainty across aggregated values
sdGPPagg_ustar <- sd(GPPagg)
sdGPPagg_ustar

# Reco uncertainty (only u* for now)
# Rename column names to compute uncertainty
col_indx <- grep(pattern = '^Reco_U.*', names(data))
for (i in 1:length(col_indx)) {
  colnames(data)[col_indx[i]] <-
    paste(colnames(data)[col_indx[i]], "_f", sep = "")
}

computeMeanReco <- function(ds, suffix){
  column_name <- paste0("Reco_",suffix,"_f")
  mean(ds[[column_name]],na.rm = TRUE) # REMOVE na.rm = TRUE
}
#FilledEddyData <- EProc$sExportResults()
Recoagg <- unlist(EProc$sApplyUStarScen(computeMeanReco, data))
Recoagg

#compute uncertainty across aggregated values
sdRecoagg_ustar <- sd(Recoagg,na.rm = TRUE) # Figure out with uStar mean is NA...
sdRecoagg_ustar

# Next convert means to annual sums

# CREATE OUTPUT