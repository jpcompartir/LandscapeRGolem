#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session, data) {
  if (is.null(data)) {
    data <- utils::read.csv("~/Google Drive/My Drive/data_science_project_work/microsoft/project_work/624_ai_landscape_refresh/data/624_topic_df.csv") %>%
      stats::na.omit() %>%
      dplyr::select(-cluster) %>%
      dplyr::rename(cluster = topic) %>%
      dplyr::mutate(date = as.Date(date)) %>%
      dplyr::slice_sample(n = 10000)
  }

  # pattern <- shiny::reactiveVal(value = "", {})
  # shiny::observeEvent(input$filterPattern, {
  #   pattern(input$Regex)
  # })


  shiny::observe({
    # Original functionality: update remove_range's values on delete button press
    req(length(remove_range$keep_keys) > 0)
    remove_range$remove_keys <- selected_range()$key
    remove_range$keep_keys <- remove_range$keep_keys[!remove_range$keep_keys %in% remove_range$remove_keys]

    # Clear the values in selected_range()
    # selected_range(list())
  })


  # This is for passing reactive values to and from modules
  r <- reactiveValues(
    colour_var = NULL,
    column_names = colnames(data),
    global_group_var = "cluster",
    global_subgroups = NULL,
    virid_colours = viridis::viridis_pal(option = "H")(50),
    date_min = min(data$date, na.rm = TRUE),
    date_max = max(data$date, na.rm = TRUE)
    )


  mod_conversation_landscape_server("landscapeTag",
    reactive_dataframe = reactive_data,
    highlighted_dataframe = df_filtered,
    selected_range = selected_range,
    r = r
  )

  mod_distribution_tab_server(
    id = "distributionTag",
    highlighted_dataframe = df_filtered,
    r = r
  )

  mod_bigram_network_server("bigramTag",
    highlighted_dataframe = df_filtered
  )

  mod_compare_groups_server("compareGroupsTag",
    highlighted_dataframe = df_filtered,
    r = r
  )

  mod_labelled_tab_server(
    id = "labelledTag",
    reactive_dataframe = reactive_data,
    data = data,
    r = r
  )

  # Create reactive data from data. Filters on inputs of sliders in umap_plot, defaulting values to 10.
  # Then create a reactive dependency on remove_range$keep_keys, s.t. any change in remove_range makes a change here.
  # Keys from selected_range move into remove_range$remove_keys when the delete button is pressed. $remove_keys and $keep_keys are the inverse of one another.
  # reactive_data() also takes care of the filtering via a pattern
  reactive_data <- shiny::reactive({
    data <- data %>%
      dplyr::filter(V1 > r$x1[[1]], V1 < r$x1[[2]], V2 > r$y1[[1]], V2 < r$y1[[2]]) %>%
      dplyr::filter(document %in% remove_range$keep_keys) %>% # Filtering for the keys not in remove_range$remove_keys
      dplyr::filter(grepl(r$filterPattern, text, ignore.case = TRUE))

    # if(!is.null(r$filterPattern) && is.character(r$filterPattern)) {
    #   data <- data %>%
    #     dplyr::filter(grepl(r$filterPattern, text, ignore.case = TRUE))
    # }

    return(data)
  })

  #---- Delete IDS ----
  remove_range <- shiny::reactiveValues(
    keep_keys = data %>% dplyr::pull(document), # Get the original IDs saved and save an object for later adding selected points to remove
    remove_keys = NULL
  )

  # Instantiate a reactive value, then update that value dynamically when points are selected. ----
  selected_range <- shiny::reactiveVal({})

  shiny::observeEvent(plotly::event_data("plotly_selected"), {
    selected_range(plotly::event_data("plotly_selected"))
  })

  #---- key for filtering reactive_data and creating df_filtered ----
  # key <- reactive({
  #   selected_range()$key
  # })

  #---- filtered_df ----
  # Used for rendering the fully responsive data table - consider changing this to highlighted_dataframe (it's passed as that nearly everywhere)
  df_filtered <- reactive({
    df_filtered <- reactive_data() %>%
      dplyr::filter(document %in%  selected_range()$key)
  })



}
