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
      shiny::column(6,
                    shiny::HTML("
                  <h1>Welcome to <span style='color: #0f50d2;'>LandscapeR!</span></h1>
                  <br>
                  <p><span style='color: #0f50d2;'>LandscapeR</span> is SHARE and Capture's application for creating navigable conversation maps from unstructured text data. This application will allow you to interactively clean, inspect and chart a conversation which has been embedded, clustered, and had its dimensions reduced.</p>
                  <br>
                  <p><b>If you are familiar</b> with  <span style='color: #0f50d2;'>LandscapeR</span>, you should <b>move directly</b> to the <b>Survey Landscape tab</b> to start analysing your mapped conversation.

                  "),
                    ),
    ),
    shiny::fluidRow(
      shiny::column(3,
                    shiny::HTML("<h2><b>Starting Out</b></h2>
                  <p>Head over to the Survey Landscape tab, use your mouse or trackpad to select regions of the conversation landscape, and watch the data table populate to the right. You can search for specific keywords using the pattern widget.</p>
                  ")),
      shiny::column(3,
                    shiny::HTML("<h2><b>Downloading Data</b></h2>
                               <p>You can download all of the remaining data, or only the selected data using the download widgets. If you want to delete some data, you must highlight it first and then click the delete button found in the bottom right corner of the map. Your deletions will be reflected when you download all data.</p>")),
      shiny::column(6,
                    shiny::HTML("<h2><b>Viewing Summary Plots</b></h2>
                                <p>There are currently <b>three plotting tabs</b> you can work with.</p>
                      <li><b>Bigram Network</b> is for rendering a bigram network from your highlighted data. This will help you to gauge how clean your selections are. </li>
                      <li><b>Distribution Tab</b> is for looking at your selection's volume over time, sentiment distribution, and frequent words.</li>
                  <li><b>Weighted Log-odds</b> is for comparing the distinctness of text between groups</li>
                  <br>")
                    )
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
