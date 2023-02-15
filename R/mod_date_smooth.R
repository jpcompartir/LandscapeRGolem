#' date_smooth UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_date_smooth_ui <- function(id){
  ns <- NS(id)
  tagList(
    shiny::selectInput(inputId = "dateSmooth", label = "Smooth",
                       choices = c("none", "loess", "lm", "glm", "gam"),
                       selected = "none"),
    shiny::uiOutput(outputId = "smoothControls")

  )
}

#' date_smooth Server Functions
#'
#' @noRd
mod_date_smooth_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

  })
}

## To be copied in the UI
# mod_date_smooth_ui("date_smooth_1")

## To be copied in the server
# mod_date_smooth_server("date_smooth_1")
