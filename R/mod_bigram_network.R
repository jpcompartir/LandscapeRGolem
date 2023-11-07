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
    bslib::page_fillable(
      bslib::card(
        full_screen = TRUE,
        bslib::accordion(
          id = ns("accordion"),
          bslib::accordion_panel(
            id = ns("item1"),
            title = "Bigram Network",
            active = TRUE,
            bigram_text()
          )
        ),
        bslib::layout_sidebar(
          fillable = TRUE,
          fill = TRUE,
          sidebar = bslib::sidebar(
            shinyWidgets::noUiSliderInput(ns("height"), "height", min = 100, max = 1200, value = 600, step = 50, color = "#ff7518"),
            shinyWidgets::noUiSliderInput(ns("width"), "width", min = 100, max = 1200, value = 800, step = 50, color = "#ff7518"),
            shinyWidgets::noUiSliderInput(ns("topN"), "top_n", min = 20, max = 100, value = 50, step = 5, color = "#ff7518"),
            shinyWidgets::noUiSliderInput(ns("minFreq"), "min_freq", min = 5, max = 100, value = 10, step = 5, color = "#ff7518"),
            # shiny::sliderInput(ns("height"), "height", min = 100, max = 1200, value = 600, step = 50),
            # shiny::sliderInput(ns("width"), "width", min = 100, max = 1200, value = 800, step = 50),
            # shiny::sliderInput(ns("topN"), "top_n", min = 20, max = 100, value = 50, step = 5),
            # shiny::sliderInput(ns("minFreq"), "min_freq", min = 5, max = 100, value = 10, step = 5),
            shinyWidgets::materialSwitch(inputId = ns("removeStopwords"), label = "remove stopwords?", status = "primary", right = TRUE, value = FALSE),
            shiny::actionButton(
              class = "btn-subgroups-update",
              inputId = ns("updatePlotsButton"),
              label = "update plot")
          ),
          # Main panel of bslib::sidebar()
          shinycssloaders::withSpinner(shiny::plotOutput(ns("bigramPlot"), height = "600px", width = "800px"))
        )
      )
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

    #update whenever highlighted_dataframe() updates, or the plot input button is pressed.
    bigram_reactive <- shiny::eventReactive(c(highlighted_dataframe(), input$updatePlotsButton),{
      if (nrow(highlighted_dataframe()) < 1) {
        validate("You must select data first to view a bigram network")
      }
      if (nrow(highlighted_dataframe()) >= 5000) {
        #Take a sample if the data is too big to be performant
        bigram_data <- highlighted_dataframe() %>%
          dplyr::sample_n(5000)
      } else {
        bigram_data <- highlighted_dataframe()
      }

      bigram <- bigram_data %>%
        #Function defined in zzz.R
        make_bigram_viz(
          text_var = clean_text,
          clean_text = FALSE,
          top_n = input$topN,
          min = input$minFreq,
          remove_stops = input$removeStopwords
        )

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
