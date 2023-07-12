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
                    offset = 1,
                    shiny::HTML("
<h1>Welcome to <span style='color: #ff7518;'>LandscapeR!</span></h1>
                  <br>
                  <p><span style='color: #ff7518;'>LandscapeR</span> is SHARE and Capture's application for creating navigable conversation maps from unstructured text data. This application will allow you to interactively clean, inspect and chart a conversation which has been embedded, clustered or topic modelled, and had its dimensions reduced.</p>
                  <br>
                  <p><b>If you are familiar</b> with  <span style='color: #ff7518;'>LandscapeR</span>, you should <b>move directly</b> to the <b>Survey Landscape tab</b> to start analysing your mapped conversation. If not: <a href='https://jpcompartir.github.io/LandscapeR/' target='blank'>click here</a>
                  </p>
                  "),
      ),
shiny::column(3,
              shiny::tags$img(width = 300, height = 300, src = "www/images/landscaper.png")
              ),
    ),
shiny::fluidRow(
  shiny::column(offset = 1,
                width = 3,
                shiny::HTML("<h2><b>Start</b></h2>
                  <p>Head over to the Survey Landscape tab, use your mouse or trackpad to select regions of the conversation landscape, and watch the data table populate to the right. Use plotly's lasso or box selection tools to highlight interesting areas of the map.</p>
                  <p> Once you've highlighted some data, you can delete it by clicking the delete button which appears, or label it by typing a label and clicking the label button that appears. Your labelled data will populate a data table in the Labelled Data tab.</p>
                  "),
                shiny::tagList(
                  shiny::HTML('<div class="tipblock">
                      <b>Tip</b>: <i>You can filter for specific keywords or regex patterns using the pattern widget.</i>
                      </div>')
                )),
  shiny::column(2,
                shiny::HTML("<h2><b>Download</b></h2>
                               <p>You can download all of the remaining data, or only the selected data using the respective download widgets in the Survey Landscape tab. You can download your labelled data by visiting the Labelled Data tab.</p>
                            <p>Deleted data can only be retrieved by resetting the app. </p>")),
  shiny::column(3,
                shiny::HTML("<h2><b>Visualise</b></h2>
                                <p>There are currently <b>three plotting tabs</b> you can work with. Each plotting tab will use the data you have selected to create its plots; so make sure to select data in the Survey Landscape tab before moving to the plotting tabs. </p>
                      <li><b>Bigram Network</b> is for rendering a bigram network from your highlighted data. This will help you to gauge how clean your selections are. </li>
                      <li><b>Distribution Tab</b> is for looking at your selection's volume over time, sentiment distribution, and frequent words.</li>
                  <li><b>Compare Groups</b> is for comparing the distinctness of text between groups, and grouped sentiment + volume comparisons.</li>
                  <br>
                  "),
                shiny::tagList(
                  shiny::HTML("<div class='tipblock'>
                  <b>Tip</b>: <i>Some plots have a draggable element, you can use this to make sure the plot doesn't overlap the plot below.</i></div>")
                )
  ),
  shiny::column(2,
                shiny::HTML("<h2><b>Reset</b></h2>
                                <p>If you make a mistake, or wish to reset the application to its initial state for any reason, you can refresh the page, or restart the application. <b> Be careful </b> when doing this as your progress will <b>not be saved</b>. Make sure that you have downloaded any data that you wish to keep.</p>
                                <p>It's important to remember that unless you tell the application to do so, it will reload with the data as it was when you first encountered it.</p>")
  )
  ),

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
