#' landing_page UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_landing_page_ui <- function(id){
  ns <- NS(id)
  tagList(
    shiny::fluidRow(
      shiny::column(5,
                    shiny::HTML("
                  <h1>Welcome to <span style='color: #0f50d2;'>LandscapeR</span></h1>
                  <br>
                  <p><span style='color: #0f50d2;'>LandscapeR</span> is SHARE and Capture's application for creating navigable conversation maps from unstructured text data</p>
                  <p>There are currently <b>four tabs</b> you can work with. The main tab is 'Survey Landscape', each of the remaining tabs require you to have selected data inside this tab, for their various plots to render.</p>
                  <li><b>Bigram Network</b> is for rendering a bigram network from your highlighted data. This will help you to gauge how clean your selections are. </li>
                  <li><b>Distribution Tab</b> is for looking at your selection's volume over time, sentiment distribution, and frequent words.</li>
                  <li><b>Weighted Log-odds</b> is for comparing the distinctness of text between groups</li>
                  <br>
                  <h2>Starting out</h2>
                  <p>Head over to the Survey Landscape tab, use your mouse or trackpad to select regions of the conversation landscape, and watch the data table populate to the right. You can search for specific keywords using the pattern widget.</p>
                  ")
                    ),

    )
  )
}

#' landing_page Server Functions
#'
#' @noRd
mod_landing_page_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

  })
}

## To be copied in the UI
# mod_landing_page_ui("landing_page_1")

## To be copied in the server
# mod_landing_page_server("landing_page_1")
share_colours <- c("#0f50d2", "#000000", "#7800c6", "#ffb600", "#ff4e00", "#eb84c1","#ffa67f", "#d80a83", "#bb7fe2", "#7f7f7f","#bfbfbf", "#00b140")
