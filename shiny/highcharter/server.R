library(shiny)

shinyServer(function(input, output, session) {

    prices <- reactive({

        ## get real-time price data
        library(binancer)
        eth <- binance_klines(paste0(input$symbol, 'USDT'), interval = '1d')

        ## convert to xts object
        library(xts)
        xts(eth[, .(open, high, low, close, volume)], order.by = eth$close_time)

    })

    output$plot <- renderHighchart({
        library(highcharter)
        hc_add_series(highchart(type = "stock"), prices())
    })

})
