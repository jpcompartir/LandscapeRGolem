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
    #Using some CSS for styling, and adding a spinner (that indicates something is loading) build out a UI tab which takes up 6/12 columns of the screen for the interactive landscape plot. Add the dynamically rendered delete me button to the UI in the bottom right corner of the landscape - rendering once selections have been made. Then place the V1 and V2 sliders below the landscape
    shiny::column(6,
                 style = "width:50%; height: 10000px; position: relative;",
                 htmltools::div(
                   id = "graph",
                   shinycssloaders::withSpinner(plotly::plotlyOutput(ns("umapPlot"), height = 600)),
                   htmltools::div(
                     id = "button",
                     shiny::fluidRow(
                       shiny::uiOutput(ns("deleteme")), #Dynamic UI placeholder (renders once a selection has been made)
                     ),
                   ),
                   shiny::br(),
                   shiny::br(),
                   shiny::fluidRow(
                     shiny::column(6, htmltools::div(
                       id = "slider1",
                       style = "width: 100%;",
                       shiny::sliderInput(ns("x1"), "V1 Range", step = 5, -100, 100, c(-20, 20))
                     ),
                     ), #Slider 1
                     shiny::column(
                       6,
                       htmltools::div(
                         id = "slider2", style = "width: 100%;",
                         shiny::sliderInput(ns("y1"), "V2 Range", step = 5, -100, 100, c(-20, 20))
                       )
                     ), #Slider2
                   )
                 )
    )

  )
}

#' umap_plot Server Functions
#'
#' @noRd
mod_umap_plot_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns

     output$umapPlot <- plotly::renderPlotly({
       dt <- LandscapeR::ls_example %>%
         dplyr::mutate(cluster = factor(cluster))

       dt %>%
         plotly::plot_ly(
           x = ~V1,
           y = ~V2,
           type = "scattergl",
           color = ~cluster,
           key = ~document,
           text = ~ paste("<br> Post:", text),
           hoverinfo = "text", marker = list(size = 2), height = 600
         ) %>%
         plotly::layout(
           dragmode = "lasso",
           legend = list(itemsizing = "constant")
         ) %>%
         plotly::event_register(event = "plotly_selected")
     })
  })
}

## To be copied in the UI
# mod_umap_plot_ui("umap_plot_1")

## To be copied in the server
# mod_umap_plot_server("umap_plot_1")

dt <- LandscapeR::ls_example %>%
  dplyr::mutate(cluster = factor(cluster))
dt %>%
  plotly::plot_ly(
    x = ~V1,
    y = ~V2,
    type = "scattergl",
    color = ~cluster,
    key = ~document,
    text = ~ paste("<br> Post:", text),
    hoverinfo = "text",
    market = list(size = 2), height = 600
  ) %>%
  plotly::layout(
    dragmode = "lasso",
    legend = list(itemsizing = "constant")
  ) %>%
  plotly::event_register(event = "plotly_selected")
