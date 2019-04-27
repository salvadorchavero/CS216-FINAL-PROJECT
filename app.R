#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(ggplot2)
library(dplyr)
library(tidyverse)
library(broom)
library(knitr)
library(shiny)
y15 <- read.csv("PERM_Disclosure_Data_FY15_Q4.csv", header = TRUE)

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Old Faithful Geyser Data"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel("hi guys"),
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("distPlot")
      )
      
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
   output$distPlot <- renderPlot({
     y15 %>% distinct(CASE_STATUS)
     y15 <- y15 %>%
       mutate(CASE_STATUS = case_when(
         CASE_STATUS == "DENIED" ~ "Denied",
         CASE_STATUS == "CERTIFIED" ~ "Certified",
         CASE_STATUS == "CERTIFIED-EXPIRED" ~ "Certified-Expired",
         CASE_STATUS == "WITHDRAWN" ~ "Withdrawn",
         TRUE ~ CASE_STATUS
       ))
     
     # Add binary var for certified/not certified
     y15 <- y15 %>%
       filter(!is.na(CASE_STATUS)) %>%
       mutate(CERT = case_when(
         CASE_STATUS %in% c("Certified", "Certified-Expired") ~ "Certified",
         CASE_STATUS == "Denied" ~ "Not Certified",
         TRUE ~ NA_character_
       ))
     
     y15_country <- y15 %>%
       # Filter N/A Certs
       filter(!is.na(CERT)) %>%
       group_by(COUNTRY_OF_CITIZENSHIP) %>%
       count(CERT) %>%
       mutate(prop = n / sum(n)) %>%
       # Don't count incomplete data 
       filter(!is.na(COUNTRY_OF_CITIZENSHIP))
     
     # Compute overall average of accepted applicants
     prop_accepted <- y15 %>%
       count(CERT) %>%
       mutate(prop_accepted = n / sum(n)) %>%
       filter(CERT == "Certified") %>%
       pull(prop_accepted)
     
     # Top 10 proportion of countries w/ > 500 applicants
     y15_country %>%
       filter(sum(n) > 500) %>%
       filter(CERT == "Certified") %>%
       arrange(desc(prop)) %>%
       head(10) %>%
       ggplot(aes(x = reorder(COUNTRY_OF_CITIZENSHIP, prop), 
                  y = prop)) +
       geom_bar(stat = "identity") +
       geom_hline(aes(yintercept = prop_accepted,
                      colour = "Average Prop"),
                  linetype = "dashed", show.legend = TRUE) +
       guides(colour = guide_legend(title = NULL)) +
       coord_flip() +
       labs(title = "Countries with Top 10 Acceptance Rate for Permanent Workers, 2008 - 2019",
            subtitle = "For countries n > 500",
            x = "Country",
            y = "Proportion of Certified Applicants")
     
     # Bottom 10 proportion of countries w/ > 500 applicants
     y15_country %>%
       filter(sum(n) > 500) %>%
       filter(CERT == "Certified") %>%
       arrange(prop) %>%
       head(10) %>%
       ggplot(aes(x = reorder(COUNTRY_OF_CITIZENSHIP, -prop), 
                  y = prop)) +
       geom_bar(stat = "identity") +
       geom_hline(aes(yintercept = prop_accepted,
                      colour = "Average Prop"),
                  linetype = "dashed", show.legend = TRUE) +
       guides(colour = guide_legend(title = NULL)) +
       coord_flip() +
       labs(title = "Countries with Bottom 10 Acceptance Rate for Permanent Workers, 2008 - 2019",
            subtitle = "For countries n > 500",
            x = "Country",
            y = "Proportion of Certified Applicants")
     
     y15_country %>%
       filter(CERT == "Certified") %>%
       ggplot(aes(x = prop)) +
       geom_histogram() +
       geom_vline(aes(fill = "Average Prop."),
                  xintercept = prop_accepted,
                  colour = "red",
                  linetype = "dashed") +
       labs(title = "Distribution of Permanent Worker Acceptance Rates",
            subtitle = "All countries, 2008 - 2019",
            x = "Proportion Accepted",
            y = "Number of Countries")
   }
     
   )
     
}

# Run the application 
shinyApp(ui = ui, server = server)

