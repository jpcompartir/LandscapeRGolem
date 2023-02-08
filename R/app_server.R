#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {

pattern <- shiny::reactiveVal(value = "", {})
shiny::observeEvent(input$filterPattern, {
  pattern(input$Regex)
})

  mod_conversation_landscape_server("landscapeTag", reactive_dataframe = reactive_data)

  #Create reactive data from data. Filters on inputs of sliders in umap_plot, defaulting values to 10.
  #Then create a reactive dependency on remove_range$keep_keys, s.t. any change in remove_range makes a change here.
  #Keys from selected_range move into remove_range$remove_keys when the delete button is pressed. $remove_keys and $keep_keys are the inverse of one another.
  #reactive_data() also takes care of the filtering via a pattern
  reactive_data <- shiny::reactive({

    data <- LandscapeR::ls_example

    #Uncommenting currently breaks the app, presumably because input$x1, y1, etc. are not being read in this environment. Potential strategy...
    data <- data %>%
      dplyr::filter(V1> input[["x1"]][[1]], V1 < input[["x1"]][[2]], V2 > input[["y1"]][[1]], V2 < input[["y1"]][[2]]) #%>% #Slider input ranges
      #   dplyr::filter({{ id }} %in% remove_range$keep_keys) %>% #Filtering for the keys not in remove_range$remove_keys
      #   dplyr::filter(grepl(input$filterPattern, {{ text_var }}, ignore.case = TRUE))

      return(data)

  })
}
