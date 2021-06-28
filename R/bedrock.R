#' The bedrock function
#'
#' This function allows you to quickly plot maps showing the bedrock coverage of given ages
#' @param x The younger limit of the age interval to plot
#' @param y The older limit of the age interval to plot (optional)
#' @param range Indicating the temporal overlapping method of the given interval and the bedrock interval. Either "partial" (default) or "entire".
#' @keywords bedrock coverage
#' @export 
#' @examples
#' bedrock(66,70,range="entire")



bedrock <- function(x, y=-1, range="partial"){
  if(x < 0){
    cat("Input data wrong. The value should be between 0 and 4600.")
  }
  else if(x > y){
    cat("Input data wrong. The second value should be either blank or bigger than the first value.")
  }
  else if(!(range %in% c("partial","entire"))){
    cat("Input data wrong. Range should be either partial or entire.")
  }
  else if(x <= y){
    br <- geojson_read("https://raw.githubusercontent.com/yeshancqcq/geotime/master/bedrock.geojson",  what = "sp")
    br_s <- subset(br, age_max >= x)
    br_ss <- subset(br_s, age_min <= x )
    
    if(range == "partial"){
      br_s <- subset(br, age_max >= x)
      br_ss <- subset(br_s, age_min <= y )
    } else {
      br_s <- subset(br, age_max >= y)
      br_ss <- subset(br_s, age_min <= x )
    }
    
    par(mar=c(0,0,0,0))
    sp::plot(br, col="grey70",border=NA)
    sp::plot(br_ss, col="#d9d4b4", border=NA, add = T)
  } 
}