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
n <- nrow(volcano)
signal <- 20*(sin(2*pi*(1:n)/15)) +30*(sin(2*pi*(1:n)/10))
plot(signal,type='l')
image(volcano)
image((volcano+signal))
#plot fourier transform
plotFF(volcano+signal)
#apply pie slice filter
rFF <- imageFF(volcano+signal,d = 90,l = 0.5,t = 5,lwl_buf=T,bd=0.025)
image(volcano)
image(rFF)
hist(((rFF-data)/data)[])
plot(volcano,rFF)


```



