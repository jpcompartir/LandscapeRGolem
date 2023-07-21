#' compare_groups UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_compare_groups_ui <- function(id) {
  ns <- NS(id)
  tagList(
    shiny::titlePanel(title = "Weighted log-odds"),
    mod_wlos_ui(ns("wlosTag")),
    shiny::titlePanel(title = "Group Sentiment"),
    mod_group_sentiment_ui(ns("groupSentimentTag")),
    shiny::titlePanel(title = "Group Volume Over Time"),
    mod_group_vol_time_ui(ns("groupVolTimeTag"))
  ) # nolint
}

#' compare_groups Server Functions
#'
#' @noRd
mod_compare_groups_server <- function(id, highlighted_dataframe) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    mod_wlos_server("wlosTag",
      highlighted_dataframe = highlighted_dataframe
    )

    mod_group_sentiment_server("groupSentimentTag",
      highlighted_dataframe = highlighted_dataframe
    )

    mod_group_vol_time_server("groupVolTimeTag",
      highlighted_dataframe = highlighted_dataframe
    )
  })
}

## To be copied in the UI
# mod_compare_groups_ui("compare_groups_1")

## To be copied in the server
# mod_compare_groups_server("compare_groups_1")
