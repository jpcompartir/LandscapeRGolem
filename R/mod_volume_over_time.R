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
      shiny::tags$h3("Volume Over Time"),
      bslib::layout_sidebar(
        fill = TRUE,
        sidebar = bslib::sidebar(
          open = TRUE,
          shiny::tagList(
            shinyWidgets::noUiSliderInput(inputId = ns("height"), label = "height", min = 300, max = 1400, value = distribution_tab_height, step = 50, color = "#ff7518"),
            shinyWidgets::noUiSliderInput(inputId = ns("width"), label = "width", min = 300, max = 1400, value = distribution_tab_width, step = 50, color = "#ff7518"),
            mod_daterange_input_ui(id = ns("dateRangeVot")),
            shiny::selectInput(inputId = ns("dateBreak"), label = "unit", choices = c("day", "week", "month", "quarter", "year"), selected = "week"),
            shiny::selectInput(inputId = ns("dateSmooth"), label = "smooth", choices = c("none", "loess", "lm", "glm", "gam"), selected = "none"),
            shiny::uiOutput(ns("smoothControls")),
            colourpicker::colourInput(ns("volumeHex"), label = "colour", value = "#107C10"),
            mod_reactive_labels_ui(ns("volumeTitles")),
            shiny::downloadButton(outputId = ns("saveVolume"), class = "btn btn-warning")
          )
        ),
        # ... of layout_sidebar() starts here and is the mainPanel
        shinycssloaders::withSpinner(shiny::plotOutput(outputId = ns("volumePlot"), height = "450px", width = "450px"))
      )
    )
  )
}


#' volume_over_time Server Functions
#'
#' @noRd
mod_volume_over_time_server <- function(id, highlighted_dataframe, r) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    vol_titles <- mod_reactive_labels_server("volumeTitles")

    date_range_vot <- mod_daterange_input_server("dateRangeVot", highlighted_dataframe = highlighted_dataframe, r = r) # Render the reactive plot from this.

    volume_reactive <- reactive({
      if (nrow(highlighted_dataframe()) < 1) {
        validate("You must select data first to view a volume over time plot")
      }

      vol_plot <- date_range_vot$over_time_data() %>%
        LandscapeR::ls_plot_volume_over_time(
          .date_var = date,
          unit = input$dateBreak,
          fill = input$volumeHex
        )

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
        )
      }
    })

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
