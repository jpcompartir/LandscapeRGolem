#' token_plot UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_token_plot_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' token_plot Server Functions
#'
#' @noRd 
mod_token_plot_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_token_plot_ui("token_plot_1")
    
## To be copied in the server
# mod_token_plot_server("token_plot_1")
