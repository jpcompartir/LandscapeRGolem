#' sentiment UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_sentiment_ui <- function(id){
  ns <- NS(id)
  tagList(
    shiny::sidebarLayout(
      shiny::sidebarPanel(
        width = 2,
        # Should functionise all of this and use map to render the UI elements.
        shiny::sliderInput(ns("height"), "Height",
                           min = 100, max = 800, value = 400, step = 50),
        shiny::sliderInput(ns("width"), "Width",
                           min = 100, max = 800, value = 400, step = 50),
        mod_reactive_labels_ui(ns("sentimentTitles")),
        shiny::downloadButton(outputId = ns("saveSentiment"), class = "btn btn-warning", style = "background: #ff4e00; border-radius: 100px; color: #ffffff; border:none;"),
      ),
      shiny::mainPanel(
        shinycssloaders::withSpinner(shiny::plotOutput(ns("sentimentPlot"),
                                                       height = "450px", width = "450px"))
      )
    ),
    shiny::hr(),
  )
}

#' sentiment Server Functions
#'
#' @noRd
mod_sentiment_server <- function(id, highlighted_dataframe){
  moduleServer( id, function(input, output, session){
    ns <- session$ns


    sent_titles <- mod_reactive_labels_server("sentimentTitles")
    sentiment_reactive <- reactive({

      if(nrow(highlighted_dataframe()) < 1){
        validate("You must select data first to view a sentiment distribution plot")
      }

      highlighted_dataframe() %>%
        LandscapeR::ls_plot_sentiment_distribution(sentiment_var = sentiment) +
        sent_titles$labels()
    })

    # now create the server's output for display in app
    output$sentimentPlot <-
      shiny::renderPlot({
          sentiment_reactive()
        },
        res = 100,
        width = function() input$height,
        height = function() input$width
      )

    output$saveSentiment <- LandscapeR::download_box(exportname = "sentiment_plot", plot = sentiment_reactive(),
                                                     width = input$width,
                                                     height = input$height)
  })
}

## To be copied in the UI
# mod_sentiment_ui("sentiment_1")

## To be copied in the server
# mod_sentiment_server("sentiment_1")
