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
      id = ns("groupsRow"),
      shiny::column(
        3,
        shiny::selectInput(
          inputId = ns("groupVarGlobal"),
          label = "grouping variable",
          choices = NULL)
      ),
      shinyWidgets::pickerInput(
        inputId = ns("subGroups"),
        label = "levels of grouping variable",
        choices = NULL,
        options = shinyWidgets::pickerOptions(
          class = 'custom-picker',
          actionsBox = TRUE,
          size = 10,
          selectedTextFormat = "count > 3"),
        multiple = TRUE
      ),
      shiny::column(1,
                    shiny::actionButton(
                      class = "btn-subgroups-update",
                      inputId = ns("updateSubgroupsButton"),
                      label = "Go")
      )
    )
  )
}

#' c_groups_global Server Functions
#'
#' @noRd
mod_c_groups_global_server <- function(id, highlighted_dataframe, r){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    observe({
      if (nrow(highlighted_dataframe()) > 1) {
        shinyjs::enable("groupsRow")
      } else {
        shinyjs::disable("groupsRow")
      }
    })

    observe({
      shiny::updateSelectInput(
        session,
        inputId = "groupVarGlobal",
        choices = colnames(highlighted_dataframe()),
        selected = "cluster"
      )
    })

    observe({
      req(input$groupVarGlobal)

      r$global_group_var <- input$groupVarGlobal

      my_choices <- unique(
        highlighted_dataframe()[[input$groupVarGlobal]]
      )

      shinyWidgets::updatePickerInput(
        session,
        inputId = "subGroups",
        choices = my_choices,
        selected = my_choices
      )

      #Initialise with the current selections (to render plot when tab opens)
      r$current_subgroups <- my_choices
      r$new_subgroups <- my_choices
    })

    #Pass sub groups to r$
    observeEvent(input$subGroups, {
      r$global_subgroups <- input$subGroups
    })

    observe({
      r$new_subgroups <- input$subGroups
    })

    observeEvent(input$updateSubgroupsButton, {
      #Update the current subgroups when the button is pressed
      r$current_subgroups <- r$new_subgroups
    })

  })
}

## To be copied in the UI
# mod_c_groups_global_ui("c_groups_global_1")

## To be copied in the server
# mod_c_groups_global_server("c_groups_global_1")
