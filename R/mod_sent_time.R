#' sent_time UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_sent_time_ui <- function(id, distribution_tab_height, distribution_tab_width) {
  ns <- NS(id)
  tagList(
    bslib::page_fillable(
      shiny::tags$h3("Sentiment Over Time"),
      bslib::layout_sidebar(
        fill = TRUE,
        sidebar = bslib::sidebar(
          open = TRUE,
          shinyWidgets::noUiSliderInput(inputId = ns("height"), label = "height", min = 300, max = 1000, value = distribution_tab_height, step = 50, color = "#ff7518"),
          shinyWidgets::noUiSliderInput(inputId = ns("width"), label = "width", min = 300, max = 1000, value = distribution_tab_width, step = 50, color = "#ff7518"),
          mod_daterange_input_ui(ns("dateRangeSent")),
            shiny::selectInput(
              inputId = ns("dateBreak"),
              label = "unit",
              choices = c("day", "week", "month", "quarter", "year"),
              selected = "week"
            ),
            mod_reactive_labels_ui(ns("sentTimeTitles")),
            shiny::downloadButton(
              outputId = ns("saveSentTime"),
              class = "btn btn-warning"
            )
        ),
          shinycssloaders::withSpinner(
            shiny::plotOutput(outputId = ns("sentTimePlot"), height = "450px", width = "450px"))
      )
    )
  )
}

#' sent_time Server Functions
#'
#' @noRd
mod_sent_time_server <- function(id, highlighted_dataframe, r) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    sent_time_titles <- mod_reactive_labels_server("sentTimeTitles")

    sent_date_range_vot <- mod_daterange_input_server("dateRangeSent", highlighted_dataframe, r)

    sent_time_reactive <- reactive({
      if (nrow(highlighted_dataframe()) < 1) {
        validate("You must select data first to view a sentiment over time plot")
      }

      sent_time_plot <-sent_date_range_vot$over_time_data() %>%
        LandscapeR::ls_sentiment_over_time(
          sentiment_var = sentiment,
          date_var = date,
          unit = input$dateBreak
        )

      sent_time_plot <- sent_time_plot +
        sent_time_titles$labels()

      return(sent_time_plot)
    })

    output$sentTimePlot <- shiny::renderPlot(
      {
        sent_time_reactive()
      },
      res = 100,
      width = function() input$width,
      height = function() input$height
    )


    output$saveSentTime <- LandscapeR::download_box(
      "sentiment_time_plot",
      sent_time_reactive,
      width = shiny::reactive(input$width),
      height = shiny::reactive(input$height)
    )
  })
}

## To be copied in the UI
# mod_sent_time_ui("sent_time_1")

## To be copied in the server
# mod_sent_time_server("sent_time_1")
