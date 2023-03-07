#' download_data UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_download_data_ui <- function(id, label){
  ns <- NS(id)
  tagList(
    shiny::column(2, shiny::textInput(ns("fileName"), label, value = NULL, placeholder = "filename excluding .csv")),
    shiny::column(2, shiny::div(
      style = "margin-top: 25px;",
      shiny::downloadButton(ns("download"),
                            "Download",
                            class = "btn btn-warning"
      )
    ))
  )
}

#' download_data Server Functions
#'
#' @noRd
mod_download_data_server <- function(id, data_object){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    output$download <- shiny::downloadHandler(
      filename = function() {
        paste0(input$fileName, ".csv")
      },
      content = function(file) {
        utils::write.csv(data_object(), file)
      }
    )
  })
}

## To be copied in the UI
# mod_download_data_ui("download_data_1")

## To be copied in the server
# mod_download_data_server("download_data_1")
