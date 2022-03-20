# Figure for plotting sonic data
# By Sara Knox
# March 15, 2022

# Input
# data = dataframe with relevant variables
# var = sonic variables of interest (e.g., c("wind_dir","wind_speed","u_","pitch"))
# unit = units for variables defined above (e.g., c("degrees","m/s","m/s","degrees"))
# pitch_ind = index for pitch (e.g., 4)
sonic_plots <- function(data,var,unit,pitch_ind){
  
  plots <- plot.new()
  for (i in 1:length(var)){
    plots[[i]] <- plot_ly(data, x = ~datetime, y = as.formula(paste0("~", var[i]))) %>%
      add_lines(name = var[i])%>% 
      layout(yaxis = list(title = unit[i]))%>%
      toWebGL()
  }
  
  # For pitch
  # Define upper and lower limits
  max <- rep(10, length(data$datetime))
  min <- rep(-10, length(data$datetime))
  plots[[pitch_ind]] <- plots[[pitch_ind]] %>%
    add_trace(data, x = ~datetime, y = max, mode = 'lines',line = list(color = 'rgb(150, 150, 150)', width = 1, dash = 'dash'),name = 'upper limit',showlegend = F) %>%
    add_trace(data, x = ~datetime, y = min, mode = 'lines',line = list(color = 'rgb(150, 150, 150)', width = 1, dash = 'dash'),name = 'lower limit',showlegend = F)
  
  p <- subplot(plots, nrows = length(plots), shareX = TRUE, titleX = FALSE,titleY = TRUE)%>% layout(legend = list(orientation = 'h'))
  return(p)
}