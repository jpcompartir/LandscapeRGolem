#' delete_data UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_delete_data_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' delete_data Server Functions
#'
#' @noRd 
mod_delete_data_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_delete_data_ui("delete_data_1")
    
## To be copied in the server
# mod_delete_data_server("delete_data_1")
