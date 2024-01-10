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
      shiny::column(2, uiOutput(ns("selectColumn"))),
      shiny::column(3, uiOutput(ns("selectSubgroups"))),
      shiny::column(1, uiOutput(ns("filterSubgroups")))
      # shiny::column(1, uiOutput(ns("filterSubgroups")))
    ),
    shiny::dataTableOutput(ns("table"))
  )
}

#' c_groups_global Server Functions
#'
#' @noRd
mod_c_groups_global_server <- function(id, highlighted_dataframe, grouped_data, r){
  moduleServer(id, function(input, output, session){
    ns <- session$ns


    # grouping_variables <- reactive({
    #   # Block looks redundant, what does it do? browser() not triggering
    #   req(isTruthy(highlighted_dataframe()))
    #   sort(get_group_variables(highlighted_dataframe()))
    #   browser()
    # })

    output$selectColumn <- renderUI({
      if(nrow(highlighted_dataframe()) > 0){
        shiny::tagList(
          shinyWidgets::pickerInput(
            inputId = ns("column"),
            label = "select column",
            choices = r$grouping_variables,
            selected = r$grouping_variables[[1]],
            options = shinyWidgets::pickerOptions(
              class = 'custom-picker',
              actionsBox = TRUE,
              size = 10,
              selectedTextFormat = "count > 3")
          )
        )
      }
    })

    subgroups <- reactive({
      if(isTruthy(input$column)){
        highlighted_dataframe() %>%
          dplyr::pull(input$column) %>%
          unique() %>%
          sort()
      }
    })

    output$selectSubgroups <- renderUI({
      if(isTruthy(input$column)){
        shiny::tagList(
          shinyWidgets::pickerInput(
            inputId = ns("subgroups"),
            label = "select subgroups",
            choices = subgroups(),
            selected = subgroups(),
            multiple = TRUE,
            options = shinyWidgets::pickerOptions(
              class = 'custom-picker',
              actionsBox = TRUE,
              size = 10,
              selectedTextFormat = "count > 3")
          )
        )
      }
    })

    output$filterSubgroups <- renderUI({
      if(isTruthy(input$subgroups) & isTruthy(input$column)){
        shiny::tagList(
          shiny::actionButton(
            class = "btn-subgroups-update",
            inputId = ns("updateSubgroups"),
            label = "update")
        )
      }
    })


    group_df_filtered <- eventReactive(c(input$updateSubgroups, highlighted_dataframe()),{
      .group_data <- NULL
      if(nrow(highlighted_dataframe())> 1){
        if(isTruthy(input$column) & isTruthy(input$subgroups)){

          #Sanity check
          print(paste0("Column: ", input$column, "Subgroups: ", input$subgroups))

          .group_data <- highlighted_dataframe() %>%
            dplyr::mutate(!!dplyr::sym(input$column) := as.factor(!!dplyr::sym(input$column))) %>%
            dplyr::filter(!!dplyr::sym(input$column) %in% as.factor(input$subgroups))
        }
      }
      .group_data
    })

    observeEvent(c(input$updateSubgroups, highlighted_dataframe()),{
      r$grouped_data <- group_df_filtered
      r$global_group_var <- input$column

    })
  })
}

## To be copied in the UI
# mod_c_groups_global_ui("c_groups_global_1")

## To be copied in the server
# mod_c_groups_global_server("c_groups_global_1")
