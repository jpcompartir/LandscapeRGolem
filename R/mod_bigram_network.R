#' bigram_network UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_bigram_network_ui <- function(id) {
  ns <- NS(id)
  tagList(
    shiny::fluidRow(
      shinyFeedback::useShinyFeedback(),
      shiny::column(
        4,
        shiny::p("Below you'll find a bigram network, this network will help you estimate how clean your selected data is. Remember that long and connected chains of words may represent spam or unwanted mentions."),
        shiny::br(),
        shiny::p("This bigram network is restricted to a maximum of 5,000 data points for speed and user experience. It is therefore not recommended to be saved or exported. If the data looks clean, download the selection and create the network in the standard way in R/Rstudio"),
      )
    ),
    shiny::sidebarPanel(
      width = 2,
      shiny::sliderInput(ns("height"), "Height", min = 100, max = 1200, value = 600, step = 50),
      shiny::sliderInput(ns("width"), "Width", min = 100, max = 1200, value = 800, step = 50),
    ),
    shiny::mainPanel(
      shinycssloaders::withSpinner(shiny::plotOutput(ns("bigramPlot"), height = "800px", width = "800px"))
    )
  )
}

#' bigram_network Server Functions
#'
#' @param id Tab's ID set in mod_*_ui
#' @param highlighted_dataframe The selected data frame passed by app.server to module
#'
#' @noRd
mod_bigram_network_server <- function(id, highlighted_dataframe) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    make_bigram_viz <- function(data, text_var = mention_content, top_n = 50, min = 10, ...) {
      requireNamespace("ParseR")

      plot <- data %>%
        ParseR::count_ngram(text_var = {{ text_var }}, top_n = top_n, min_freq = min, ...) %>%
        purrr::pluck("viz") %>%
        ParseR::viz_ngram()

      return(plot)
    }

    bigram_reactive <- reactive({
      if (nrow(highlighted_dataframe()) < 1) {
        validate("You must select data first to view a bigram network")
      }
      if (!nrow(highlighted_dataframe()) >= 5000) { # Check rows are fewer than 5k for speed
        bigram <- highlighted_dataframe() %>%
          make_bigram_viz(
            text_var = clean_text,
            clean_text = FALSE, # for speed - clean text outside of app functioning
            min = 5,
            remove_stops = FALSE # for speed - remove stopwords in clean text variable outside of app
          )
      } else { # If > 5k rows take a sample
        bigram <- highlighted_dataframe() %>%
          dplyr::sample_n(5000) %>%
          make_bigram_viz(
            text_var = clean_text,
            clean_text = FALSE,
            min = 5,
            remove_stops = FALSE
          )
      }
      return(bigram)
    })
    output$bigramPlot <- shiny::renderPlot(
      {
        bigram_reactive()
      },
      res = 100,
      width = function() input$width,
      height = function() input$height
    )
  })
}

## To be copied in the UI
# mod_bigram_network_ui("bigram_network_1")

## To be copied in the server
# mod_bigram_network_server("bigram_network_1")
