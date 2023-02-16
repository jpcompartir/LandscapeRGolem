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
      mod_download_data_ui(id = ns("allData"), label = "All Data"),

      shiny::column(3, style = "padding-left: 20px; padding-right: 10px;", shinyWidgets::searchInput(
        #Use the shinyWidget searchInput for a tidy searchable button allowing us to filter by a pattern
        inputId = ns("filterPattern"),
        label = "Pattern to search text with",
        placeholder = "A placeholder",
        btnSearch = shiny::icon("search"),
        btnReset = shiny::icon("remove"),
        width = "100%",
        value = ""
      )),
      mod_download_data_ui(id = ns("selectedData"), label = "Selected Data"),
      mod_umap_plot_ui(id = ns("umapPlot")),
      mod_data_table_ui(id = ns("dataTable"))
    )
  )
}

#' conversation_landscape Server Functions
#'
#' @param xd The reactive data frame from app_server
#'
#' @noRd
mod_conversation_landscape_server <- function(id, reactive_dataframe, selected_range, highlighted_dataframe, r){
  moduleServer(
    id,
    function(input, output, session){
    ns <- session$ns

    mod_data_table_server("dataTable", highlighted_dataframe)
    mod_umap_plot_server("umapPlot", reactive_dataframe, selected_range, r)
    mod_download_data_server("allData", data_object = highlighted_dataframe)
    mod_download_data_server("selectedData", data_object = highlighted_dataframe)

    observe({
      r$filterPattern <- input$filterPattern
    })

    # return(list(
    #   pattern = reactive({tmp_var$pattern})
    # ))
  })
}

## To be copied in the UI
# mod_conversation_landscape_ui("conversation_landscape_1")

## To be copied in the server
# mod_conversation_landscape_server("conversation_landscape_1")
