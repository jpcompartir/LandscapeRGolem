#' conversation_landscape UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_conversation_landscape_ui <- function(id){
  ns <- NS(id)
  tagList(
    gotop::use_gotop(),
    shiny::fluidRow(
      shiny::column(2,
                    style = "padding-right: 0px; border: none;",
                    shiny::textInput(inputId = ns("remainingName"), "All Data",
                                     value = NULL,
                                     placeholder = "filename")
      ),
      shiny::column(1,
                    style = "padding-left: 10px; padding-right: 20px;",
                    shiny::div(
                      style = "margin-top: 25px;",
                      shiny::downloadButton(ns("downloadAll"), "Download",
                                            class = "btn btn-warning",
                                            style = "background: #ff4e00; border-radius: 100px; color: #ffffff; border:none;")
                    )),
      shiny::column(3, style = "padding-left: 20px; padding-right: 10px;", shinyWidgets::searchInput(
        #Use the shinyWidget searchInput for a tidy searchable button
        inputId = ns("filterPattern"),
        label = "Pattern to search text with",
        placeholder = "A placeholder",
        btnSearch = shiny::icon("search"),
        btnReset = shiny::icon("remove"),
        width = "100%",
        value = ""
      )),
      shiny::column(2, shiny::textInput(ns("fileName"),
                                        "Selected Data",
                                        value = NULL,
                                        placeholder = "filename excluding .csv")),
      shiny::column(2, shiny::div(
        style = "margin-top: 25px;",
        shiny::downloadButton(ns("downloadData"),
                              "Download",
                              class = "btn btn-warning",
                              style = "background: #ff4e00; border-radius: 100px; color: #ffffff; border:none;"
        )
      )),
      mod_umap_plot_ui(ns("umapPlot")),
      # mod_data_table_ui(ns("dataTable"))
      shiny::column(5,
                    shinycssloaders::withSpinner(
                      DT::dataTableOutput(ns("highlightedTable"))))

    )
  )
}

#' conversation_landscape Server Functions
#'
#' @param xd The reactive data frame from app_server
#'
#' @noRd
mod_conversation_landscape_server <- function(id, xd){
  moduleServer(
    id,
    function(input, output, session){
    ns <- session$ns

    # mod_data_table_server("dataTable")
    mod_umap_plot_server("umapPlot")
    output$highlightedTable <- DT::renderDataTable({

      xd() %>%
        dplyr::select(date, text, cluster, sentiment, permalink) %>%
        DT::datatable(
          filter = "top",
          options = list(pageLength = 25,
                         dom = '<"top" ifp> rt<"bottom"lp>',
                         autoWidth = FALSE),
          style = "bootstrap",
          rownames = FALSE,
          escape = FALSE)


    }) #This is working now after fixing the ns() stuff

  })
}

## To be copied in the UI
# mod_conversation_landscape_ui("conversation_landscape_1")

## To be copied in the server
# mod_conversation_landscape_server("conversation_landscape_1")
