# Compare ECCC data with flux tower data to assess which ECCC site is best to use for gap-filling

# Load clean data
basepath <- "/Users/sara/Library/CloudStorage/OneDrive-UBC/UBC/database"
yrs <- c(2022)
site <- "DSM"
level_met <- "Met/clean"
vars_met <- c("TA_1_1_1","TA_ECCC","RH_1_1_1","RH_ECCC","PA_1_1_1","PA_ECCC",
          "P_1_1_1","P_ECCC","WS_ECCC","WD_ECCC")
level_flux <- "Flux/clean"
vars_flux <- c("WS_1_1_1","WD_1_1_1")
tv_input <- "clean_tv"

export <- 0 # 1 to save a csv file of the data, 0 otherwise

# Create data frame for years & variables of interest
# Path to function to load data
source("/Users/sara/Code/MLABcode/database_functions/read_database.R")
data_met <- load.export.data(basepath,yrs,site,level_met,vars_met,tv_input,export)
data_flux <- load.export.data(basepath,yrs,site,level_flux,vars_flux,tv_input,export)
data <- merge(data_met, data_flux, by="datetime",all = T)

var <- list(as.list(c("TA_1_1_1","TA_ECCC")),as.list(c("RH_1_1_1","RH_ECCC")),
            as.list(c("PA_1_1_1","PA_ECCC")),as.list(c("P_1_1_1","P_ECCC")),
            as.list(c("WS_1_1_1","WS_ECCC")),as.list(c("WD_1_1_1","WD_ECCC")))
yaxlabel <- c("TA","RH","PA","P","WS","WD")
multiple_plotly_plots(data,var,yaxlabel)
  
data <- data %>%
  mutate(year = year(datetime))

var1 <- "P_1_1_1"
var2 <- "P_ECCC"
xlab <- "tower"
ylab <- "ECCC"
scatter_plot_QCQA(data,var1,var2,xlab,ylab,0)
    
# Check cumulative precipitation 
data$P_1_1_1_cumsum <- data$P_1_1_1
data$P_1_1_1_cumsum[which(is.na(data$P_1_1_1_cumsum))] <- 0
data$P_ECCC_cumsum <- data$P_ECCC
data$P_ECCC_cumsum[which(is.na(data$P_ECCC_cumsum))] <- 0

data$P_1_1_1_cumsum <- cumsum(data$P_1_1_1_cumsum)
data$P_ECCC_cumsum <- cumsum(data$P_ECCC_cumsum)

p <- plot_ly(data, x = ~datetime, y = ~P_1_1_1_cumsum,name = "flux tower",type = 'scatter', mode = 'lines') %>%
  add_trace(data, x = ~datetime,y = ~P_ECCC_cumsum,name = "ECCC", mode = 'lines')
p