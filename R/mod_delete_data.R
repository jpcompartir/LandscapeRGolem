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
    shiny::actionButton(
      ns("delete"),
      "Delete selections",
      class = "btn",
      icon = shiny::icon("trash"),
      style = "background: #ff7518; border-radius: 100px; color: #ffffff; border:none;"
    )
  )
}

#' delete_data Server Functions
#'
#' @noRd
mod_delete_data_server <- function(id, r){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    shiny::observeEvent(plotly::event_data("plotly_selected"), {
      r$selected_range <- plotly::event_data("plotly_selected")$key
    })

    shiny::observeEvent(input$delete, {
      print("remove keys will update")
      r$remove_keys <- r$selected_range
      r$keep_keys <- r$keep_keys[!r$keep_keys %in% r$remove_keys]

      # Clear the values in selected_range()
      r$selected_range <- list()
    })

    #Grey the delete button out when nothing is selected
    observe({
      if(!is.null(r$selected_range) && length(r$selected_range) > 0) {
        shinyjs::enable("delete")
      } else {
        shinyjs::disable("delete")
      }
    })


  })
}

## To be copied in the UI
# mod_delete_data_ui("delete_data_1")

## To be copied in the server
# mod_delete_data_server("delete_data_1")
