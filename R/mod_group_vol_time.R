#' group_vol_time UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_group_vol_time_ui <- function(id){
  ns <- NS(id)
  tagList(
    shiny::fluidRow(
      shiny::sidebarLayout(
        shiny::sidebarPanel(
          width = 2,
          shiny::sliderInput(
            inputId = ns("height"),
            "Height",
            min = 100, max = 800,
            value = 400,
            step = 50
          ),
          shiny::sliderInput(
            inputId = ns("width"),
            "Width",
            min = 100,
            max = 800,
            value = 400,
            step = 50
          ),
           shiny::dateRangeInput(inputId = ns("dateRangeGroupVol"),
                              label = "Date Range",
                              start = NULL,
                              end = NULL),
          shiny::selectInput(
            inputId = ns("groupVarVol"),
            label = "Select your grouping variable",
            choices = NULL
          ),
          shiny::selectInput(inputId = ns("dateBreak"), label = "Unit", choices = c("day", "week", "month", "quarter", "year"), selected = "week"),
          shiny::sliderInput(
            inputId = ns("nrow"),
            "Number of groups",
            min = 1, max = 12,
            value = 5,
            step = 1
          ),
          mod_reactive_labels_ui(ns("groupVolTimeTitles")),
          shiny::downloadButton(
            outputId = ns("saveGroupVolTime"),
            class = "btn btn-warning"
          )
    ),
    shiny::mainPanel(
          width = 6,
          shinycssloaders::withSpinner(
            shiny::plotOutput(
              outputId = ns("groupVolTime"),
              height = "450px",
              width = "450px"
            )
        )
      )
    )
 
  )
  ) # nolint
}
    
#' group_vol_time Server Functions
#'
#' @noRd 
mod_group_vol_time_server <- function(id, highlighted_dataframe){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    observe({
      shiny::updateSelectInput(
        session = session,
        inputId = "groupVarVol",
        choices = names(highlighted_dataframe()),
        selected = names(highlighted_dataframe())[3]
      )
    })

    group_vol_time_titles <- mod_reactive_labels_server("groupVolTimeTitles")

  #get the minimum date range and store in a reactive
    date_min <- reactive(min(highlighted_dataframe()[["date"]]))
    date_max <- reactive(max(highlighted_dataframe()[["date"]]))

    observe({
      shiny::updateDateRangeInput(
        session = session,
        inputId = "dateRange",
        start = date_min(),
        end = date_max()
      )
    })

    group_vol_time_reactive <- reactive({
      if(nrow(highlighted_dataframe()) < 1){
          validate("You must select data first to view a grouped sentiment plot")}

    group_vol_time_plot <- highlighted_dataframe() %>%
          dplyr::filter(date >= input$dateRangeGroupVol[[1]],
                        date <= input$dateRangeGroupVol[[2]]) %>%
          group_vol_plot <- LandscapeR::ls_plot_group_vol_time(
            group_var = input$groupVarVol,
            date_var = date,
            unit = input$dateBreak,
            nrow = input$nrow,
          )

          group_vol_plot <- group_vol_plot + 
          group_vol_time_titles$labels()

          return(group_vol_time_plot)
    })

    output$groupVolTime <- shiny::renderPlot({
      group_vol_time_reactive()
    }, 
    res = 100,
    height = input$height,
    width = input$width
    )


  })
}
    
## To be copied in the UI
# mod_group_vol_time_ui("group_vol_time_1")
    
## To be copied in the server
# mod_group_vol_time_server("group_vol_time_1")
