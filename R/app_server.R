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
      dplyr::slice_sample(n = 1000)
  }

  stopifnot(c("text", "document", "clean_text", "permalink", "cluster", "sentiment", "V1", "V2", "date") %in% colnames(data))

  # This is for passing reactive values to and from modules
  r <- reactiveValues(
    colour_var = "cluster",
    column_names = colnames(data),
    global_group_var = "cluster",
    global_subgroups = NULL,
    date_min =  min(data$date, na.rm = TRUE),
    date_max = max(data$date, na.rm = TRUE),
    virid_colours = viridis::viridis_pal(option = "H")(50),
    keep_keys = data %>% dplyr::pull(document),
    remove_keys = NULL,
    selected_range = NULL)

  mod_conversation_landscape_server("landscapeTag",
    reactive_dataframe = reactive_data_output$reactive_data,
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
    reactive_dataframe = reactive_data_output$reactive_data,
    data = data,
    r = r
  )


  reactive_data_output <- mod_reactive_data_server(id =  "reactveData",
                                            data = data,
                                            r = r)

  #---- filtered_df ----
  # Used for rendering the fully responsive data table - consider changing this to highlighted_dataframe (it's passed as that nearly everywhere)
  df_filtered <- eventReactive(
    c(
      plotly::event_data("plotly_selected", source = "umap_plot"),
      input$`landscapeTag-umapPlot-deleteData-delete`),{

    df_filtered <- reactive_data_output$reactive_data() %>%
      dplyr::filter(document %in% r$selected_range)

    df_filtered
  })

}
