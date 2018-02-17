library(shiny)
library(highcharter)

fluidPage(
    titlePanel("The great BTC & ETH analysis engine"),
    sidebarLayout(
        sidebarPanel(
            selectInput('symbol', 'Symbol', c('ETH', 'BTC')),
            selectInput('interval', 'Interval', binancer:::BINANCE$INTERVALS)
        ),
        mainPanel(highchartOutput('plot'))
    )
)
