#' umap_plot UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_umap_plot_ui <- function(id){
  ns <- NS(id)
  tagList(
    hiny::column(6,
                 style = "width:50%; height: 10000px; position: relative;",
                 htmltools::div(
                   id = "graph",
                   shinycssloaders::withSpinner(plotly::plotlyOutput("umapPlot", height = 600)),
                   htmltools::div(
                     id = "button",
                     shiny::fluidRow(
                       shiny::uiOutput("deleteme"), #Dynamic UI placeholder (renders once a selection has been made)
                     ),
                   ),
                   shiny::br(),
                   shiny::br(),
                   shiny::fluidRow(
                     shiny::column(6, htmltools::div(
                       id = "slider1",
                       style = "width: 100%;",
                       shiny::sliderInput("x1", "V1 Range", step = 5, -100, 100, c(-20, 20))
                     ), ),
                     shiny::column(
                       6,
                       htmltools::div(
                         id = "slider2", style = "width: 100%;",
                         shiny::sliderInput("y1", "V2 Range", step = 5, -100, 100, c(-20, 20))
                       )
                     ),
                   )
                 )
    )

  )
}

#' umap_plot Server Functions
#'
#' @noRd
mod_umap_plot_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

  })
}

## To be copied in the UI
# mod_umap_plot_ui("umap_plot_1")

## To be copied in the server
# mod_umap_plot_server("umap_plot_1")
