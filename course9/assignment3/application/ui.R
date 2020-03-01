library(shiny)
suppressPackageStartupMessages(library(plotly))

shinyUI(fluidPage(
    titlePanel("Exploring relationship between Solar Installations and Demographics in Local Government Areas of Australia"),
    br(),
    sidebarLayout(
        sidebarPanel(
            h3("Linear regression variables"),
            br(),
            radioButtons("resp", "Select response (y-axis):",
                         c("Density of installations (%)" = "Density",
                           "Number of installations" = "Installations",
                           "Total installed capacity (kW)" = "Capacity")),
            br(),
            radioButtons("pred", "Select predictor (x-axis):",
                         c("IRSAD socieoeconomic index" = "IRSAD",
                           "Median Age - Persons (years)",
                           "Population density (persons/km2)",
                           "Total born overseas (%)",
                           "Bachelor Degree (%)",
                           "Completed Year 12 or equivalent (%)"))
        ),
        mainPanel(
            tabsetPanel(type = "tabs",
                        tabPanel(h4("Interactive regression plot"),
                                 plotlyOutput("plot")
                                 ),
                        tabPanel(h4("Summary of linear fit"),
                                 br(),
                                 verbatimTextOutput("sum")),
                        tabPanel(h4("Documentation"),
                                 h3("What the app does"),
                                 "The app performs a simple linear regression of the input response onto the input predictor. It renders an interactive plot showing the linear regression fit line with 95% confidence intervals. Summary statistics on the linear model fit are also displayed in a separate tab. The available responses correspond to metrics on solar installations while the predictors correspond to demographic indicators.",
                                 br(),
                                 h3("How to use the app"),
                                 "1. Select the desired response and predictor using the radio buttons in the interface",
                                 br(),
                                 "2. The plot and summary statistics will automatically update to reflect any changes",
                                 br(),
                                 "3. The user can also switch between viewing the plot or summary statistics by clicking on the appropriate tab",
                                 br(),
                                 "4. Hovering the cursor over the interactive plot will also display each point's predictor and response values along with which local government area (LGA) in Australia this data point corresponds to",
                                 br(),
                                 h3("Description of response and predictor variables"),
                                 "**Density**: percentage of dwellings in a LGA with solar installed",
                                 br(),
                                 "**Installations**: number of solar installations in a LGA",
                                 br(),
                                 "**Capacity**: the total installed solar capacity in a LGA, measured in kilowatts (kW), this represents the cumulative power output of all the installed solar within a LGA",
                                 br(),
                                 "**IRSAD**: the Index of Relative Socio-Economic Advantage and Disadvantage, a non-ordinal index developed by the Australian Bureau of Statistics (ABS) where higher scores indicate socioeconomic advantage",
                                 br(),
                                 "**Median age**: the median age of all people within a LGA, measured in years",
                                 br(),
                                 "**Population density**: the average number of people per square kilometer of land in a LGA",
                                 br(),
                                 "**Total born overseas**: the percentage of people born overseas in a LGA",
                                 br(),
                                 "**Bachelor degree**: the percentage of people who have a Bachelor's degree in a LGA",
                                 br(),
                                 "**Completed Year 12 or equivalent**: the percentage of people who have completed Year 12 or equivalent in a LGA",
                                 h3("References / Data"),
                                 "- Australian PV Institute (APVI) Solar Map, funded by the Australian Renewable Energy Agency, accessed from pv-map.apvi.org.au on 19 February 2020. Dataset can be downloaded fromhttps://pv-map.apvi.org.au/historical#4/-26.67/134.12",
                                 br(),
                                 "- Australian Bureau of Statistics 2020, 'Regional Statistics by LGA 2018, 2011-2018', viewed 26 February 2020, http://stat.data.abs.gov.au."
                                 )
                        )
        )
    )
))