

.getcoord <- function (data){
  geocoord <- data.frame(lon = data$lon, 
                         lat = data$lat,
                         value = data$value)
  return(geocoord)
}
.getmarine <-function(marine_color,land_color,...){
  par(mar=c(0,0,0,2),...)
  map(type='n',add=T,...)
  rect(par("usr")[1], par("usr")[3], par("usr")[2], par("usr") [4], col = marine_color)
  map(boundary = F, col=land_color,fill=T,add=T,...)
}

.make_raster<-function(coord_use,res,land_color,marine_color,stat,...){
  df_view<-map(plot=F,...)
  view_frame<-extent(df_view$range)
  raster_data<-raster(view_frame)
  res(raster_data)<-c(res,res)
  values(raster_data)<-NA
  raster_data<-rasterize(coord_use[,1:2],raster_data,coord_use[,3],fun=stat)
  return(raster_data)
}


#' The zonal_stats function
#'
#' This function allows you to do zonal statistics of a point dataset
#' @param data The input dataframe. It should contain 3 columns: lat, lon, and value
#' @param res The resolution (grid size) of the zonal statistics. Default is 13. The larger the value, the coarser the grid.
#' @param land_color The color for the land area in the map (optional)
#' @param marine_color The color for the ocean area in the map (optional)
#' @param color_ramp A list of 2 colors indicating the color ramp of the map (for the lowest and highest values. optional)
#' @param label The label for the map legend. Default is "records"
#' @param level The number of color classes in the map. Default is 10
#' @param map Whether to plot the map. Default is TRUE
#' @param stat The type of zonal statistics. Default is sum. Other available options are min, max, mean, median, var, and sd
#' @keywords zonal statistics
#' @export 
#' @examples
#' zonal_stats(data, land_color="tan", marine_color="light blue", color_ramp=c("pink","red"), res= 20, level = 15, label = "value", stat=min)


zonal_stats <- function(data, 
                        res=13,
                        land_color="tan", 
                        marine_color="light blue",
                        color_ramp=c("pink","red"), 
                        label = "records", 
                        level = 10, 
                        map=T, 
                        stat=sum, ...){
  if (sum((colnames(data) %in% c("lat","lon")))!=2){
    stop("Invalid input data. check the instruction please.")
  }
  
  coord_use <- .getcoord(data)
  raster_data<-.make_raster(coord_use,res,land_color,marine_color,stat,...)
  if(map==T){
    par(oma=c(0,0,0,2),...)
    df_view<-map(type="n",...)
    view_frame<-extent(df_view$range)
    new_raster<-raster(view_frame)
    res(new_raster)<-c(res,res)
    values(new_raster)<-NA
    sp::plot(new_raster,xaxt="n",yaxt="n")
    .getmarine (marine_color,land_color,...)
    map(col=land_color,fill=T,add=T,...)
    Pal <- colorRampPalette(color_ramp)
    sp::plot(raster_data,col=alpha(Pal(level),0.8),add=T,...)
    mtext(label,4,line=0,cex=1.4)}
  return(raster_data)
}
