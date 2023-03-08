#' labelled_tag UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_labelled_tag_ui <- function(id){
  ns <- NS(id)
  tagList(
    #Module which will be called by app.ui to render the data processed by mod_label_data

  )
}

#' labelled_tag Server Functions
#'
#' @noRd
mod_labelled_tag_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

  })
}

## To be copied in the UI
# mod_labelled_tag_ui("labelled_tag_1")

## To be copied in the server
# mod_labelled_tag_server("labelled_tag_1")
