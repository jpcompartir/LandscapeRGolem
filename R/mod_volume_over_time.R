#' volume_over_time UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_volume_over_time_ui <- function(id, distribution_tab_height, distribution_tab_width) {
  ns <- NS(id)

  tagList(
    bslib::page_fillable(
      bslib::layout_sidebar(
        fill = TRUE,
        bslib::sidebar(
          open = FALSE,
          shiny::tagList(
            shiny::sliderInput(
              inputId = ns("height"),
              "height",
              min = 100,
              max = 600,
              value = distribution_tab_height,
              step = 50),
            shiny::sliderInput(
              inputId = ns("width"),
              "width",
              min = 100,
              max = 800,
              value = distribution_tab_width,
              step = 50),
            shiny::dateRangeInput(
              inputId = ns("dateRange"),
              label = "date range",
              start = NULL,
              end = NULL
            ),
            shiny::selectInput(inputId = ns("dateBreak"), label = "unit", choices = c("day", "week", "month", "quarter", "year"), selected = "week"),
            shiny::selectInput(inputId = ns("dateSmooth"), label = "smooth", choices = c("none", "loess", "lm", "glm", "gam"), selected = "none"),
            shiny::uiOutput(ns("smoothControls")),
            colourpicker::colourInput(ns("volumeHex"), label = "colour", value = "#107C10"),
            mod_reactive_labels_ui(ns("volumeTitles")),
            shiny::downloadButton(outputId = ns("saveVolume"), class = "btn btn-warning")
        )
        ),
        # ... starts here and is the mainPanel
          shinycssloaders::withSpinner(shiny::plotOutput(outputId = ns("volumePlot"), height = "450px", width = "450px"))
      )
    )
  )
}


#' volume_over_time Server Functions
#'
#' @noRd
mod_volume_over_time_server <- function(id, highlighted_dataframe) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    vol_titles <- mod_reactive_labels_server("volumeTitles")

    # get the minimum date range and store in a reactive
    date_min <- reactive(min(highlighted_dataframe()[["date"]]))
    date_max <- reactive(max(highlighted_dataframe()[["date"]]))


    observe({
      shiny::updateDateRangeInput(
        session = session,
        inputId = "dateRange", # Link to UI's dateRange
        label = "date range",
        start = date_min(), # ensure called reactively
        end = date_max()
      ) # ensure called reactively
    })

    volume_reactive <- reactive({
      if (nrow(highlighted_dataframe()) < 1) {
        validate("You must select data first to view a volume over time plot")
      }

      vol_plot <- highlighted_dataframe() %>%
        dplyr::mutate(date = as.Date(date)) %>%
        dplyr::filter(
          date >= input$dateRange[[1]],
          date <= input$dateRange[[2]]
        ) %>%
        LandscapeR::ls_plot_volume_over_time(
          .date_var = date,
          unit = input$dateBreak,
          fill = delayedVolumeHex()
        ) # Add the labels from mod_reactive_labels to the plot

      if (!input$dateSmooth == "none") {
        if (input$smoothSe == "FALSE") {
          vol_plot <- vol_plot +
            ggplot2::geom_smooth(
              method = input$dateSmooth,
              se = FALSE,
              colour = input$smoothColour
            )
        } else {
          vol_plot <- vol_plot +
            ggplot2::geom_smooth(
              method = input$dateSmooth,
              colour = input$smoothColour
            )
        }
      }
      vol_plot <- vol_plot +
        vol_titles$labels()

      return(vol_plot)
    })

    output$volumePlot <- shiny::renderPlot(
      {
        volume_reactive()
      },
      res = 100,
      width = function() input$width,
      height = function() input$height
    )

    # Volume plot smooth controls
    output$smoothControls <- shiny::renderUI({
      if (input$dateSmooth != "none") {
        shiny::tagList(
          shiny::selectInput(
            ns("smoothSe"),
            "show standard error?",
            choices = c("TRUE", "FALSE"),
            selected = "TRUE"
          ),
          colourpicker::colourInput(ns("smoothColour"), label = "smooth colour", value = "#000000")
          # shiny::textInput(ns("smoothColour"), "Smooth colour", value = "#000000")
        )
      }
    })

    delayedVolumeHex <- shiny::reactive({
      input$volumeHex
    }) %>%
      shiny::debounce(500)

    output$saveVolume <- LandscapeR::download_box("volume_plot",
      volume_reactive,
      width = shiny::reactive(input$width),
      height = shiny::reactive(input$height)
    )
  })
}
## To be copied in the UI
# mod_volume_over_time_ui("volume_over_time_1")

## To be copied in the server
# mod_volume_over_time_server("volume_over_time_1")
