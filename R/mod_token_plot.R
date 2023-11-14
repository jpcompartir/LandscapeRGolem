#' token_plot UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_token_plot_ui <- function(id, distribution_tab_height, distribution_tab_width) {
  ns <- NS(id)
  tagList(
    bslib::page_fillable(
      shiny::tags$h3("Token Counter"),
      bslib::layout_sidebar(
        fill = TRUE,
        sidebar = bslib::sidebar(
          open = TRUE,
          shinyWidgets::noUiSliderInput(inputId = ns("height"), label = "height", min = 300, max = 1000, value = distribution_tab_height, step = 50, color = "#ff7518"),
          shinyWidgets::noUiSliderInput(inputId = ns("width"), label = "width", min = 300, max = 1000, value = distribution_tab_width, step = 50, color = "#ff7518"),
          colourpicker::colourInput(ns("tokenHex"), label = "colour", value = "#107C10"),
          mod_reactive_labels_ui(ns("tokenTitles")),
          shiny::downloadButton(outputId = ns("saveToken"), class = "btn btn-warning")
        ),
        shinycssloaders::withSpinner(shiny::plotOutput(outputId = ns("tokenPlot"), height = "450px", width = "450px"))
      )
    )
  )
}

#' token_plot Server Functions
#'
#' @noRd
mod_token_plot_server <- function(id, highlighted_dataframe) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    token_titles <- mod_reactive_labels_server("tokenTitles")
    token_reactive <- reactive({
      if (nrow(highlighted_dataframe()) < 1) {
        validate("You must select data first to view a token distribution plot")
      }

      highlighted_dataframe() %>%
        LandscapeR::ls_plot_tokens_counter(
          text_var = clean_text,
          top_n = 25,
          fill = input$tokenHex
        ) +
        token_titles$labels()
    })

    output$tokenPlot <- shiny::renderPlot(
      {
        token_reactive()
      },
      res = 100,
      width = function() input$width,
      height = function() input$height
    )


    output$saveToken <- LandscapeR::download_box("token_plot",
                                                 token_reactive,
                                                 width = shiny::reactive(input$width),
                                                 height = shiny::reactive(input$height)
    )

  })
}

## To be copied in the UI
# mod_token_plot_ui("token_plot_1")

## To be copied in the server
# mod_token_plot_server("token_plot_1")
