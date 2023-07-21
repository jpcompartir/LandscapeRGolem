#' wlos UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
# mod_wlos_ui <- function(id) {
#   ns <- NS(id)
#   tagList(
#     shiny::fluidRow(
#       shiny::column(
#         5,
#         shiny::HTML("
#              <p> Below you'll find a Weighted Log-odds (WLOs) Chart, this chart helps you to identify the key textual differences between groups. You can use this chart to understand why one cluster, topic, or grouping variable has been separated from the others.</p> <br/>
#              <p> You can use the side panel to play with and set arguments. The important arguments to consider when rendering a WLOs chart are:</p>
#              <ul>
#             <li><b>top_n</b> = <i>the number of terms to show on each chart</i></li>
#             <li><b>nrow</b> = <i>the number of rows to place the charts on</i></li>
#             <li><b>top_terms_cutoff</b> = <i>the rank, in order of frequency, for a term to be included</i></li>
#             <li><b>Select your grouping Variable</b> = <i>the name of the grouping variable you'd like to compare, e.g. topic, sentiment </i></li>
#           </ul>")
#       )
#     ),
#     shiny::fluidRow(
#       shiny::sidebarPanel(
#         width = 2,
#         shiny::sliderInput(inputId = ns("height"), "height", min = 100, max = 1400, value = 800, step = 100),
#         shiny::sliderInput(inputId = ns("width"), "width", min = 100, max = 1200, value = 600, step = 100),
#         shiny::sliderInput(inputId = ns("textSize"), "text size", min = 2, max = 8, value = 4, step = 1),
#         shiny::sliderInput(inputId = ns("nrow"), label = "number of rows", min = 1, max = 20, value = 10, step = 1),
#         shiny::sliderInput(
#           inputId = ns("topN"),
#           label = "top_n",
#           min = 15,
#           max = 60,
#           value = 30,
#           step = 5
#         ),
#         shiny::sliderInput(
#           inputId = ns("termCutoff"),
#           label = "top terms cutoff",
#           min = 500,
#           max = 5000, value = 2500,
#           step = 100
#         ),
#         shiny::selectInput(
#           inputId = ns("groupVar"),
#           label = "select your grouping variable",
#           choices = NULL
#         ),
#         shiny::downloadButton(outputId = ns("saveWLOs"), class = "btn btn-warning"),
#       ),
#       shinyjqui::jqui_resizable(
#         shiny::mainPanel(
#           width = 8,
#           shinycssloaders::withSpinner(shiny::plotOutput(ns("wlosPlot"),
#             height = "800px",
#             width = "600px"
#           ))
#         )
#       )
#     ),
#   )
# }

mod_wlos_ui <- function(id) {
  ns <- NS(id)
  tagList(
    shiny::fluidRow(
      shiny::column(
        5,
        shiny::HTML("
             <p> Below you'll find a Weighted Log-odds (WLOs) Chart, this chart helps you to identify the key textual differences between groups. You can use this chart to understand why one cluster, topic, or grouping variable has been separated from the others.</p> <br/>")
      ),
      shiny::column(
        5,
        shiny::HTML("<p> You can use the side panel to play with and set arguments. The important arguments to consider when rendering a WLOs chart are:</p>
                                  <ul>
                                  <li><b>top_n</b> = <i>the number of terms to show on each chart</i></li>
                                  <li><b>nrow</b> = <i>the number of rows to place the charts on</i></li>
                                  <li><b>top_terms_cutoff</b> = <i>the rank, in order of frequency, for a term to be included</i></li>
                                  <li><b>Select your grouping Variable</b> = <i>the name of the grouping variable you'd like to compare, e.g. topic, sentiment </i></li>
          </ul>")
      )
    ),
    bslib::page_fillable(
      bslib::layout_sidebar(
        fill = TRUE,
        bslib::sidebar(
          shiny::tagList(
            shiny::sliderInput(inputId = ns("height"), "height", min = 100, max = 1400, value = 800, step = 100),
            shiny::sliderInput(inputId = ns("width"), "width", min = 100, max = 1200, value = 600, step = 100),
            shiny::sliderInput(inputId = ns("textSize"), "text size", min = 2, max = 8, value = 4, step = 1),
            shiny::sliderInput(inputId = ns("nrow"), label = "number of rows", min = 1, max = 20, value = 10, step = 1),
            shiny::sliderInput(
              inputId = ns("topN"),
              label = "top_n",
              min = 15,
              max = 60,
              value = 30,
              step = 5
            ),
            shiny::sliderInput(
              inputId = ns("termCutoff"),
              label = "top terms cutoff",
              min = 500,
              max = 5000, value = 2500,
              step = 100
            ),
            shiny::selectInput(
              inputId = ns("groupVar"),
              label = "select your grouping variable",
              choices = NULL
            ),
            shiny::downloadButton(outputId = ns("saveWLOs"), class = "btn btn-warning")
          )
        ),
        shiny::mainPanel(
          width = 8,
          shinycssloaders::withSpinner(shiny::plotOutput(ns("wlosPlot"),
            height = "800px",
            width = "600px"
          ))
        )
      )
    )
  )
}




#' wlos Server Functions
#'
#' @noRd
mod_wlos_server <- function(id, highlighted_dataframe) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    observe({
      shiny::updateSelectInput(session,
        inputId = "groupVar",
        choices = names(highlighted_dataframe()),
        selected = "cluster"
      )
    })

    wlos_reactive <- reactive({
      if (nrow(highlighted_dataframe()) < 1) {
        validate("You must select data first to view a weighted log-odds chart")
      }

      wlos <- highlighted_dataframe() %>%
        LandscapeR::ls_wlos(
          group_var = input$groupVar,
          text_var = clean_text,
          top_n = input$topN,
          top_terms_cutoff = input$termCutoff,
          nrow = input$nrow,
          text_size = input$textSize
        )
      return(wlos)
    })

    output$wlosPlot <- shiny::renderPlot(
      {
        wlos_reactive()
      },
      width = function() input$width,
      height = function() input$height
    )

    output$saveWLOs <- LandscapeR::download_box("wlos_plot",
      wlos_reactive,
      width = shiny::reactive(input$width),
      height = shiny::reactive(input$height)
    )
  })
}

## To be copied in the UI
# mod_wlos_ui("wlos_1")

## To be copied in the server
# mod_wlos_server("wlos_1", highlighted_dataframe = reactive({})
