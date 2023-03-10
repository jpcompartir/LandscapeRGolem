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
                       shiny::sliderInput(ns("x1"), "V1 Range", step = 5, -100, 100, c(-20, 20)) #not using ns(x1) as don't want this input to be restricted to the namespace
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
mod_umap_plot_server <- function(id, reactive_dataframe, selected_range, r){
  moduleServer(id, function(input, output, session){
    ns <- session$ns

    observe({
      r$x1 <- input$x1
    })
    observe({
      r$y1 <- input$y1
    })

      # output$umapPlot <- plotly::renderPlotly({
      #   p <- reactive_dataframe() %>%
      #     dplyr::mutate(cluster = factor(cluster)) %>%
      #     LandscapeR::ls_plotly_umap(
      #       x = "V1",
      #       y = "V2",
      #       type = "scattergl",
      #       group_var = "cluster",
      #       key = "document",
      #       text_var = "text",
      #       height = 600,
      #       width = "100%"
      #     )
      #
      #   p %>%
      #     plotly::event_register(event = "plotly_selected")
      # })
       output$umapPlot <- plotly::renderPlotly({

         reactive_dataframe() %>%
           dplyr::mutate(cluster = factor(cluster)) %>%
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
             legend = list(itemsizing = "constant"),
             xaxis = list(showgrid = FALSE,
                          showline = FALSE,
                          zeroline = FALSE,
                          linewidth = 0,
                          tickwidth = 0,
                          showticklabels = FALSE,
                          title = ""),
             yaxis = list(showgrid = FALSE,
                          showline = FALSE,
                          zeroline = FALSE,
                          linewidth = 0,
                          tickwidth = 0,
                          showticklabels = FALSE,
                          title = ""),
             newshape=list(fillcolor="#ff5718", opacity=0.2)
           ) %>%
           plotly::config(
             editable = TRUE,
             modeBarButtonsToAdd =
               list("drawline",
                    "drawcircle",
                    "drawrect",
                    "eraseshape")) %>%
           plotly::event_register(event = "plotly_selected") %>%
           htmlwidgets::onRender(
             #Javascript function which labels the most recently added shape with some editable text
             "
  function(el) {
    var annotationCount = 0;
    el.on('plotly_relayout', function(d) {
      var shapes = d['shapes'];
      if (shapes && shapes.length > 0) {
        var lastShape = shapes[shapes.length - 1];
        var newAnnotation = {
          x: lastShape['x0'] + (lastShape['x1'] - lastShape['x0']) / 2,
          y: lastShape['y0'] + (lastShape['y1'] - lastShape['y0']) / 2 - 0.15,
          text: 'Custom Shape',
          showarrow: true,
          arrowhead: 3,
          ax: 0,
          ay: lastShape['y0'] - lastShape['y1'],
          arrowcolor: 'black',
          arrowwidth: 1,
          arrowhead: 0,
          alpha: 0.25,
          draggable: true,
          editable: true
        };
        if (annotationCount < shapes.length) {
          Plotly.relayout(el, 'annotations[' + annotationCount + ']', newAnnotation);
          annotationCount++;
        } else {
          Plotly.relayout(el, {
            annotations: [newAnnotation]
          });
          annotationCount = 1;
        }
      }
    });
  }
")
       })

     #Make delete button disappear when nothing selected
     output$deleteme <- shiny::renderUI({
       if (length(selected_range() > 1)) {
         shiny::tagList(
           shiny::actionButton(
             "delete",
             "Delete selections",
             class = "btn-warning",
             icon = shiny::icon("trash"),
             style = "position: absolute; bottom 7px; right: 7px; background: #ff4e00; border-radius: 100px; color: #ffffff; border:none;"
           )
         )
       }
     }) #end output$deleteme
  })


}

## To be copied in the UI
# mod_umap_plot_ui("umap_plot_1")
