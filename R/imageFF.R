require(raster)


plotFF <- function(r,returnFF=F){
  #r <- bs
  if(class(r)=='RasterLayer'){r <- as.matrix(r)}
  rm <- r
  
  rm[is.na(r)] <- median(rm,na.rm=T)
  
  ft <- fft(rm)
  
  mag <- Mod(ft)
  phase <- Arg(ft)
  
  fts <- swap.quadrant(mag)
  
  ftf <- log(fts)
  ftr <- raster(ftf)
  
  #plot(r)
  plot(ftr)
  
  #if(returnFF==T){return(ftr)}
  
}

imageFF <- function(r,d,l,t,lwl_buf=F,bd=0.1){
  #l <- 0.3#length of slice
  #d <- 45#major direction
  #t <- 6#taper window
  #lwl_buf=T
  #bd=0.01
  #r <- raster(nrows=241, ncols=241)
  #r[] <- 1:ncell(r)
  
  if(class(r)== "RasterLayer"){rm <- as.matrix(r) 
  } else{rm <- r}
  
  #if(nrow(r)%%2==1){
  #  rm <- rbind(rm,rep(NA,ncol(rm)))}
  #if(ncol(r)%%2==1){
  #  rm <- cbind(rm,rep(NA,nrow(rm)))}
  nai <- is.na(rm)
  rm.m <- mean(rm,na.rm=T)
  rm.sd <- sd(as.vector(rm),na.rm=T)
  
  rm[nai] <- rnorm(length(rm[nai]),rm.m,sd=rm.sd)
  
  #rm[nai] <- median(rm,na.rm=T)
  #rm[nai] <- mean(rm,na.rm=T)
  
  
  ft <- fft(rm)
  
  mag <- Mod(ft)
  phase <- Arg(ft)
  
  fts <- swap.quadrant(mag)
  
  ftf <- log(fts)
  ftr <- raster(ftf)
  
  extent(ftr)<- extent(c(-0.5,0.5,-0.5,0.5))
  #pie_slice <- function(l,d,t)
  
  d1 <- deg.t.rad(d-(t/2))
  d2 <- deg.t.rad(d+(t/2))
  
  x1 = l*cos(d1)
  y1 = l*sin(d1)
  x2 = l*cos(d2)
  y2 = l*sin(d2)
  
  plot(ftr)
  #points(x1,y1)
  #points(-x1,-y1)
  #points(x2,y2)
  #points(-x2,-y2)
  
  crds <- cbind(c(0,x1,x2,0,-x1,-x2,0),c(0,y1,y2,0,-y1,-y2,0))
  
  p <- Polygons(list(Polygon(crds)),0)
  sp <- SpatialPolygons(list(p))
  plot(sp,add=T)
  
  if(lwl_buf==T){
    require(rgeos)
    p <- SpatialPoints(cbind(0,0))
    pb <- gBuffer(p,width=bd)
    plot(pb,add=T)
    sp <- gDifference(spgeom1=sp,spgeom2=pb)
    plot(sp,add=T)  
  }
  
  PS <- rasterize(sp,ftr)
  APS <- merge(PS,ftr)
  plot(APS)
  APSm <- as.matrix(APS)
  APSms <- swap.quadrant(APSm)
  mp <- matrix(complex(modulus=exp(APSms),argument=phase),nrow=nrow(APSm),ncol=ncol(APSm))
  fftinv <- fft(mp,inverse=T)/length(mp)
  #APSr <- raster(Mod(fftinv))
  modfft <- Mod(fftinv)
  modfft[nai] <- NA
  #modfft
  
  #if(nrow(r)%%2==1){modfft <- modfft[1:nrow(r),]}
  #if(ncol(r)%%2==1){modfft <- modfft[,1:ncol(r)]}
  
  if(class(r)== "RasterLayer"){
    modfft <- raster(modfft) 
    extent(modfft) <- extent(r)
    projection(modfft) <- projection(r)}
  
  modfft
  
}



swap.quadrant <- function(ft){
  fts <- ft
  Y <- nrow(ft) 
  y <- Y/2
  X <- ncol(ft)
  x <- X/2
  fts[1:y,1:x] <- ft[(y+1):Y,(x+1):X] 
  fts[1:y,(x+1):X] <- ft[(y+1):Y,1:x]
  fts[(y+1):Y,1:x] <- ft[1:y,(x+1):X]
  fts[(y+1):Y,(x+1):X] <- ft[1:y,1:x]
  return(fts)}

rad.t.deg <- function(x){(180/pi)*x}
deg.t.rad <- function(x){(pi/180)*x}