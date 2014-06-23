
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)
library(devtools)
library(ggplot2)
library(grid)
library(gridExtra)
library(stats)
library(yaml)

shinyServer(function(input, output) {
   
  #get desired data
  dataInp <- reactive({
    list(intd=mtcars[mtcars$cyl==input$cyl,],
         newwt=data.frame(wt=input$wt))
  })
  #get desired input wt
  
  #give information how many cars are there in the current selection
  output$caption <- renderPrint({   
    cat("No. of cars that exists: ",nrow(dataInp()$intd))
  })
  #return top data
  output$table <- renderTable({
    head(dataInp()$intd,10)    
  })
  #statistical summary of the numerical data
  output$summary<-renderTable({
    summary(dataInp()$intd[,c(1,3:7)])
  })
  #return best performing car
  output$bstp<-renderPrint({
    gti<-which(dataInp()$intd$mpg==max(dataInp()$intd$mpg))
    cat("The best performing car:",rownames(dataInp()$intd[gti,]),
        "\nThe miles per gallon: ",dataInp()$intd[gti,1])
    if(dataInp()$intd[gti,]$am==0){
      cat("\nTransmission type: Automatic")
    }else{
      cat("\nTransmission type: Mannual")
    }
    
    cat("\nNumber of Gears",dataInp()$intd[gti,]$gear)
  })
  #return highest power car
  output$bsth<-renderPrint({
    gth<-which(dataInp()$intd$hp==max(dataInp()$intd$hp))
    cat("The Highest Power car:",rownames(dataInp()$intd[gth,]),
        "\nHorsePower : ",dataInp()$intd[gth,4])
    if(dataInp()$intd[gth,]$am==0){
      cat("\nTransmission type: Automatic")
    }else{
      cat("\nTransmission type: Mannual")
    }
    
    cat("\nNumber of Gears",dataInp()$intd[gth,]$gear)
  })
  
  #give a regression plot for the horsepower and
  #miles per gallon by weight for current selection
  
  output$gplot<-renderPlot({
    
    p1<- ggplot() +
      # blue plot
      geom_point(data=dataInp()$intd, aes(x=wt, y=mpg)) + 
      geom_smooth(data=dataInp()$intd, aes(x=wt, y=mpg), fill="blue",
                  colour="darkblue", size=1,method="lm") +
      labs(x="Weight in 1000 lbs",y="Miles per US gallon")
    
    
    p2<- ggplot() +      
      # red plot
      geom_point(data=dataInp()$intd, aes(x=wt, y=hp)) + 
      geom_smooth(data=dataInp()$intd, aes(x=wt, y=hp), fill="red",
                  colour="red", size=1,method="lm")+
      labs(x="Weight in 1000 lbs",y="Gross horsepower") 
    
    print(grid.arrange(p1, p2, ncol = 2, 
                       main = "Miles/US Gallon & HorsePower Vs Weight"))
    
  })
  ##Gives desired value based on linear regression model
  output$regrs<-renderPrint({
    nwt<-dataInp()$newwt
    clcmpg<-predict(lm(mpg~wt,data=dataInp()$intd),nwt)
    clchp<-predict(lm(hp~wt,data=dataInp()$intd),nwt)
    cat("For the weight :",as.numeric(nwt)*1000,
        "lbs:\n a>the possible value for miles per gallon:",clcmpg,
        "\n b>the possible value for horsepower:",clchp)
  })
  
})
