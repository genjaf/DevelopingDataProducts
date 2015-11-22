library(HistData)
data("GaltonFamilies")
daughters <- GaltonFamilies$childHeight[GaltonFamilies$gender=="female"]
sons <- GaltonFamilies$childHeight[GaltonFamilies$gender=="male"]

shinyServer(
  function(input, output){
    model <- reactive({
      if(input$model == "Multiplicative"){
        1
      }
      else{
        2
      }
    })
    factor <- reactive({as.numeric(input$constant)})
    output$oid1 <- reactive({
      if(model()==1){
        paste0("[male height equivalent] = ", 1.07 + 0.02*factor(), " * [female height]")
      }
      else{
        paste0("[male height equivalent] = ", 4.91 + 0.4*factor(), " in + [female height]")
      }
    })
    lmodel <- reactive({
      if(model()==1){
        parent <- 0.5*GaltonFamilies$father + 0.5*(1.07 + 0.02*factor())*GaltonFamilies$mother
        child <- GaltonFamilies$childHeight
        child[GaltonFamilies$gender=="female"] <- (1.07 + 0.02*factor())*GaltonFamilies$childHeight[GaltonFamilies$gender=="female"]
        lm(child~parent)
      }
      else{
        parent <- 0.5*GaltonFamilies$father + 0.5*(GaltonFamilies$mother + 4.91 + 0.4*factor())
        child <- GaltonFamilies$childHeight
        child[GaltonFamilies$gender=="female"] <- GaltonFamilies$childHeight[GaltonFamilies$gender=="female"] + 4.91 + 0.4*factor()
        lm(child~parent)
      }
    })
    output$oid2 <- renderPlot({
      if(model()==1){
        parent <- 0.5*GaltonFamilies$father + 0.5*(1.07 + 0.02*factor())*GaltonFamilies$mother
        child <- GaltonFamilies$childHeight
        child[GaltonFamilies$gender=="female"] <- (1.07 + 0.02*factor())*GaltonFamilies$childHeight[GaltonFamilies$gender=="female"]
        plot(child~parent,col=4)
        abline(reg=lmodel(),col=2)
        text(71, 60, paste("[child] = ", round(coef(lmodel())[1],2), " + ", round(coef(lmodel())[2],2), "*[parent]"), adj=c(0,0))
      }
      else{
        parent <- 0.5*GaltonFamilies$father + 0.5*(GaltonFamilies$mother + 4.91 + 0.4*factor())
        child <- GaltonFamilies$childHeight
        child[GaltonFamilies$gender=="female"] <- GaltonFamilies$childHeight[GaltonFamilies$gender=="female"] + 4.91 + 0.4*factor()
        plot(child~parent,col=4)
        abline(reg=lmodel(),col=2)
        text(71, 60, paste("[child] = ", round(coef(lmodel())[1],2), " + ", round(coef(lmodel())[2],2), "*[parent]"), adj=c(0,0))
      }
    })
    output$oid3 <- renderPlot({
      plot(lmodel(),1)
      text(71, 10, paste("R-squared = ", round(summary(lmodel())$r.squared,4)), adj=c(0,0))
    })
  }
)