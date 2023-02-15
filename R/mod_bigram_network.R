#' bigram_network UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_bigram_network_ui <- function(id){
  ns <- NS(id)
  tagList(
    shiny::fluidRow(
      shiny::plotOutput(ns("bigramPlot"), width = "450px", height = "450px")
    )
    )
}

#' bigram_network Server Functions
#'
#' @noRd
mod_bigram_network_server <- function(id, highlighted_dataframe){
  moduleServer(id, function(input, output, session){
    ns <- session$ns

    output$bigramPlot <- renderPlot({
      highlighted_dataframe() %>%
        JPackage::make_bigram_viz(text)
      })
  })
}

## To be copied in the UI
# mod_bigram_network_ui("bigram_network_1")

## To be copied in the server
# mod_bigram_network_server("bigram_network_1")
