## @tmasjc
## this Shiny app served as a skeleton for Alluvial diagram

library(shiny)
library(shinythemes)
library(dplyr)
library(highcharter)

raw <- readRDS("data.rds")
dat <- raw |> 
    as_tibble() |> 
    select(
        term,
        goal_channel_type,
        user_group,
        sku,
        goal_operation_group,
        goal_class_tag,
        renewal_counselor_group_city
    )

ui <- fluidPage(
    theme = shinytheme("yeti"),
    fluidRow(
        column(12, selectInput("termSelect", "Term", 
                               unique(dat$term))),
        highchartOutput("hc"))
    )

server <- function(input, output) {
    
    dataInput <- reactive({
        dat |> 
            filter(term == input$termSelect) |> 
            select(-term) # drop
    })
    
    output$hc <- renderHighchart({
        dataInput() |>
            data_to_sankey() |>
            hchart("sankey", name = "diamonds") |> 
            hc_add_theme(hc_theme_null())
    })
}

shinyApp(ui = ui, server = server)
