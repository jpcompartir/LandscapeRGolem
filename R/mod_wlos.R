#' wlos UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_wlos_ui <- function(id) {
  ns <- NS(id)
  tagList(
    bslib::card(
      full_screen = TRUE,
      wlos_text(),
      bslib::accordion(
        open =  "nested1item2",
        id = ns("mainAccordion"),
        bslib::layout_sidebar(
          fill = TRUE,
          sidebar = bslib::sidebar(
            bslib::accordion(
              open = TRUE,
              id = ns("nestedAccordion1"),
              bslib::accordion_panel(
                value = "nested1item1",
                title = "Aesthetic Controls",
                icon = shiny::icon("wand-magic-sparkles"),
                shinyWidgets::noUiSliderInput(inputId = ns("height"), "height", min = 100, max = 1400, value = 800, step = 100, color = "#ff7518"),
                shinyWidgets::noUiSliderInput(inputId = ns("width"), "width", min = 100, max = 1200, value = 600, step = 100, color = "#ff7518"),
              ),
              bslib::accordion_panel(
                value = "nested1item2",
                title = "Parameters",
                icon = shiny::icon("wrench"),
                shinyWidgets::noUiSliderInput(inputId = ns("topN"), "top_n", min = 15, max = 60, value = 30, step = 5, color = "#ff7518"),
                shinyWidgets::noUiSliderInput(inputId =ns("termCutoff"), "top terms cutoff", min = 30, max = 5000, value = 500, step = 100, color = "#ff7518"),
                shinyWidgets::noUiSliderInput(inputId = ns("textSize"), "text size", min = 2, max = 8, value = 4, step = 1, color = "#ff7518"),
                shinyWidgets::noUiSliderInput(inputId = ns("nrow"), "number of rows", min = 1, max = 20, value = 10, step = 1, color = "#ff7518"),
                shiny::actionButton(
                  class = "btn-warning",
                  inputId = ns("updatePlotsButton"),
                  label = "update plot"),
                shiny::br(),
                shiny::downloadButton(
                  outputId = ns("saveWLOs"),
                  class = "btn-warning")
              ),
            ),
          ),
          shinycssloaders::withSpinner(
            shiny::plotOutput(
              ns("wlosPlot"),
              height = "800px",
              width = "600px"
            )
          )
        )
      ),
    )
  )
}

#' wlos Server Functions
#'
#' @noRd
mod_wlos_server <- function(id, highlighted_dataframe, r) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    #Update when highlighted_dataframe changes, or the updatePlotsButton is pressed (settings) or the subgroups/groups are changed.
    wlos_reactive <- eventReactive(c(highlighted_dataframe(), r$grouped_data(), input$updatePlotsButton), {
      # browser()
      if (nrow(highlighted_dataframe()) < 1) {
        validate("You must select data first to view a weighted log-odds chart")
      }
      req(r$grouped_data())
      # browser()
      wlos <- r$grouped_data() %>%
        LandscapeR::ls_wlos(
          group_var = r$global_group_var,
          text_var = clean_text,
          top_n = input$topN,
          top_terms_cutoff = input$termCutoff,
          nrow = input$nrow,
          text_size = input$textSize
        )
      return(wlos)
    })

    output$wlosPlot <- shiny::renderPlot(
      {
        if(isTruthy(wlos_reactive())){
          wlos_reactive()
        }
      },
      width = function() input$width,
      height = function() input$height
    )

    output$saveWLOs <- LandscapeR::download_box("wlos_plot",
                                                wlos_reactive,
                                                width = shiny::reactive(input$width),
                                                height = shiny::reactive(input$height)
    )
  })
}

## To be copied in the UI
# mod_wlos_ui("wlos_1")

## To be copied in the server
# mod_wlos_server("wlos_1", highlighted_dataframe = reactive({})
