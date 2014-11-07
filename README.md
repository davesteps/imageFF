# imageFF

Functions for applying 'pie-slice' filters to fourier transforms of images. 

I wrote the functions to remove stripe noise from acoustic data, in the spirit of this paper:


[Application of 2D Fourier filtering for elimination of stripe noise in side-scan sonar mosaics](http://www.springerlink.com/content/148r550r21342123/)


----
###install:

If you don't have devtools install it, then the package from github:
```r

if (!require("devtools"))
  install.packages("devtools")
devtools::install_github("imageFF", "davesteps")
```

----
###Usage:
```r
require(imageFF)
require(raster)
r <- raster(ncols=36, nrows=18)
r[] <- 1:ncell(r)
plotFF(r)
```



