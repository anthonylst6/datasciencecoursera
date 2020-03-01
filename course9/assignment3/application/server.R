library(shiny)
data <- read.csv("data.csv", check.names = FALSE)

shinyServer(
    function(input, output) {
        output$plot <- renderPlotly({
            x <- data[[input$pred]]
            y <- data[[input$resp]]
            LGA <- data[["LGA"]]
            df <- data.frame(x, y, LGA)
            g <- ggplot(df, aes(x = x, y = y, z = LGA)) + geom_point(alpha = 0.4) + 
                geom_smooth(mapping = aes(x = x, y = y), formula = y ~ x, method = "lm", inherit.aes = FALSE) +
                labs(x = input$pred, y = input$resp)
            ggplotly(g)
        })
        output$sum <- renderPrint({
            model <- lm(data[[input$resp]] ~ data[[input$pred]])
            summary(model)
        })
    }
)