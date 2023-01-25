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

  )
}

#' distribution_tab Server Functions
#'
#' @noRd
mod_distribution_tab_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

  })
}

## To be copied in the UI
# mod_distribution_tab_ui("distribution_tab_1")

## To be copied in the server
# mod_distribution_tab_server("distribution_tab_1")
