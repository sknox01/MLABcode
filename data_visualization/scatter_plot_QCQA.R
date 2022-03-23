# Figure for data QCQA scatter plot
# By Sara Knox
# Created March 15, 2022

# Input
# data = dataframe with relevant variables
# x = x variable name
# y = y variable name
# year = "year"
# xlab = x label
# ylab = y label
scatter_plot_QCQA <- function(data,x,y,year,xlab,ylab){
  
  sumtbl <- summary(lm(y ~ x,data = data))
  slope <- sumtbl$coefficients[2]
  r2 <- sumtbl$adj.r.squared
  
  p <- ggplot(data, aes(x, y)) + 
    geom_point(aes(color = as.factor(year)),alpha = 0.6)+
    #geom_point(aes(color = as.factor(year),frame = year))+ # if want to do each year individually
    geom_smooth(method=lm, color = "black")+
    ggtitle(paste("Slope = ",as.character(round(slope,2)),", R2 = ",as.character(round(r2,2))))+
    theme(plot.title = element_text(color = "grey44"))+
    theme(plot.title = element_text(size = 8))+ 
    labs(x = xlab)+
    labs(y = ylab)+
    labs(color="Year")
  
  return(toWebGL(ggplotly(p)))
}
