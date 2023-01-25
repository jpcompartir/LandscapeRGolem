#' data_table UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_data_table_ui <- function(id){
  ns <- NS(id)
  tagList(
    shiny::column(5, shinycssloaders::withSpinner(DT::dataTableOutput("highlightedTable")))

  )
}

#' data_table Server Functions
#'
#' @noRd
mod_data_table_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

  })
}

## To be copied in the UI
# mod_data_table_ui("data_table_1")

## To be copied in the server
# mod_data_table_server("data_table_1")
