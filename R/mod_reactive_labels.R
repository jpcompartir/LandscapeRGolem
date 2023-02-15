#' reactive_labels UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_reactive_labels_ui <- function(id){
  ns <- NS(id)
  tagList(
    shinyWidgets::materialSwitch(
      inputId = ns("toggle"),
      label = "Customise Titles?",
      status = "primary",
      right = TRUE
    ),
    shiny::uiOutput(ns("titles")),
  )
}

#' reactive_labels Server Functions
#'
#' @noRd
mod_reactive_labels_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns

    output$titles <- shiny::renderUI({
      if(input$toggle == TRUE){
        shiny::tagList(
          shiny::textInput(
            inputId = ns("Title"), label = "Title",
            placeholder = "Write title here...", value =""
          ),
          shiny::textInput(
            inputId = ns("Subtitle"), label = "Subtitle",
            placeholder = "Write subtitle here...", value = ""
          ),
          shiny::textInput(
            inputId = ns("Caption"), label = "Caption",
            placeholder = "Write caption here...", value = ""
          ),
          shiny::textInput(
            inputId = ns("Xlabel"), label = "X axis title",
            placeholder = "Write x axis title here...."
          ),
          shiny::textInput(
            inputId = ns("Ylabel"), label = "Y axis title",
            placeholder = "Write y axis title here...."
          )
        )
      }
    })

    labels <- shiny::reactive({
      ggplot2::labs(
        title = input$Title,
        subtitle = input$Subtitle,
        caption = input$Caption,
        x = input$Xlabel,
        y = input$Ylabel
      )
    })

    return(list(labels = labels))


  })
}

## To be copied in the UI
# mod_reactive_labels_ui("reactive_labels_1")

## To be copied in the server
# mod_reactive_labels_server("reactive_labels_1")


# plot_type_title <- stringr::str_to_title(plot_type)
#
# shiny::renderUI({
#   if (input[[paste0("toggle", plot_type_title, "titles")]]) {
#     shiny::tagList(
#       shiny::textInput(
#         inputId = paste0(plot_type, "Title"), label = "Title",
#         placeholder = "Write title here...", value = ""
#       ),
#       shiny::textInput(
#         inputId = paste0(plot_type, "Subtitle"), label = "Subtitle",
#         placeholder = "Write subtitle here...", value = ""
#       ),
#       shiny::textInput(
#         inputId = paste0(plot_type, "Caption"), label = "Caption",
#         placeholder = "Write caption here...", value = ""
#       ),
#       shiny::textInput(
#         inputId = paste0(plot_type, "Xlabel"), label = "X axis title",
#         placeholder = "Write the x axis title here..."
#       ),
#       shiny::textInput(
#         inputId = paste0(plot_type, "Ylabel"), label = "Y axis title",
#         placeholder = "Write the y axis title here"
#       )
#     )
#   }
# })
# }
