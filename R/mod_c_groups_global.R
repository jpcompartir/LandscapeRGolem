#' c_groups_global UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_c_groups_global_ui <- function(id){
  ns <- NS(id)
  tagList(
    shiny::fluidRow(
      shiny::column(
        2,
        shiny::selectInput(
          inputId = ns("groupVarGlobal"),
          label = "select your grouping variable",
          choices = NULL)
      ),
        shinyWidgets::pickerInput(
          inputId = ns("subGroups"),
          label = "Select:",
          choices = NULL,
          options = pickerOptions(
            class = 'custom-picker',
            actionsBox = TRUE,
            size = 10,
            selectedTextFormat = "count > 3"),
          multiple = TRUE
        )
    )

    # shiny::selectizeInput(
    #   inputId = ns("subGroups"),
    #   label = "select your subgroups",
    #   choices = NULL,
    #   multiple = TRUE
    # )
    #   shiny::checkboxGroupInput(ns("subGroups"),
    #                             label = "Select your subgroups",
    #                             choices = NULL,
    #                             inline = TRUE)

  )
}

#' c_groups_global Server Functions
#'
#' @noRd
mod_c_groups_global_server <- function(id, highlighted_dataframe, r){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    observe({
      shiny::updateSelectInput(session,
                               inputId = "groupVarGlobal",
                               choices = colnames(highlighted_dataframe()),
                               selected = "cluster"
      )
    })

    observe({
      req(input$groupVarGlobal)

      r$globalGroupVar <- input$groupVarGlobal

      my_choices <- unique(
        highlighted_dataframe()[[input$groupVarGlobal]]
      )

      shinyWidgets::updatePickerInput(
        session,
        inputId = "subGroups",
        choices = my_choices,
        selected = my_choices
      )
    })


  })
}

## To be copied in the UI
# mod_c_groups_global_ui("c_groups_global_1")

## To be copied in the server
# mod_c_groups_global_server("c_groups_global_1")
