#' sentiment UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_sentiment_ui <- function(id, distribution_tab_height, distribution_tab_width) {
  ns <- NS(id)
  tagList(
    bslib::page_fillable(
      shiny::tags$h3("Sentiment Distribution"),
      bslib::layout_sidebar(
        fill = TRUE,
        sidebar = bslib::sidebar(
          open = TRUE,
          # Should functionise all of this and use map to render the UI elements.
          shiny::sliderInput(
            inputId = ns("height"),
            "height",
            min = 300,
            max = 1000,
            value = distribution_tab_height,
            step = 50),
          shiny::sliderInput(
            inputId = ns("width"),
            "width",
            min = 300,
            max = 1000,
            value = distribution_tab_width,
            step = 50),
          mod_reactive_labels_ui(
            ns("sentimentTitles")),
          shiny::downloadButton(
            outputId = ns("saveSentiment"), class = "btn btn-warning")
        ),
        # ... starts here and is mainPanel
        shinycssloaders::withSpinner(
          shiny::plotOutput(ns("sentimentPlot"),
                            height = "450px", width = "450px"
          )
        )
      )
    )
  )
}

#Dropdown menu sentiment (in progress)

# mod_sentiment_ui <- function(id, distribution_tab_height, distribution_tab_width) {
#   ns <- NS(id)
#   tagList(
#     bslib::page_fillable(
#       shinyWidgets::dropdown(
#         status = "primary",
#         icon = shiny::icon("gear"),
#         circle = TRUE,
#         width = "100%",
#         tooltip = shinyWidgets::tooltipOptions(title = "click for plot settings"),
#         # Should functionise all of this and use map to render the UI elements.
#         shiny::sliderInput(
#           inputId = ns("height"),
#           "height",
#           min = 100,
#           max = 600,
#           value = distribution_tab_height,
#           step = 50),
#         shiny::sliderInput(
#           inputId = ns("width"),
#           "width",
#           min = 100,
#           max = 800,
#           value = distribution_tab_width,
#           step = 50),
#         mod_reactive_labels_ui(
#           ns("sentimentTitles")),
#         shiny::downloadButton(
#           outputId = ns("saveSentiment"), class = "btn btn-warning")
#       ),
#       # ... starts here and is mainPanel
#       shinycssloaders::withSpinner(
#         shiny::plotOutput(ns("sentimentPlot"),
#                           height = "450px", width = "450px"
#         )
#       )
#     )
#   )
# }


#' sentiment Server Functions
#'
#' @noRd
mod_sentiment_server <- function(id, highlighted_dataframe) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns


    sent_titles <- mod_reactive_labels_server("sentimentTitles")
    sentiment_reactive <- reactive({
      if (nrow(highlighted_dataframe()) < 1) {
        validate("You must select data first to view a sentiment distribution plot")
      }

      highlighted_dataframe() %>%
        LandscapeR::ls_plot_sentiment_distribution(sentiment_var = sentiment) +
        sent_titles$labels()
    })

    # now create the server's output for display in app
    output$sentimentPlot <-
      shiny::renderPlot(
        {
          sentiment_reactive()
        },
        res = 100,
        width = function() input$width,
        height = function() input$height
      )


    output$saveSentiment <- LandscapeR::download_box(
      exportname = "sentiment_plot",
      plot = sentiment_reactive,
      width = shiny::reactive(input$width),
      height = shiny::reactive(input$height)
    )
  })
}

## To be copied in the UI
# mod_sentiment_ui("sentiment_1")

## To be copied in the server
# mod_sentiment_server("sentiment_1")
