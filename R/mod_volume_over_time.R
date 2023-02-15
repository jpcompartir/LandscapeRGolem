#' volume_over_time UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_volume_over_time_ui <- function(id){
  ns <- NS(id)
  tagList(
    # shiny::fluidRow(
    #   shiny::plotOutput(outputId = ns("volumePlot"), height = "450px", width = "450px"))
    shiny::sidebarLayout(
      shiny::sidebarPanel(
        width = 2,
        shiny::sliderInput(inputId = ns("height"), "Height", min = 100, max = 800, value = 400, step = 50),
        shiny::sliderInput(inputId = ns("width"), "Width", min = 100, max = 800, value = 400, step = 50),
        shiny::dateRangeInput(inputId = ns("dateRange"), label = "Date Range", start = as.Date("01-01-2022", format = "%d-%m-%Y"), end = as.Date("01-01-2023", format = "%d-%m-%Y")), #This being hardcoded in is not ideal but it works for now
        shiny::selectInput(inputId = ns("dateBreak"), label = "Unit", choices = c("day", "week", "month", "quarter", "year"), selected = "week"),
        shiny::selectInput(inputId = ns("dateSmooth"), label = "Smooth", choices = c("none", "loess", "lm", "glm", "gam"), selected = "none"),
        shiny::uiOutput(ns("smoothControls")),

        shiny::textInput(ns("volumeHex"), "colour", value = "#107C10"),
        mod_reactive_labels_ui(ns("volumeTitles")),
        shiny::downloadButton(outputId = ns("saveVolume"), class = "btn btn-warning", style = "background: #ff4e00; border-radius: 100px; color: #ffffff; border:none;"),
      ),
      shiny::mainPanel(
        shinycssloaders::withSpinner(shiny::plotOutput(outputId = ns("volumePlot"), height = "450px", width = "450px"))
      )
    )
    )

}

#' volume_over_time Server Functions
#'
#' @noRd
mod_volume_over_time_server <- function(id, highlighted_dataframe){
  moduleServer(id, function(input, output, session){
    ns <- session$ns

    #---- Volume Plot ----
    # output$volumeTitles <- titles_render("volume", input)
    # volume_label <- reactive_labels("volume", input)


    volume_reactive <- reactive({
      vol_plot <- highlighted_dataframe() %>%
        dplyr::mutate(date = as.Date(date)) %>%
        dplyr::filter(date >= input$dateRange[[1]],
                      date <= input$dateRange[[2]]) %>%
        LandscapeR::ls_plot_volume_over_time(
          .date_var = date,
          unit = input$dateBreak,
          fill = delayedVolumeHex()
        ) +
        vol_titles$labels()

      if(!input$dateSmooth == "none") {
        if(input$smoothSe == "FALSE") {
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

      return(vol_plot)
    })

    vol_titles <- mod_reactive_labels_server("volumeTitles")

    output$volumePlot<- shiny::renderPlot({
          volume_reactive()
        },
        res = 100,
        width = function() input$width,
        height = function() input$height
      )

    # Volume plot smooth controls
    output$smoothControls <- shiny::renderUI({
      if(input$dateSmooth != "none") {
        shiny::tagList(
          shiny::selectInput(
            "smoothSe",
            "show standard error?",
            choices = c("TRUE", "FALSE"),
            selected = "TRUE"
          ),
          shiny::textInput("smoothColour", "Smooth colour", value = "#000000")
        )
      }
    })

    delayedVolumeHex <- shiny::reactive({
      input$volumeHex
    }) %>%
      shiny::debounce(500)

    output$saveVolume <- LandscapeR::download_box("volume_plot", volume_reactive())


  })
}

## To be copied in the UI
# mod_volume_over_time_ui("volume_over_time_1")

## To be copied in the server
# mod_volume_over_time_server("volume_over_time_1")