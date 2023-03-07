#' labelled_data UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_labelled_data_ui <- function(id){
  ns <- NS(id)
  tagList(
    shiny::fluidRow(
      shiny::column(3,
                    offset = 0,
                    style = "padding-left: 20px; padding-right: 10px;",
                    shiny::uiOutput(ns("labelSelection"))
      ),
      shiny::column(1,
                    shiny::uiOutput(ns("labelButton")),
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
mod_labelled_data_server <- function(id, r,
                                     reactive_dataframe,
                                     selected_range){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    shiny::observeEvent(input$labelNow,{
      if(length(r$labels) == 0){
        label_ids <- selected_range()$key
        reps <- length(label_ids)
        labels <- rep(x = input$labelText, reps)
        r$label_ids <- label_ids
        r$labels <- labels
      }else{
        label_ids <- as.numeric(selected_range()$key)
        reps <- length(label_ids)
        labels <- rep(x = input$labelText, reps)
        r$labels <- c(r$labels, labels)
        r$label_ids <- c(r$label_ids, label_ids)
      }

    })

    labelled_df <- reactive({
      if (length(r$label_id < 1)) {
        validate("You must label data first to join the tables")
      }

      labelled_lookup <- tibble::tibble(
        document = as.numeric(r$label_ids),
        label = r$labels
      )

      labelled_lookup %>%
        dplyr::left_join(reactive_dataframe())
    })

    output$labelledDT <- DT::renderDataTable({
      if (nrow(labelled_df()) < 1) {
        validate("You must label data first to view the labelled data table")
      }

      labelled_df() %>%
        DT::datatable()
    })

    #Make label button disappear when nothing selected
    output$labelSelection <- shiny::renderUI({
      if (length(selected_range() > 0)) {
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
      if (length(selected_range() > 0)) {
        shiny::actionButton(
          inputId = ns("labelNow"),
          label = "Label",
          icon = shiny::icon("check"),
          style = "margin-top: 25px; margin-left: 5px;"
        )
      }
    })

  })
}

## To be copied in the UI
# mod_labelled_data_ui("labelled_data_1")

## To be copied in the server
# mod_labelled_data_server("labelled_data_1")
