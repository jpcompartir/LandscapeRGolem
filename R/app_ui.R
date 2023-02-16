#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  # ns <- NS(id) #Why was this commented out, need to remember perhaps
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    shiny::navbarPage(title = "Conversation Landscape",
                      theme = shinythemes::shinytheme("cosmo"),
                      htmltools::tags$style(type = "text/css", "body {padding-top: 70px;}"), # Prevents the navbar from eating body of app
                      # colours all 10  sliders orange
                      shinyWidgets::setSliderColor(color = rep("#ff7518", 10), sliderId = c(1:10)),

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
                        mod_bigram_network_ui(id = "bigramPlot")
                      ),
                      shiny::tabPanel(
                        "Distribution Tab",
                        mod_distribution_tab_ui(id = "distributionTab")
                      ),
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
