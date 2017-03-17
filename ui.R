#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(plotly)
library(shiny)
library(ggplot2)
library(htmltools)
library(htmlwidgets)
library(dplyr)
data(mtcars)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Miles per Gallon in Relation to Weight and Displacement"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
        h3("Data Selection"),
       sliderInput("mpg",
                   "MPG range for display:",
                   min = 10,
                   max = 35,
                   value = 35)
        ,
    radioButtons(inputId = "transmission", 
                 label = "Transmission Type:", choices = c(
                        Manual ="manual", 
                        Automatic="automatic", 
                        All="automaticAndManual"), 
                        selected= "automaticAndManual"),
    radioButtons(inputId = "cylinder", 
                 label = "Cylinders:", choices = c(
                        Four ="four", 
                        Six = "six", 
                        Eight="eight",
                        All="all"),
                        selected= "all")),
  

    # Show a plot of the generated distribution
    mainPanel(
            tabsetPanel(type="tabs",
                        tabPanel("MPG vs. Weight", br(), includeHTML("MPGvsWeight.html"), 
                                 plotlyOutput("plot_1"),
                                 verbatimTextOutput("hover_1"),
                                 verbatimTextOutput("click_1")),
                        tabPanel("MPG vs. Disp.", br(), includeHTML("MPGvsDisp.html"), 
                                 plotlyOutput("plot_2"),
                                 verbatimTextOutput("hover_2"),
                                 verbatimTextOutput("click_2")),
                        tabPanel("Selected Cars", includeHTML("selectedCars.html"),
                                 dataTableOutput("filteredData")),
                        tabPanel("Stats for selected Cars", includeHTML("statsForSelectedCars.html"), 
                                 dataTableOutput("summary")),
                        tabPanel("3D Plot - Full Data only", br(), includeHTML("3DPlot.html"),
                                 plotlyOutput("plot_3", 
                                              width = "600px", 
                                              height = "600px"),
                                 verbatimTextOutput("hover_3"),
                                 verbatimTextOutput("click_3")),
                        tabPanel("Documentation", includeHTML("documentation.html"))
   

    )
  )
)))
