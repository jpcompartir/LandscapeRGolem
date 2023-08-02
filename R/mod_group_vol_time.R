#' group_vol_time UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_group_vol_time_ui <- function(id) {
  ns <- NS(id)
  tagList(
    bslib::card(
      full_screen = TRUE,
      bslib::layout_sidebar(
        fill = TRUE,
        sidebar = bslib::sidebar(
          bslib::accordion(
            open = "nested1item2",
            id = ns("nestedAccordion1"),
            bslib::accordion_panel(
              value = "nested1item1",
              title = "Aesthetic Controls",
              icon = shiny::icon("wand-magic-sparkles"),
              shiny::sliderInput(
                inputId = ns("height"),
                "height",
                min = 300, max = 1400,
                value = 600,
                step = 50
              ),
              shiny::sliderInput(
                inputId = ns("width"),
                "width",
                min = 300,
                max = 1400,
                value = 800,
                step = 50
              ),
              shiny::sliderInput(
                inputId = ns("nrow"),
                "Number of Rows",
                min = 1,
                max = 12,
                value = 3,
                step = 1
              )
            ),
            bslib::accordion_panel(
              title = "Parameters",
              icon = shiny::icon("wrench"),
              value = "nested1item2",
              shiny::dateRangeInput(
                inputId = ns("dateRangeGroupVol"),
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

              mod_reactive_labels_ui(ns("groupVolTimeTitles")),
              shiny::downloadButton(
                outputId = ns("saveGroupVolTime"),
                class = "btn btn-warning"
              )
            )
          )
        ),
        shinycssloaders::withSpinner(
          shiny::plotOutput(
            outputId = ns("groupVolTime"),
            height = "450px",
            width = "450px"))
      )
    )
  )
}

#' group_vol_time Server Functions
#'
#' @noRd
mod_group_vol_time_server <- function(id, highlighted_dataframe, r) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    group_vol_time_titles <- mod_reactive_labels_server("groupVolTimeTitles")

    # get the minimum date range and store in a reactive
    date_min <- reactive(min(highlighted_dataframe()[["date"]]))
    date_max <- reactive(max(highlighted_dataframe()[["date"]]))

    shiny::observe({
      shiny::updateDateRangeInput(
        session = session,
        inputId = "dateRangeGroupVol",
        start = date_min(),
        end = date_max()
      )
    })

    group_vol_time_reactive <- shiny::reactive({
      if (nrow(highlighted_dataframe()) < 1) {
        validate("You must select data first to view a grouped volume over time plot")
      }

      group_vol_time_plot <- highlighted_dataframe() %>%
        dplyr::filter(!!dplyr::sym(r$global_group_var) %in% r$current_subgroups) %>%
        dplyr::filter(
          date >= input$dateRangeGroupVol[[1]],
          date <= input$dateRangeGroupVol[[2]]
        ) %>%
        LandscapeR::ls_plot_group_vol_time(
          group_var = r$global_group_var,
          date_var = date,
          unit = input$dateBreak,
          nrow = input$nrow
        )

      group_vol_time_plot <- group_vol_time_plot +
        group_vol_time_titles$labels()

      return(group_vol_time_plot)
    })

    output$groupVolTime <- shiny::renderPlot(
      {
        group_vol_time_reactive()
      },
      res = 100,
      height = function() input$height,
      width = function() input$width
    )


    output$saveGroupVolTime <- LandscapeR::download_box(
      exportname = "group_vol_time",
      plot = group_vol_time_reactive,
      width = shiny::reactive(input$width),
      height = shiny::reactive(input$height)
    )
  })
}

## To be copied in the UI
# mod_group_vol_time_ui("group_vol_time_1")

## To be copied in the server
# mod_group_vol_time_server("group_vol_time_1")
