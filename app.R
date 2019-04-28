# Load packages -----------------------------------------------------

library(tidyverse)
library(ggplot2)
library(shiny)

# Load data ---------------------------------------------------------
movies <- read.csv("permanent_edit3.csv", header = TRUE)
str(movies) # CLEAN THE DATA
tolower(movies$EMPLOYER$NAME)
movies = movies[1:200,]

# Shiny App ---------------------------------------------------------


ui <- fluidPage(
  
  titlePanel("Immigration: Insert Better Title Here"),
  
  # Sidebar layout with a input and output definitions
  sidebarLayout(
    
    # Inputs: Select variables to plot
    sidebarPanel(
      strong("Project Members"),p("Ashley Murray, Will Ye, Darryl Yan, Thomas Wang, Salavador Chavero Arellano"), 
      br(),

      # Select variable for y-axis
      selectInput(inputId = "y", 
                  label = "Relationship with Case Status:",
                  choices = c("DECISION_DATE", "CASE_RECEIVED_DATE", 
                              "EMPLOYER_STATE", "JOB_INFO_EDUCATION", "EMPLOYER_NAME", "EMPLOYER_NUM_EMPLOYEES",
                              "PW_SOC_TITLE"), 
                  selected = "DECISION_DATE"),
      # Select variable for x-axis
      selectInput(inputId = "x", 
                  label = "Case Status",
                  choices = "CASE_STATUS", 
                  selected = "CASE_STATUS")
    ),

    # Output: Show the plot
    mainPanel(
      plotOutput(outputId = "scatterplot")
    )
  )
)

server <- function(input, output, session) {
  
  observeEvent(input$y, {
    output$scatterplot <- renderPlot({
      ggplot(data = movies, aes_string(x = input$y, fill = input$x)) + geom_bar()
    })
  })
}

shinyApp(ui = ui, server = server)
