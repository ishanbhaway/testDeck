
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#
library(shiny)
library(shinyapps)

shinyUI(pageWithSidebar(
  
  # Application title
  titlePanel("A look at Mtcars data: cylinder and gear"),
  sidebarPanel(
    selectInput(
      "cyl", "Choose no. Cylinders", 
      choices = unique(mtcars$cyl),selected="4"
    ),
    sliderInput("wt", "Enter the weight(in 1000lbs) to predict the value 
              of hp and mpg based on regression:", 
                min=min(mtcars$wt), max=max(mtcars$wt), value=2.5,step=0.005
    ), 
    
    h3("Documentaion"),
    h6("The mtcars data is preloaded."),
    h6("Top Table:Retrieves head values of mtcars dataset
       for selected cylinder number"),
    h6("Stat summary: Gives the statistical analysis of the numeric values
       for selected cylinder number"),
    h6("Best performing car and Highest Power car selects the car with
       highest mpg and highest hp respectively for selected cylinder number"),
    h6("Predicting values by Regression: It predicts based on linear model
       by taking weight from slider input"),
    h6("Performance Graphs: Gives a regression plot for mpg vs wt and hp vs wt"),
    h6("for details on mtcars dataset please refer to the link: "),
    h6(a("mtcars",href="http://stat.ethz.ch/R-manual/R-patched/library/datasets/html/mtcars.html"))
    ),
  
  mainPanel(
    h4(textOutput("caption")),
    tabsetPanel(
      tabPanel("Top Table",tableOutput("table")),
      tabPanel("Stat summary",tableOutput("summary")),
      tabPanel("Best performing Car",verbatimTextOutput("bstp")),
      tabPanel("Highest Power Car",verbatimTextOutput("bsth")),
      tabPanel("Predicting values by Regression",verbatimTextOutput("regrs")),
      tabPanel("Performance Graphs",plotOutput("gplot"))
    )
  )
))
