#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  shiny::shinyOptions(plot.autocolors = TRUE)
  options(spinner.color = "#ff7518")

  #Global UI Variables
  distribution_tab_height <- 400 #defaults for the plots in distrbution tab
  distribution_tab_width <-  450


  # ns <- NS(id) #Why was this commented out, need to remember perhaps
  tagList(
    tags$head(
      tags$link( # link to the inst/www/styles.css sheet for styling of various elements
        rel = "stylesheet",
        type = "text/css",
        href = "styles.css"
      ),
      #Call the tags$style here to avoid conflicts with bslib (runtime execution)
      tags$style(HTML("
.dataTables_wrapper .dataTables_paginate .page-link:focus, .dataTables_wrapper .dataTables_paginate .page-link:focus:hover {
  background-color: #ff7518 !important;
  border-color: #ff7518 !important;
  outline: none !important;
  box-shadow: none !important;
  color: #ffffff !important;
}

.page-item.active .page-link {
  background-color: #ff7518 !important;
  border-color: #ff7518 !important;
  color: #ffffff !important;
}
  "))
    ),
    shinyjs::useShinyjs(),
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    shiny::navbarPage(
      theme = bslib::bs_theme(
        version = 5,
        bootswatch = "cosmo",
        `enable-rounded` = TRUE,
        `navbar-bg` = "#000000",
        primary = "#ff7518",
        secondary = "#000000",
        fg = "#000",
        bg = "white"),
      # theme = shinythemes::shinytheme("cosmo"),
      title = "LandscapeR",
      id = "navBar",
      htmltools::tags$style(type = "text/css", "body {padding-top: 70px;}"),
      # Prevents the navbar from eating body of app
      # colours all 10  sliders orange
      shinyWidgets::setSliderColor(color = rep("#ff7518", 40), sliderId = c(1:40)),
      # Render each tab via its respective module
      shiny::tabPanel( # First page of the app
        title = "Home",
        icon = shiny::icon("house"),
        mod_landing_page_ui("xd")
      ),
      shiny::tabPanel(
        title = "Landscape",
        mod_conversation_landscape_ui("landscapeTag"),
        icon = shiny::icon("map-location-dot")
      ),
      shiny::tabPanel(
        title = "Bigram Network",
        value = "bigramTab",
        mod_bigram_network_ui(id = "bigramTag"),
        icon = shiny::icon("network-wired")
      ),
      shiny::tabPanel(
        title = "Distribution Tab",
        value = "distributionTab",
        mod_distribution_tab_ui(
          distribution_tab_height = distribution_tab_height,
          distribution_tab_width = distribution_tab_width,
          id = "distributionTag"),
        icon = shiny::icon("chart-simple")
      ),
      shiny::tabPanel(
        title = "Compare Groups",
        value = "compareGroups",
        mod_compare_groups_ui("compareGroupsTag"),
        icon = shiny::icon("not-equal")
      ),
      shiny::tabPanel(
        title = "Labelled Data",
        mod_labelled_tab_ui("labelledTag"),
        icon = shiny::icon("check"),
      )
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(ext = "png"),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "LandscaperGolem"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
