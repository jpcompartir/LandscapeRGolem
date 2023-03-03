#' distribution_tab UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_distribution_tab_ui <- function(id){
  ns <- NS(id)
  tagList(
    shiny::titlePanel(title = "Volume Over Time"),
    mod_volume_over_time_ui(id = ns("volumeModule")),
    shiny::titlePanel(title = "Sentiment Over Time"),
    mod_sent_time_ui(id = ns("sentTimeModule")),
    shiny::titlePanel(title = "Sentiment Distribution"),
    mod_sentiment_ui(ns("sentimentModule")),
    shiny::titlePanel(title = "Top Tokens"),
    mod_token_plot_ui(id = ns("tokenModule"))
  )
}

#' distribution_tab Server Functions
#'
#' @noRd
mod_distribution_tab_server <- function(id, highlighted_dataframe){
  moduleServer(id, function(input, output, session){
    ns <- session$ns

    mod_volume_over_time_server(id = "volumeModule", highlighted_dataframe = highlighted_dataframe)

  mod_sentiment_server("sentimentModule", highlighted_dataframe = highlighted_dataframe)

  mod_token_plot_server("tokenModule", highlighted_dataframe = highlighted_dataframe)

  mod_sent_time_server("sentTimeModule", highlighted_dataframe = highlighted_dataframe)

  })
}

## To be copied in the UI
# mod_distribution_tab_ui("distribution_tab_1")

## To be copied in the server
# mod_distribution_tab_server("distribution_tab_1")
