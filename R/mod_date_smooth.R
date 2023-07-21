#' date_smooth UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_date_smooth_ui <- function(id) {
  ns <- NS(id)
  tagList(
    shiny::selectInput(
      inputId = ns("dateSmooth"), label = "Smooth",
      choices = c("none", "loess", "lm", "glm", "gam"),
      selected = "none"
    ),
    shiny::uiOutput(outputId = ns("smoothControls"))
  )
}

#' date_smooth Server Functions
#'
#' @noRd
mod_date_smooth_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # Volume plot smooth controls
    output$smoothControls <- shiny::renderUI({
      if (input$dateSmooth != "none") {
        shiny::tagList(
          shiny::selectInput(
            ns("smoothSe"),
            "show standard error?",
            choices = c("TRUE", "FALSE"),
            selected = "TRUE"
          ),
          shiny::textInput(ns("smoothColour"), "Smooth colour", value = "#000000")
        )
      }
    })
  })
}

## To be copied in the UI
# mod_date_smooth_ui("date_smooth_1")

## To be copied in the server
# mod_date_smooth_server("date_smooth_1")

# Not clear this should be a module tbh
