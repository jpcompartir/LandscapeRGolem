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
          inputId = ns("tabGroupVar"),
          label = "grouping variable",
          choices = NULL,
          selected = NULL
          # choices = "cluster",
          # selected = "cluster"
          )
      ),
      mod_subgroup_selection_ui(ns("subgroups")),
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


    # Pull the unique choices to send to the subgroups module
    group_var_reactive <- reactive({
      # browser()
      input$tabGroupVar
    })

    mod_subgroup_selection_server("subgroups", highlighted_dataframe, group_var_reactive)

    #Shinyjs disable/enable groups
    observe({
      if (nrow(highlighted_dataframe()) > 0) {
        shinyjs::enable("groupsRow")
      } else {
        shinyjs::disable("groupsRow")
      }
    })


    #Update the group variable
    observe({
      shiny::updateSelectInput(
        session,
        inputId = "tabGroupVar",
        choices = r$column_names,
        selected = group_var_reactive()
      )
    })

  })
}

## To be copied in the UI
# mod_c_groups_global_ui("c_groups_global_1")

## To be copied in the server
# mod_c_groups_global_server("c_groups_global_1")
