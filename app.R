## @tmasjc
## this Shiny app served as a skeleton for Alluvial diagram

library(shiny)
library(shinythemes)
library(dplyr)
library(highcharter)

# dummy data
data(diamonds, package = "ggplot2")
diamonds <- 
    diamonds |> 
    mutate(
        abc = sample(
            c("A", "B", "C"),
            replace = TRUE,
            size = nrow(diamonds)))


ui <- fluidPage(
    theme = shinytheme("yeti"),
    fluidRow(
        column(12, selectInput("abc", "Choices", 
                               sort(unique(diamonds$abc)))),
        highchartOutput("hc"))
    )

server <- function(input, output) {
    
    dataInput <- reactive({
        diamonds |> 
            filter(abc == input$abc) |> 
            select(cut, color, clarity)
    })
    
    output$hc <- renderHighchart({
        dataInput() |>
            data_to_sankey() |>
            hchart("sankey", name = "diamonds") |> 
            hc_add_theme(hc_theme_null())
    })
}

shinyApp(ui = ui, server = server)
