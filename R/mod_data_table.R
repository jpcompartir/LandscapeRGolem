#' data_table UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_data_table_ui <- function(id) {
  ns <- NS(id)
  tagList(
    shiny::column(5, shinycssloaders::withSpinner(color = "#ff7518", type = 1,
      DT::dataTableOutput(ns("highlightedTable"))
    ))
  )
}

#' data_table Server Functions
#'
#' @noRd
mod_data_table_server <- function(id, highlighted_dataframe) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    output$highlightedTable <- DT::renderDataTable({

      # Function currently lives in zzz.R
      return(make_dt_tab_output(highlighted_dataframe))
    })
  })
}

## To be copied in the UI
# mod_data_table_ui("data_table_1")

## To be copied in the server
# mod_data_table_server("data_table_1")
#
# dt <- LandscapeR::ls_example
#
# dt <- dt %>%
#   dplyr::select(date, text, cluster, sentiment, permalink) %>%
#   DT::datatable(
#     filter = "top",
#     options = list(pageLength = 25, dom = '<"top" ifp> rt<"bottom"lp>', autoWidth = FALSE),
#                    style = "bootstrap",
#                    rownames = FALSE,
#                    escape = FALSE)
#
# dt
