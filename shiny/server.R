require(shiny)
require(raster)
require(imageFF)

r1 <- raster(system.file("external/rlogo.grd", package="raster")) 
plot(r1)

plotFF(r1)

rFF <- imageFF(r1,d = 45,l = 0.8,t = 10)

plot(rFF)

shinyServer(function(input, output, session) {
  output$uppercase <- renderText({
    toupper(input$message)
  })
})