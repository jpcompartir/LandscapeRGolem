#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  shiny::shinyOptions(plot.autocolors = TRUE)
  # ns <- NS(id) #Why was this commented out, need to remember perhaps
  tagList(
    tags$head(
      tags$link(
        rel = "stylesheet",
        type = "text/css",
        href = "styles.css"
      ),
    ),
    shinyjs::useShinyjs(),
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    shiny::navbarPage(title = "Conversation Landscape",
                      id = "navBar",
                      theme = shinythemes::shinytheme("cosmo"),
                      htmltools::tags$style(type = "text/css", "body {padding-top: 70px;}"),
                      # Prevents the navbar from eating body of app
                      # colours all 10  sliders orange
                      shinyWidgets::setSliderColor(color = rep("#ff7518", 20), sliderId = c(1:20)),

                      htmltools::tags$style(type = "text/css", ".irs-handle {background-color: #ff7518;}"),
                      # Render each tab via its respective module
                      shiny::tabPanel( #First page of the app
                        "Landing Page",
                        mod_landing_page_ui("xd")
                      ),
                      shiny::tabPanel(
                        "Survey Landscape",
                        mod_conversation_landscape_ui("landscapeTag")),
                        shiny::tabPanel(
                          "Bigram Network",
                            mod_bigram_network_ui(id = "bigramTag")),
                      shiny::tabPanel(
                        "Distribution Tab",
                        mod_distribution_tab_ui(id = "distributionTag")
                      ),
                      shiny::tabPanel(
                        "Weighted Log-odds",
                        mod_wlos_ui(id = "wlosTag")
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
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "LandscaperGolem"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
