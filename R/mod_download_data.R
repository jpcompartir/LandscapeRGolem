#' download_data UI Function
#'
#' @param id link to module's server
#' @param label Element's visible label when app is rendered
#'
#' @description A shiny Module.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_download_data_ui <- function(id, label){
  ns <- NS(id)
  tagList(
    shiny::column(3,
                  shiny::tags$div(
                    style = "display: flex; align-items: center;",
                    shiny::textInput(ns("fileName"),
                                     label,
                                     value = NULL,
                                     placeholder = "filename excluding .csv"),
                    shiny::downloadButton(ns("download"),
                                          "Download",
                                          class = "btn btn-warning btn-download",
                                          style = "margin-bottom: 15px;")
                  )
                  )
    )
}

#' download_data Server Functions
#'
#' @param id link to module's ui
#' @param data_object the object the user will download
#'
#' @noRd
mod_download_data_server <- function(id, data_object){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    output$download <- shiny::downloadHandler(
      filename = function() {
        time <- stringr::str_replace(Sys.time()," ", "_")
        paste0(input$fileName,"_", time, ".csv")
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
