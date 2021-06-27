#' The geotime_axis function
#'
#' This function allows you to do zonal statistics of a point dataset
#' @param plot An intiated ggplot object without any theme and axis settings
#' @param level Level of the geological interval to be shown on the axis. Default is period. Others available include age, epoch, era, and eon.
#' @param age_min The minimum age of the plot (in Ma). Default is 0.
#' @param age_max The maximum age of the plot (in Ma). Default is 0.
#' @param x_reverse If the x axis should be reversed (older ages to the left)
#' @param y_reveerse If the y axis should be reversed (smaller value to the top)
#' @param label If the time scale should be labelled. Options: abbr, fullname, or none
#' @param div_y How many breaks (tickmarks) should be on the y axis. Default is 10.
#' @param div_x How many breaks (tickmarks) should be on the x axis. Default is 10.
#' @param pos The position of the legend if there is one. Default is to the right. See ggplot2.
#' @keywords geological time scale
#' @export 
#' @examples
#' plot <- ggplot() + geom_line(aes(...), ...) 
#' p <- geotime_axis(plot, age_min = 0, age_max = 800,level = "period", label = "abbr", div_x = 10)


geotime_axis <- function(plot, level = "period", age_min = 0, age_max = 540, x_reverse = T, y_reverse = F, label = "abbr", div_y = 10, div_x = 10, pos = "right"){
  
  if(level %in% c("period")){
    interval <- read.csv("https://raw.githubusercontent.com/yeshancqcq/geotime/master/periods.csv")
  } else if (level %in% c("epoch")){
    interval <- read.csv("https://raw.githubusercontent.com/yeshancqcq/geotime/master/epoch.csv")
    
  } else if (level %in% c("eon")){
    interval< read.csv("https://raw.githubusercontent.com/yeshancqcq/geotime/master/eon.csv")
  }  else if(level %in% c("age")){
    interval <- read.csv("https://raw.githubusercontent.com/yeshancqcq/geotime/master/age.csv")
  } else {
    interval <- read.csv("https://raw.githubusercontent.com/yeshancqcq/geotime/master/era.csv")
  }
  
  interval$min_age[interval$min_age < age_min] <- age_min
  interval$max_age[interval$max_age > age_max] <- age_max
  
  
  interval$mid_age <- (interval$max_age + interval$min_age)/2
  
  xyext <- ggplot_build(plot)$layout$panel_params[[1]]
  
  
  if(y_reverse){
    ymax <- max(xyext$y.range)
    ymin <- max(xyext$y.range) -(max(xyext$y.range) - min(xyext$y.range))/25
  }else{
    ymin <- min(xyext$y.range)
    ymax <- min(xyext$y.range) + (max(xyext$y.range) - min(xyext$y.range))/25
  }
  
  
  plot <- plot +
    annotate("rect", xmin = interval$min_age, xmax = interval$max_age, ymin = ymin, ymax = ymax,
             fill = interval$color, color = "black", alpha = 1) 
  
  if(label == "abbr"){
    plot <- plot + annotate("text", x = interval$mid_age, label = interval$abbr, y = (ymin+ymax)/2,
                            vjust = "middle", hjust = "middle", size = 4.5)
  } else if(label == "full"){
    plot <- plot + annotate("text", x = interval$mid_age, label = interval$time, y = (ymin+ymax)/2,
                            vjust = "middle", hjust = "middle", size = 4.5)
  }
  
  
  plot <- plot +
    coord_cartesian( expand = FALSE) +
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_rect(colour="black", fill = NA), 
          axis.line = element_line(color = "black"),
          axis.text = element_text(size = 12),
          legend.justification = c(0, 0),
          axis.title = element_text(size = 12),
          legend.position = pos,
          legend.background = element_rect(colour=NA, fill = NA),
          legend.key = element_rect(colour = NA, fill = NA)
    )
  
  if(y_reverse){
    plot <- plot + scale_y_reverse(breaks = scales::pretty_breaks(n = div_y))
  } else {
    plot <- plot + scale_y_continuous(breaks = scales::pretty_breaks(n = div_y))
  }
  
  if(x_reverse){
    plot <- plot + scale_x_reverse(limits = c(age_max, age_min), breaks = scales::pretty_breaks(n = div_x))
  } else {
    plot <- plot + scale_x_continuous(limits = c(age_mim, age_max),breaks = scales::pretty_breaks(n = div_x))
  }
  
  return(plot)
}