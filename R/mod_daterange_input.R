#' daterange_input UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_daterange_input_ui <- function(id){
  ns <- NS(id)
  tagList(
    shiny::dateRangeInput(
      inputId = ns("dateRange"),
      label = "date range",
      start = NULL,
      end = NULL,
      min = Sys.Date() - (365* 5),
      max = Sys.Date() + 1
    )
  )
}

#' daterange_input Server Functions
#'
#' @noRd
mod_daterange_input_server <- function(id, highlighted_dataframe, r){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    observeEvent(highlighted_dataframe(), {
      req(!is.null(r$date_min), !is.null(r$date_max))
      shiny::updateDateRangeInput(
        session = session,
        inputId = "dateRange",
        start = r$date_min,
        end = r$date_max,
        min = r$date_min - 1,
        max = r$date_max + 1
      )
    })

    over_time_data <- reactive({
      over_time_data <- highlighted_dataframe() %>%
      dplyr::mutate(date = as.Date(date)) %>%
      dplyr::filter(
        date >= input$dateRange[[1]],
        date <= input$dateRange[[2]])
    })

    return(list(over_time_data = over_time_data))


  })
}

## To be copied in the UI
# mod_daterange_input_ui("daterange_input_1")

## To be copied in the server
# mod_daterange_input_server("daterange_input_1")
