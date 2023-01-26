#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic

  reactive_data <- shiny::reactive({

    dt <- LandscapeR::ls_example

    # dt %>%
    #   dplyr::filter(V1> input$x1[[1]], V1 < input$x1[[2]], V2 > input$y1[[1]], V2 < input$y1[[2]]) %>%
    #   dplyr::filter({{ id }} %in% remove_range$keep_keys) %>%
    #   dplyr::filter(grepl(input$filterPattern, {{ text_var }}, ignore.case = TRUE))
    dt

  })

  mod_conversation_landscape_server("landscapeTag", xd = reactive_data)
}
