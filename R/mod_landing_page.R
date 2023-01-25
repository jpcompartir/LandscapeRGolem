#' landing_page UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_landing_page_ui <- function(id){
  ns <- NS(id)
  tagList(
    gotop::use_gotop(),
    shiny::fluidRow(
      shiny::column(2,
                    style = "padding-right: 0px; border: none;",
                    shiny::textInput("remainingName", "All Data",
                                     value = NULL,
                                     placeholder = "filename")
                    ),
      shiny::column(1,
                    style = "padding-left: 10px; padding-right: 20px;",
                    shiny::div(
                      style = "margin-top: 25px;",
                      shiny::downloadButton("downloadAll", "Download",
                                            class = "btn btn-warning",
                                            style = "background: #ff4e00; border-radius: 100px; color: #ffffff; border:none;")
                    )),
      shiny::column(3, style = "padding-left: 20px; padding-right: 10px;", shinyWidgets::searchInput(
        #Use the shinyWidget searchInput for a tidy searchable button
        inputId = "filterPattern",
        label = "Pattern to search text with",
        placeholder = "A placeholder",
        btnSearch = shiny::icon("search"),
        btnReset = shiny::icon("remove"),
        width = "100%",
        value = ""
      )),
      shiny::column(2, shiny::textInput("fileName", "Selected Data", value = NULL, placeholder = "filename excluding .csv")),
      shiny::column(2, shiny::div(
        style = "margin-top: 25px;",
        shiny::downloadButton("downloadData",
                              "Download",
                              class = "btn btn-warning",
                              style = "background: #ff4e00; border-radius: 100px; color: #ffffff; border:none;"
        )
      )),
      # mod_umap_plot("umapPlot")

    )
  )
}

#' landing_page Server Functions
#'
#' @noRd
mod_landing_page_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

  })
}

## To be copied in the UI
# mod_landing_page_ui("landing_page_1")

## To be copied in the server
# mod_landing_page_server("landing_page_1")
