#' token_plot UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_token_plot_ui <- function(id){
  ns <- NS(id)
  tagList(
    shiny::sidebarLayout(
      shiny::sidebarPanel(
        width = 2,
        shiny::sliderInput(inputId = ns("height"), "Height", min = 100, max = 800, value = 400, step = 50),
        shiny::sliderInput(inputId = ns("width"), "Width", min = 100, max = 800, value = 400, step = 50),
        shiny::textInput(inputId = ns("tokenHex"), "colour", value = "#0f50d2"),
        mod_reactive_labels_ui(ns('tokenTitles')),
        shiny::downloadButton(outputId = ns("saveToken"), class = "btn btn-warning", style = "background: #ff4e00; border-radius: 100px; color: #ffffff; border:none;"),
      ),
      shiny::mainPanel(
        shinycssloaders::withSpinner(shiny::plotOutput(outputId = ns("tokenPlot"), height = "450px", width = "450px"))
      )
    ),

  )
}

#' token_plot Server Functions
#'
#' @noRd
mod_token_plot_server <- function(id, highlighted_dataframe){
  moduleServer(id, function(input, output, session){
    ns <- session$ns

    token_titles <- mod_reactive_labels_server("tokenTitles")
    token_reactive <- reactive({
      if(nrow(highlighted_dataframe()) < 1){
        validate("You must select data first to view a token distribution plot")
      }

      highlighted_dataframe() %>%
      # ls_example %>%
        LandscapeR::ls_plot_tokens_counter(
          text_var = clean_text,
          top_n = 25,
          fill = delayedTokenHex()
        ) +
        ggplot2::scale_fill_manual(values = input$tokenHex) +
        token_titles$labels()
    })

    output$tokenPlot <- shiny::renderPlot({
        token_reactive()
      },
      res = 100,
      width = function() input$width,
      height = function() input$height
    )

    output$saveToken <- LandscapeR::download_box("token_plot",
                                                 token_reactive(),
                                                 width = input$width,
                                                 height = input$height)
    delayedTokenHex <- shiny::reactive({
      input$tokenHex
    }) %>%
      shiny::debounce(500)


  })
}

## To be copied in the UI
# mod_token_plot_ui("token_plot_1")

## To be copied in the server
# mod_token_plot_server("token_plot_1")
