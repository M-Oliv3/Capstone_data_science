library(shiny)
library(shinyFiles)


shinyUI(fluidPage(
        
        
        tags$head(
                tags$style(HTML("
                                
                                .selectize-input {
                                height: 50px;
                                width: 600px;
                                font-size: 30pt;
                                padding-top: 5px;
                                }
                                
                                "))
                ),
        # Application title
        titlePanel("Autocomplete - Predictions"),
        sidebarPanel(
                tags$a(href="https://github.com/M-Oliv3/Capstone_data_science", 
                       "source code on Github")
                
                
        ),
        
        
        
        mainPanel(
                plotOutput('plot'),
                textAreaInput("caption", "Text", "Write here", width = "500px"),
                verbatimTextOutput("value"),
                uiOutput("state")
        )
                )
                )
