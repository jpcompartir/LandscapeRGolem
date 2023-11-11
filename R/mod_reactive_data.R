golem:#' reactive_data UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_reactive_data_ui <- function(id){
  ns <- NS(id)
  tagList(

  )
}

#' reactive_data Server Functions
#'
#' @noRd
mod_reactive_data_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

  })
}

## To be copied in the UI
# mod_reactive_data_ui("reactive_data_1")

## To be copied in the server
# mod_reactive_data_server("reactive_data_1")
