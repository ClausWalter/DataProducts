#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(plotly)
library(shiny)
library(ggplot2)
library(dplyr)
data(mtcars)

# Server logic

shinyServer(function(input, output) {

# Reactive data determination for calculating plots and data
    mtcars$cyl <- as.factor(mtcars$cyl)

  # Unfotunately, it seems each reactive data set can be used only by exact
  # one output component (e.g. plots), hence the multiplication of creating
  # several reactive sets of data below:
    
    # Data set for tab 1:
    dataset_1 <- reactive({
            cylinder<-switch(input$cylinder,
                        four = c("4"),
                        six = c("6"),
                        eight = c("8"),
                        all = c("4","6", "8"))
            transmission <-switch(input$transmission,
                        automatic = c("0"),
                        manual = c("1"),
                        automaticAndManual = c("0", "1"))
            x<-subset(mtcars, ((mpg<=input$mpg) & 
                        (cyl %in% cylinder) & 
                        (am %in% transmission)
                        )
                      )
    })
    
    # Data set for tab 2:
    dataset_2 <- dataset_1
    
    # Data set for tab 3:
    dataset_3 <- dataset_2
    
    # Data set for tab 4, which is selective list output with calculated values
    # Here, I could not re-use the above datasets, since for cutting down
    # the columns, it seems it needs to re-derive the original data.
    dataset_summary <- reactive({
        cylinder<-switch(input$cylinder,
                        four = c("4"),
                        six = c("6"),
                        eight = c("8"),
                        all = c("4","6", "8"))
        transmission<-switch(input$transmission,
                        automatic = c("0"),
                        manual = c("1"),
                        automaticAndManual = c("0", "1"))
        x<-subset(mtcars, ((mpg<=input$mpg) & 
                           (cyl %in% cylinder) & 
                           (am %in% transmission)
                          )
                  )
        x<-x[,c(1, 3:7)]
    })

# Output definition section:
  # Tab 1 processing - 2D scatter plot MPG vs. Weight  
    output$plot_1 <- renderPlotly({
            p <- ggplot(dataset_1(), aes(x = wt, y = mpg, size = hp, color = cyl)) + 
                    geom_point() + labs(color = "Cylinders")
    })
    
    output$hover_1 <- renderPrint({
            d <- event_data("plotly_hover")
            if (is.null(d)) "Hover events appear here (unhover to clear)" else d
    })
    
    output$click_1 <- renderPrint({
            d <- event_data("plotly_click")
            if (is.null(d)) "Click events appear here (double-click to clear)" else d
    })
    # Tab 2 processing - 2D scatter plot MPG vs. Displacement 
    output$plot_2 <- renderPlotly({
            p <- ggplot(dataset_2(), aes(x = disp, y = mpg, color = cyl, size = hp)) + 
                    geom_point() + labs(color = "Cylinders")
    })
    
    output$hover_2 <- renderPrint({
            d <- event_data("plotly_hover")
            if (is.null(d)) "Hover events appear here (unhover to clear)" else d
    })
    
    output$click_2 <- renderPrint({
            d <- event_data("plotly_click")
            if (is.null(d)) "Click events appear here (double-click to clear)" else d
    })

    
    # Tab 3 processing - Data for list of cars
    output$filteredData = renderDataTable({
            t<-dataset_3()
    })  
    
    # Tab 4 processing - Stats for selected cars
    output$summary = renderDataTable({
            d<-summary(dataset_summary())
       })
    
    # Tab 5 processing - 3D scatter plot MPG vs. Displacement and Weight Full Data   
    output$plot_3 <- renderPlotly({
            plot_ly(mtcars, x = mtcars$wt, y = mtcars$mpg, z = mtcars$disp, type = "scatter3d", 
                    mode= "markers", color = as.factor(mtcars$cyl), size = mtcars$hp) %>%
                    layout(title="WT and Disp. to MPG",
                           scene=list(
                                   xaxis=list(title="Weight"),
                                   yaxis=list(title="MPG"),
                                   zaxis=list(title="Disp.")))
    })
    output$hover_3 <- renderPrint({
            d <- event_data("plotly_hover")
            if (is.null(d)) "Hover events appear here (unhover to clear)" else d
    })
    
    output$click_3 <- renderPrint({
            d <- event_data("plotly_click")
            if (is.null(d)) "Click events appear here (double-click to clear)" else d
    })
   
})
