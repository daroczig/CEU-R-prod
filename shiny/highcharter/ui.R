library(shiny)
library(highcharter)

fluidPage(
    titlePanel("The great ETH analysis engine"),
    sidebarLayout(
        sidebarPanel(),
        mainPanel(highchartOutput('plot'))
    )
)
