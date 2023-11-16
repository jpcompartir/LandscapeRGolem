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
          selected = NULL)
      ),
      shinyWidgets::pickerInput(
        inputId = ns("subGroups"),
        label = "levels of grouping variable",
        choices = c("Conversational AI", "AI Performance","AI Search", "Coding & Assistance", "AI & Business","AI-Powered Creativity", "AI Ethics & Society", "Risks & Challenges", "AI & Security"),
        options = shinyWidgets::pickerOptions(
          class = 'custom-picker',
          actionsBox = TRUE,
          size = 10,
          selectedTextFormat = "count > 3"
        ),
        selected = c("Conversational AI", "AI Performance","AI Search", "Coding & Assistance", "AI & Business","AI-Powered Creativity", "AI Ethics & Society", "Risks & Challenges", "AI & Security"),
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
mod_c_groups_global_server <- function(id, highlighted_dataframe, r, start_up_values){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    observe({
      if (nrow(highlighted_dataframe()) > 0) {
        shinyjs::enable("groupsRow")
      } else {
        shinyjs::disable("groupsRow")
      }
    })

    observe({
      shiny::updateSelectInput(
        session,
        inputId = "tabGroupVar",
        choices = colnames(highlighted_dataframe()),
        selected = "cluster"
        # selected = r$global_group_var
      )
    })


    # Update the reactive value global_group_bar when a new variable is selected
    observeEvent(input$tabGroupVar,{
      if(!is.null(input$tabGroupVar) && input$tabGroupVar != ""){
        r$global_group_var <- input$tabGroupVar
      }
    })

    #above works, below not quite.
    #----

    observe({
    #   (nrow( highlighted_dataframe() ) > 0
    #     )
    #   # browser()
      if(!is.null(input$tabGroupVar) && input$tabGroupVar != "" && nrow(highlighted_dataframe()) > 0){
        # unique(highlighted_dataframe()[[input$tabGroupVar]])
      # browser()
      shinyWidgets::updatePickerInput(
        session,
        inputId = "subGroups",
        choices =  unique(highlighted_dataframe()[[input$tabGroupVar]]),
        selected =  unique(highlighted_dataframe()[[input$tabGroupVar]])
      )

        r$current_subgroups <-  unique(highlighted_dataframe()[[input$tabGroupVar]])
        r$new_subgroups <-  unique(highlighted_dataframe()[[input$tabGroupVar]])
      }

    })

    observe({
      if(!is.null(input$tabGroupVar) && input$tabGroupVar != "" && nrow(highlighted_dataframe()) > 0){
      #Initialise them so plots load
      r$current_subgroups <-  unique(highlighted_dataframe()[[input$tabGroupVar]])
      r$new_subgroups <-  unique(highlighted_dataframe()[[input$tabGroupVar]])
      }
    })

    #Temporary store of the new subgroups before updating the plot
    observeEvent(c(highlighted_dataframe(), input$subGroups, input$updateSubgroupsButton), {
      if(!is.null(input$subGroups) && all(input$subGroups != "")) {
        r$new_subgroups <- input$subGroups
      }

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
