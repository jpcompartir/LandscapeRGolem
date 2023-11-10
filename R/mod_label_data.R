#' labelled_data UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_label_data_ui <- function(id) {
  ns <- NS(id)
  tagList(
    shinyWidgets::useSweetAlert(),
    shiny::fluidRow(
      shiny::column(3,
                    offset = 0,
                    style = "padding-left: 20px; padding-right: 10px;",
                    shiny::tags$div(
                      style = "display: flex; align-items: center;",
                      shiny::uiOutput(ns("labelSelection")),
                      shiny::uiOutput(ns("labelButton"))
                    ),
      )
    ),
    shiny::fluidRow(
      DT::dataTableOutput(outputId = ns("labelledDT"))
    )
  )
}

#' labelled_data Server Functions
#'
#' @noRd
mod_label_data_server <- function(id, r,
                                  reactive_dataframe) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    shiny::observeEvent(input$labelNow,{
      if(input$labelText != ""){
        shinyWidgets::sendSweetAlert(
          btn_colors = "#ff7518",
          session = session,
          title = "Success!",
          text = "Data labelled, visit the lablled data tab",
          type = "primary"
        )
      } else {
        shinyWidgets::sendSweetAlert(
          btn_colors = "red",
          session = session,
          title = "Error!",
          text = "Tried to label with empty string, input text first!"
        )
      }

    })

    shiny::observeEvent(input$labelNow, {
      # Here we want to check if there are already some labels in r, and if there aren't, we'll replicate the label one for as many times as there are label_ids. This isn't necessary the first time as the vector would be recycled, but it is necessary the second time.
      # If we already have some labels, then we repeat the same thing before concatenating and updating reactiveValues
      if(input$labelText != ""){
        if (length(r$labels) == 0) {
          label_ids <- r$selected_range
          reps <- length(label_ids)
          labels <- rep(x = input$labelText, reps)
          r$label_ids <- label_ids
          r$labels <- labels
        } else {
          label_ids <- r$selected_range
          reps <- length(label_ids)
          labels <- rep(x = input$labelText, reps)
          r$labels <- c(r$labels, labels)
          r$label_ids <- c(r$label_ids, label_ids)
        }
      }
    })

    # Make label button disappear when nothing selected
    output$labelSelection <- shiny::renderUI({
      if (length(r$selected_range)> 0) {
        shiny::tagList(
          shiny::textInput(
            inputId = ns("labelText"),
            label = "Label Selection",
            value = "",
            placeholder = "write your label here"
          )
        )
      }
    })

    output$labelButton <- shiny::renderUI({
      if (length(r$selected_range) > 0) {
        shiny::actionButton(
          inputId = ns("labelNow"),
          label = "Label",
          class = "btn-label",
          icon = shiny::icon("check") # ,
          # style = "margin-top: 10px; margin-left: 5px;"
        )
      }
    })
  })
}

## To be copied in the UI
# mod_labelled_data_ui("labelled_data_1")

## To be copied in the server
# mod_labelled_data_server("labelled_data_1")
