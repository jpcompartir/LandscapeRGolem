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
            shiny::sliderInput(
              inputId = ns("height"),
              "height",
              min = 300, max = 1000,
              value = distribution_tab_height,
              step = 50
            ),
            shiny::sliderInput(
              inputId = ns("width"),
              "width",
              min = 300,
              max = 1000,
              value = distribution_tab_width,
              step = 50
            ),
            shiny::dateRangeInput(
              inputId = ns("dateRangeSent"),
              label = "date range",
              start = NULL,
              end = NULL
            ),
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
mod_sent_time_server <- function(id, highlighted_dataframe) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    sent_time_titles <- mod_reactive_labels_server("sentTimeTitles")

    # get the minimum date range and store in a reactive
    date_min_sent <- reactive(min(highlighted_dataframe()[["date"]]))
    date_max_sent <- reactive(max(highlighted_dataframe()[["date"]]))

    observe({
      shiny::updateDateRangeInput(
        session = session,
        inputId = "dateRangeSent", # Link to UI's dateRange
        label = "date range",
        start = date_min_sent(), # ensure called reactively
        end = date_max_sent()
      ) # ensure called reactively
    })

    sent_time_reactive <- reactive({
      if (nrow(highlighted_dataframe()) < 1) {
        validate("You must select data first to view a sentiment over time plot")
      }

      sent_time_plot <- highlighted_dataframe() %>%
        dplyr::filter(
          date >= input$dateRangeSent[[1]],
          date <= input$dateRangeSent[[2]]
        ) %>%
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
