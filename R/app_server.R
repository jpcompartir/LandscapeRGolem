#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {

  data <- LandscapeR::ls_example

pattern <- shiny::reactiveVal(value = "", {})
shiny::observeEvent(input$filterPattern, {
  pattern(input$Regex)
})


  #This is for passing reactive values to and from modules
  r <- reactiveValues()

  r$date_min = min(data$date)
  r$date_max = max(data$date)

  mod_conversation_landscape_server("landscapeTag",
                                    reactive_dataframe = reactive_data,
                                    highlighted_dataframe = df_filtered,
                                    selected_range = selected_range,
                                    r = r)

  mod_distribution_tab_server(id = "distributionTag",
                              highlighted_dataframe = df_filtered)

  mod_bigram_network_server("bigramTag",
  highlighted_dataframe = df_filtered)

  mod_compare_groups_server("compareGroupsTag",
  highlighted_dataframe = df_filtered)

  mod_labelled_tab_server(id = "labelledTag",
                          reactive_dataframe = reactive_data,
                          r = r)

  #Create reactive data from data. Filters on inputs of sliders in umap_plot, defaulting values to 10.
  #Then create a reactive dependency on remove_range$keep_keys, s.t. any change in remove_range makes a change here.
  #Keys from selected_range move into remove_range$remove_keys when the delete button is pressed. $remove_keys and $keep_keys are the inverse of one another.
  #reactive_data() also takes care of the filtering via a pattern
  reactive_data <- shiny::reactive({

    #Uncommenting currently breaks the app, presumably because input$x1, y1, etc. are not being read in this environment. Potential strategy...
    data <- data %>%
      dplyr::filter(V1 > r$x1[[1]], V1 < r$x1[[2]], V2 > r$y1[[1]], V2 < r$y1[[2]]) %>%
      # dplyr::filter(V1> input[["x1"]][[1]], V1 < input[["x1"]][[2]], V2 > input[["y1"]][[1]], V2 < input[["y1"]][[2]]) %>% #Slider input ranges
      dplyr::filter(document %in% remove_range$keep_keys) %>% #Filtering for the keys not in remove_range$remove_keys
      dplyr::filter(grepl(r$filterPattern, text, ignore.case = TRUE))

      return(data)

  })

  #---- Delete IDS ----
  remove_range <- shiny::reactiveValues(
    keep_keys = data %>% dplyr::pull(document), # Get the original IDs saved and save an object for later adding selected points to remove
    remove_keys = NULL
  )

  shiny::observeEvent(input$delete, { # Update remove_range's values on delete button press
    req(length(remove_range$keep_keys) > 0)
    remove_range$remove_keys <- selected_range()$key
    remove_range$keep_keys <- remove_range$keep_keys[!remove_range$keep_keys %in% remove_range$remove_keys]
  })

  # Instantiate a reactive value, then update that value dynamically when points are selected. ----
  selected_range <- shiny::reactiveVal({})

  shiny::observeEvent(plotly::event_data("plotly_selected"), {
    selected_range(plotly::event_data("plotly_selected"))
  })

  #---- key ----
  key <- reactive({
    selected_range()$key
  })

  #---- filtered_df ----
  #Used for rendering the fully responsive data table
  #consider changing this to highlighted_dataframe
  df_filtered <- reactive({
    df_filtered <- reactive_data() %>%
      dplyr::filter(document %in% key())
  })


}
