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

  # This is for passing reactive values to and from modules
  r <- reactiveValues(
    colour_var = NULL,
    column_names = colnames(data),
    global_group_var = "cluster",
    global_subgroups = NULL,
    date_min =  min(data$date, na.rm = TRUE),
    date_max = max(data$date, na.rm = TRUE),
    virid_colours = viridis::viridis_pal(option = "H")(50),
    keep_keys = data %>% dplyr::pull(document),
    remove_keys = NULL)

  mod_conversation_landscape_server("landscapeTag",
    reactive_dataframe = reactive_data,
    highlighted_dataframe = df_filtered,
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
      dplyr::filter(V1 > r$x1[[1]], V1 < r$x1[[2]], V2 > r$y1[[1]], V2 < r$y1[[2]]) #%>%

    if(!is.null(r$remove_keys)){
    data <- data %>%
      dplyr::filter(document %in% r$keep_keys) # Filtering for the keys not in remove_range$remove_keys
    }


    # browser()
    if(r$filterPattern != ""){
      data <- data %>%
        dplyr::filter(grepl(r$filterPattern, text, ignore.case = TRUE))
    }

    return(data)
  })

  #---- filtered_df ----
  # Used for rendering the fully responsive data table - consider changing this to highlighted_dataframe (it's passed as that nearly everywhere)
  df_filtered <- eventReactive(plotly::event_data("plotly_selected"),{

    # browser()
    # req(r$selected_range)
    df_filtered <- reactive_data() %>%
      dplyr::filter(document %in% r$selected_range)

    df_filtered
  })


}
