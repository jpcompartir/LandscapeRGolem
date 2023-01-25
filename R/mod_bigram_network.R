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
 
  )
}
    
#' bigram_network Server Functions
#'
#' @noRd 
mod_bigram_network_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_bigram_network_ui("bigram_network_1")
    
## To be copied in the server
# mod_bigram_network_server("bigram_network_1")
