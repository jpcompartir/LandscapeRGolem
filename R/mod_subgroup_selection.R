#' subgroup_selection UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_subgroup_selection_ui <- function(id){
  ns <- NS(id)
  tagList(
    shinyWidgets::pickerInput(
      inputId = ns("subGroupsPicker"),
      label = "levels of grouping variable",
      choices = NULL,
      options = shinyWidgets::pickerOptions(
        class = 'custom-picker',
        actionsBox = TRUE,
        size = 10,
        selectedTextFormat = "count > 3"
      ),
      multiple = TRUE
  )
  )
}

#' subgroup_selection Server Functions
#'
#' @noRd
mod_subgroup_selection_server <- function(id,  highlighted_dataframe, group_var_reactive){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    subgroup_choices <- reactive({
      # browser()
      req(nrow(highlighted_dataframe()) > 1, group_var_reactive() != "")
      highlighted_dataframe() %>%
        dplyr::pull(group_var_reactive()) %>%
        unique()
    })

    observe({
      shinyWidgets::updatePickerInput(session, "subGroupsPicker", choices = subgroup_choices(), selected = subgroup_choices())
    })

  })
}

## To be copied in the UI
# mod_subgroup_selection_ui("subgroup_selection_1")

## To be copied in the server
# mod_subgroup_selection_server("subgroup_selection_1")
