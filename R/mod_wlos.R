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
    bslib::page_fillable(
      bslib::accordion(
        id = ns("mainAccordion"),
        bslib::accordion_panel(
          id = ns("item1"),
          title = "Weighted Log-odds",
          active = TRUE,
          bslib::accordion_panel(
            id = ns("wlosText"),
            title = "Settings & Inputs",
            active = TRUE,
            wlos_text() #saved in zzz.R
          ),
          bslib::card(
            full_screen = TRUE,
            bslib::layout_sidebar(
              fill = TRUE,
              bslib::sidebar(bg = "white",
                             bslib::accordion(
                               id = ns("nestedAccordion1"),
                               bslib::accordion_panel(
                                 id = ns("nested1item1"),
                                 title = "Aesthetic Controls",
                                 open = FALSE,
                                 icon = shiny::icon(
                                   name = "wand-magic-sparkles"),
                                 shiny::sliderInput(inputId = ns("height"), "height", min = 100, max = 1400, value = 800, step = 100),
                                 shiny::sliderInput(inputId = ns("width"), "width", min = 100, max = 1200, value = 600, step = 100),
                                 shiny::sliderInput(inputId = ns("textSize"), "text size", min = 2, max = 8, value = 4, step = 1),
                                 shiny::sliderInput(inputId = ns("nrow"), label = "number of rows", min = 1, max = 20, value = 10, step = 1),
                               ),
                               bslib::accordion_panel(
                                 id = ns("nested1item2"),
                                 title = "Parameters",
                                 open = TRUE,
                                 icon = shiny::icon("wrench"),
                                 shiny::sliderInput(
                                   inputId = ns("topN"),
                                   label = "top_n",
                                   min = 15,
                                   max = 60,
                                   value = 30,
                                   step = 5
                                 ),
                                 shiny::sliderInput(
                                   inputId = ns("termCutoff"),
                                   label = "top terms cutoff",
                                   min = 30,
                                   max = 5000, value = 2500,
                                   step = 100
                                 ),
                                 # shiny::selectInput(
                                 #   inputId = ns("groupVar"),
                                 #   label = "select your grouping variable",
                                 #   choices = NULL
                                 # ),
                                 shiny::downloadButton(outputId = ns("saveWLOs"), class = "btn btn-warning")
                               ),
                             ),
              ),
              bslib::accordion(
                id = ns("nestedAccordion2"),
                bslib::accordion_panel(
                  id = ns("nested2item1"),
                  title = "WLOs plot",
                  active = FALSE,
                  icon = shiny::icon("cloud-word"),
                  # bslib::card( full_screen = TRUE,
                  shinycssloaders::withSpinner(
                    shiny::plotOutput(
                      ns("wlosPlot"),
                      height = "800px",
                      width = "600px"
                    )
                  )
                  # ) #blisb::card below icon =
                )
              )
            )
          )
        ),
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

    #Comment to move to global groupvariable
    # observe({
    #   shiny::updateSelectInput(session,
    #                            inputId = "groupVar",
    #                            choices = names(highlighted_dataframe()),
    #                            selected = "cluster"
    #   )
    # })

    wlos_reactive <- reactive({
      if (nrow(highlighted_dataframe()) < 1) {
        validate("You must select data first to view a weighted log-odds chart")
      }

      wlos <- highlighted_dataframe() %>%
        LandscapeR::ls_wlos(
          group_var = r$globalGroupVar,
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
        wlos_reactive()
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
