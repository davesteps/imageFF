# imageFF

Functions for applying 'pie-slice' filters to fourier transforms of images. 

I wrote the functions to remove stripe noise from acoustic data, in the spirit of this paper:


[Example app](http://davesteps.shinyapps.io/marine_data_explorer/)


----
###install:

If you don't have devtools install it and then the package from github:



----
###Usage:
```r
require(imageFF)
require(raster)
r <- raster(ncols=36, nrows=18)
r[] <- 1:ncell(r)
plot(r)
```



