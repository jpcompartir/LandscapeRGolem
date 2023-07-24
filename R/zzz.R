globalVariables(c(".data", ":=", "V1", "V2", "clean_text", "cluster", "document", "mention_content", "permalink", "sentiment", "text", "topic"))

search_widget <- function (inputId, label = NULL, value = "", placeholder = NULL,
          btnSearch = NULL, btnReset = NULL, resetValue = "", width = NULL)
{

  value <- shiny::restoreInput(id = inputId, default = value)
  if (!is.null(btnSearch)) {
    btnSearch <- htmltools::tags$button(class = "btn btn-default btn-addon action-button",
                                        id = paste0(inputId, "_search"), type = "button",
                                        btnSearch)
  }
  if (!is.null(btnReset)) {
    btnReset <- htmltools::tags$button(class = "btn btn-default btn-addon action-button",
                                       id = paste0(inputId, "_reset"), type = "button",
                                       btnReset)
  }
  css_btn_addon <- paste0(".btn-addon{", "font-size:14.5px;",
                          "margin:0 0 0 0 !important;", "display: inline-block !important;",
                          "}")
  searchTag <- htmltools::tags$div(class = "form-group shiny-input-container",
                                   style = if (!is.null(width))
                                     paste0("width: ", validateCssUnit(width), ";"), if (!is.null(label))
                                       htmltools::tags$label(label, `for` = inputId), htmltools::tags$div(id = inputId,
                                                                                                          `data-reset` = !is.null(resetValue), `data-reset-value` = resetValue,
                                                                                                          class = "input-group search-text", htmltools::tags$input(id = paste0(inputId,
                                                                                                                                                                               "_text"), style = "border-radius: 16px!important; margin-right:5px;",
                                                                                                                                                                   type = "text", class = "form-control", value = value,
                                                                                                                                                                   placeholder = placeholder), htmltools::tags$div(class = "input-group-btn",
                                                                                                                                                                                                                   btnReset, btnSearch)), singleton(tags$head(tags$style(css_btn_addon))))
  shinyWidgets:::attachShinyWidgetsDep(searchTag)
}


wlos_text <- function(){
  text <- shiny::HTML(
    "
             <div class='row'>
              <div class='col-sm-6'>
              <p> Below you'll find a Weighted Log-odds (WLOs) Chart, this chart helps you to identify the key textual differences between groups. You can use this chart to understand why one cluster, topic, or grouping variable has been separated from the others.</p>
            <p> You can use the side panel to play with and set arguments. The important arguments to consider when rendering a WLOs chart are:</p>
                                   <ul>
                                   <li><b>top_n</b> = <i>the number of terms to show on each chart</i></li>
                                   <li><b>nrow</b> = <i>the number of rows to place the charts on</i></li>
                                   <li><b>top_terms_cutoff</b> = <i>the rank, in order of frequency, for a term to be included</i></li>
                                   <li><b>Select your grouping Variable</b> = <i>the name of the grouping variable you'd like to compare, e.g. topic, sentiment
            </i>
            </li>
            </ul>
              </div>
            </div>
            "
  )

  return(text)
}

bigram_text <- function(){
  text <- shiny::HTML(
    "
            <div class='row'>
              <div class='col-sm-6'>
            <p style='font-size: 14px;'>Below you'll find a bigram network, this network will help you estimate how clean your selected data is. Remember that long and connected chains of words may represent spam or unwanted mentions.</p>
          <p style='font-size:14px;'>This bigram network is restricted to a maximum of 5,000 data points for speed and user experience. It is therefore not recommended to be saved or exported. If the data looks clean, download the selection and create the network in the standard way in R/Rstudio. </p>
            </div>
            </div>
          ")

  return(text)
}
