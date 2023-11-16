#' compare_groups UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_compare_groups_ui <- function(id) {
  ns <- NS(id)
  tagList(
    bslib::page_fillable(
      mod_c_groups_global_ui(ns("groupGlobalsTag")),
      bslib::accordion(
        id = ns("compareGroupsAccordion"),
        open = TRUE,
        bslib::accordion_panel(
          title = "Weighted log-odds",
          value = "wlosAccordion",
          mod_wlos_ui(ns("wlosTag")),
        ),
        bslib::accordion_panel(
          title = "Group Sentiment Distribution",
          value = "groupSentAccordion",
          mod_group_sentiment_ui(ns("groupSentimentTag")),
        ),
        bslib::accordion_panel(
          title = "Group Volume Over Time",
          value = "groupVolAccordion",
          mod_group_vol_time_ui(ns("groupVolTimeTag"))
        )
      )
    )
  )
}

#' compare_groups Server Functions
#'
#' @noRd
mod_compare_groups_server <- function(id, highlighted_dataframe, r, start_up_values) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    #add the mod_c_groups_server
    mod_c_groups_global_server("groupGlobalsTag",
                               highlighted_dataframe = highlighted_dataframe,
                               start_up_values = start_up_values,
                               r = r)

    mod_wlos_server("wlosTag",
                    highlighted_dataframe = highlighted_dataframe,
                    r = r)

    mod_group_sentiment_server("groupSentimentTag",
                               highlighted_dataframe = highlighted_dataframe,
                               r = r)

    mod_group_vol_time_server("groupVolTimeTag",
                              highlighted_dataframe = highlighted_dataframe,
                              r = r)

  })
}

## To be copied in the UI
# mod_compare_groups_ui("compare_groups_1")

## To be copied in the server
# mod_compare_groups_server("compare_groups_1")
