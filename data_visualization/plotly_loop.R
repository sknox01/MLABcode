# Figure for plotting plotly figures using a loop
# By Sara Knox
# March 19, 2022

# Input
# data = dataframe with relevant variables
plotly_loop <- function(data,var){
  
  p <- plot_ly(data, x = ~datetime, y = as.formula(paste0("~", var[1])),name = var[1], type = 'scatter', mode = 'lines') 
  for (i in 2:length(var)){
    p <- p %>% add_trace(data, x = ~datetime,y = as.formula(paste0("~", var[i])), name = var[i], mode = 'lines')
  }
  return(p)
}
