# quickgeo

This R package can perform quick zonal statistics for point data across a continent or the globe.

The <code>zonal_stat()</code> function can return a raster data file (S4 object) of the statistics result and plot a map for exploratory analysis.

Supported statistics include min, max, median, mean, sum, var, and sd.

Installation:
install_github('yeshancqcq/quickgeo')

If the <code>Error in as.double(y) : cannot coerce type 'S4' to vector of type 'double'
</code> error occurs, update the <code>sp</code> package in R.

Type <code>?zonal_stat </code> in the terminal of RStudio to see descriptions of arguments and the example.
