library(shiny)

shinyUI(fluidPage(
    titlePanel("Predict Horsepower from MPG"),
    sidebarLayout(
        sidebarPanel(
            h3("Using full dataset"),
            br(),
            sliderInput("sliderMPG", "What is the MPG of the car?", 10, 35, value = 20),
            checkboxInput("showModel1", "Show/Hide Model 1", value = TRUE),
            checkboxInput("showModel2", "Show/Hide Model 2", value = TRUE),
            textInput("box1", "Enter comments here:", value = "Comments"),
            br(),
            h3("Using part of dataset"),
            br(),
            h4("Slope:"),
            textOutput("slopeOut"),
            h4("Intercept:"),
            textOutput("intOut"),
            br(),
            h3("Apply settings"),
            submitButton("Apply")
        ),
        mainPanel(
            tabsetPanel(type = "tabs",
                        tabPanel("Using full dataset",
                                 h3("Plot of models"),
                                 plotOutput("plot1"),
                                 h4("Predicted Horsepower from Model 1:"),
                                 textOutput("pred1"),
                                 h4("Predicted Horsepower from Model 2:"),
                                 textOutput("pred2"),
                                 h3("Comments"),
                                 textOutput("comment1")
                                 ),
                        tabPanel("Using part of dataset",
                                 h3("Plot"),
                                 plotOutput("plot2", brush = brushOpts(
                                     id = "brush1"
                                 ))
                                 )
                        )
        )
    )
))
