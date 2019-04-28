# Load packages -----------------------------------------------------

library(tidyverse)
library(ggplot2)
library(shiny)

# Load data ---------------------------------------------------------
# Replace with `read.csv` or `read_csv` (tidyverse)
movies <- read.csv("workplease.csv", header = TRUE)
str(movies) # CLEAN THE DATA (COMBINE LEVELS, MAKE VAR NUMERIC)
movies = movies[1:200,]


# Shiny App ---------------------------------------------------------


ui <- fluidPage(
  # Sidebar layout with a input and output definitions
  sidebarLayout(
    
    # Inputs: Select variables to plot
    sidebarPanel(
      
      # Select variable for y-axis
      selectInput(inputId = "y", 
                  label = "Y-axis:",
                  choices = c("DECISION_DATE", "CASE_RECEIVED_DATE", "EMPLOYER_NAME", 
                              "EMPLOYER_STATE", "JOB_INFO_EDUCATION"), 
                  selected = "DECISION_DATE"),
      
      # Select variable for x-axis
      selectInput(inputId = "x", 
                  label = "X-axis:",
                  choices = "CASE_STATUS", 
                  selected = "CASE_STATUS")
    ),
    
    # Output: Show scatterplot
    mainPanel(
      plotOutput(outputId = "scatterplot")
    )
  )
)

server <- function(input, output, session) {
  
  # Create scatterplot object the plotOutput function is expecting
  observeEvent(input$y, {
    output$scatterplot <- renderPlot({
      ggplot(data = movies, aes_string(x = input$y, fill = input$x)) + geom_bar()
    })
  })
}

shinyApp(ui = ui, server = server)
