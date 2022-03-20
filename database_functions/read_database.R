# Function written to load database variables and export to csv file (exporting is optional)
# By Sara Knox
# March 13, 2022

# Inputs

# basepath <- "specify/your/path/here"
# yrs <- select years (e.g., c(2016:2020)) or just  a single year (e.g., 2016)
#site <- select site (e.g., "BB1")
#level <- select level (e.g., "L3")
#vars <- select years (e.g., c("AIR_TEMP_2M","TKE"))
#export <- 1 to save csv file, else 0
#outpath <- "specify/your/path/here/"
#outfilename <- specify file name (e.g., "BB1_subset_2020")

# to output R dataframe, use df <- load.export.data(basepath,yrs,site,level,vars,outpath,outfilename,export)

load.export.data <- function(basepath,yrs,site,level,vars,export,outpath,outfilename){
  
  # Load libraries
  library(reshape2)
  library(stringr)
  library(lubridate)
  
  # Loop through years
  for (i in 1:length(yrs)) {
    inpath <- paste(basepath,"/",as.character(yrs[i]),"/",site,"/",level,sep = "")
    
    setwd(inpath)
    #Convert Matlab timevector to POSIXct
    tv <- readBin("TimeVector",double(),n = 18000)
    datetime <- as.POSIXct((tv - 719529)*86400, origin = "1970-01-01", tz = "UTC")
    # Round to nearest 30 min
    datetime <- lubridate::round_date(datetime, "30 minutes") 
    
    #setup empty dataframe
    frame <- data.frame(matrix(ncol=1, nrow=length(datetime)))
    
    #Extract data of interest
    ##Use a loop function to read selected binary files and bind to the empty dataframe
    for (j in 1:length(vars)) {
      data <- readBin(vars[j],numeric(),n = 18000,size = 4)
      frame <- cbind(frame,data)
    } 
    
    df <- subset(frame, select = -c(1) ) #remove the first column that does not contain information
    df <- setNames(df, vars) #match column names to names of files
    df <- cbind(datetime,df) #Combine data with datetime
    
    if (i == 1) {
      empty_df = df[FALSE,]
      dfmultiyear <- rbind(empty_df, df)
    } else {
      dfmultiyear <- rbind(dfmultiyear, df)
    }
  }  
  
  if (export == 1) {
    write.csv(df, paste(outpath,outfilename,".csv", sep=""))
  }
  return(dfmultiyear)
}


