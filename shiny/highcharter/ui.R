library(shiny)
library(highcharter)

fluidPage(
    titlePanel("The great ETH analysis engine"),
    sidebarLayout(
        sidebarPanel(
            selectInput('symbol', 'Symbol', c('ETH', 'BTC'))
        ),
        mainPanel(highchartOutput('plot'))
    )
)
