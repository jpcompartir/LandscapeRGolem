#' conversation_landscape UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_conversation_landscape_ui <- function(id) {
  ns <- NS(id)
  tagList(
    gotop::use_gotop(),
    shiny::fluidRow(
      class = "d-flex align-items-center",
      shiny::column(
        2,
        style = "display: flex; align-items: center;",
        shiny::selectInput(
          inputId = ns("colourVar"), selected = "cluster", choices = NULL, label = "Colour Variable", selectize = FALSE # can set this to TRUE but will adjust height, and not sure it needs selectize for now. Unclear where to edit the selectize's height
        )),
      mod_download_data_ui(id = ns("allData"), label = "All Data"),
      shiny::column(3,
                    shinyWidgets::searchInput(
                      # Use local version of the shinyWidget searchInput for a tidy searchable button allowing us to filter by a pattern
                      inputId = ns("filterPattern"),
                      label = "Search text",
                      placeholder = "Regex pattern",
                      btnSearch = shiny::icon("search"),
                      btnReset = shiny::icon("remove"),
                      width = "100%",
                      value = ""
                    )),
      mod_download_data_ui(id = ns("selectedData"), label = "Selected Data"),
    ),
    shiny::fluidRow(
      mod_label_data_ui(id = ns("labelData"))
    ),
    shiny::fluidRow(
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
mod_conversation_landscape_server <- function(id,
                                              reactive_dataframe,
                                              highlighted_dataframe,
                                              r) {
  moduleServer(
    id,
    function(input, output, session) {
      ns <- session$ns

      #Add class to filterPattern_search & reset (as we're in the namespace, landscapeTag- doesn't need to be pre-pended - i.e. the tag when you inspect the html in the browser)
      # shinyjs::addClass(id = "filterPattern_text", class="search-text")
      shinyjs::addClass(id = "filterPattern_search", class="btn-download-custom")
      shinyjs::addClass(id = "filterPattern_reset", class="btn-download-custom")

      mod_data_table_server("dataTable", highlighted_dataframe)
      mod_umap_plot_server("umapPlot", reactive_dataframe, r)
      mod_download_data_server("allData", data_object = highlighted_dataframe)
      mod_download_data_server("selectedData", data_object = highlighted_dataframe)
      mod_label_data_server("labelData",
                            r = r,
                            reactive_dataframe = reactive_dataframe
      )

      observeEvent(input$filterPattern,{
        r$filterPattern <- input$filterPattern
      })

      observe({
        shiny::updateSelectInput(session,
                                 inputId = "colourVar",
                                 choices = r$column_names,
                                 selected = "cluster"
        )
      })

      observeEvent(input$colourVar,{
        r$colour_var <- input$colourVar
      })
    }
  )
}

## To be copied in the UI
# mod_conversation_landscape_ui("conversation_landscape_1")

## To be copied in the server
# mod_conversation_landscape_server("conversation_landscape_1")
