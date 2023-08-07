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


wlos_text <- function() {
  text <- shiny::HTML(
    "
  <div class='row'>
    <div class='col-sm-6'>
      <p> Below you'll find a Weighted Log-odds (WLOs) Chart, this chart helps you to identify the key textual differences between groups. You can use this chart to understand why one cluster, topic, or grouping variable has been separated from the others.
  <br>
  The important inputs to consider when rendering a WLOs chart are:
  </p>
    <ul>
    <li><b>top_n</b> = <i>the number of terms to show on each chart</i></li>
    <li><b>number of rows</b> = <i>the number of rows to place the charts on</i></li>
    <li><b>top terms cutoff</b> = <i>the minimum rank, in order of frequency, for a term to be included</i></li>
    <li><b>filter by</b> = <i>determines how the data should be filtered</i>
    <ul>
  <li><b>association</b> = Take the most frequent [top terms cutoff] terms, then take the most associated [top_n] terms per group </li>
  <li><b>frequencuy</b> = Take the [top_n] most frequent terms per group and see how associated they are with each group</li>
  </ul>
  </li>
    </ul>
    </div>
    <div class='col-sm-6'>
      <p>The top_terms_cutoff input will have a big effect on the output of your chart. If you wish to see how <strong> the most frequent terms from the entire data set</strong> are spread across groups, set this to a lower number.  However, provided groups are of similar sizes, the highest frequency terms will often be present in <strong>all groups</strong> so may <strong>understate</strong> the differences between groups.
  <br>
  <br>
  <strong> Warning: </strong> <i>if one group has a very low, and another a very high, number of mentions, you may find that the very low frequency group has very few terms in its chart (even none!) when you set the top_terms_cutoff value to a low number.</i>
  <br>
  <br>
  On the other hand, if the number is <strong>too high</strong>, you risk filling the plot with low-frequency terms which are only present in a <strong>small number of documents</strong>, this can <strong>exaggerate</strong> the differences between groups.
      </p>
  <br>
    </div>
  </div>
"
  )

  return(text)
}

bigram_text <- function() {
  text <- shiny::HTML(
    "
<div class='row'>
  <div class='col-sm-6'>
    <p style='font-size: 14px;'>Below you'll find a bigram network, this network will help you estimate how clean your selected data is. Remember that long and connected chains of words may represent spam or unwanted mentions.</p>
     <p style='font-size:14px;'>This bigram network is restricted to a maximum of 5,000 data points for speed and user experience. It is therefore not recommended to be saved or exported, hence there being no download button. If the data looks clean, download the selection and create the network in the standard way in R/Rstudio. </p>
  </div>
  <div class='col-sm-6'>
    <p style-'font-size:14px;'>
    Alongside height and width, there are three parameters you can interact with:
    </p>
    <ul>
    <li><b>top_n</b> = <i>the number of <strong>bigrams</strong> to show in the network, ordered by frequency. </i></li>
    <li><b>min_freq</b> = <i>the minimum frequency each bigram must have been seen in order to appear in the network</i></li>
    <li><b>remove_stopwords</b> = <i>Whether to remove stopwords from the selected data. This can be time-intensive, so its default value is false.</i></li>
    </ul>
    <p>You'll need to click 'update plot' for these changes to take effect.</p>
   </div>
 </div>
")

  return(text)
}


# nested_accordions <- function(id,) {
#
  # ns <- NS(id)
  #
  # shiny::tagList(
  #   bslib::accordion(
  #     id = "",
  #     bslib::accordion_panel(
  #       id = "top_panel",
  #       bslib::accordion_panel(
  #         id = "nested_panel1",
  #         title = ,
  #         active = ,
  #         top_level_lements
  #       ),
  #       bslib::layout_sidebar(
  #         fillable = TRUE,
  #         fill = TRUE,
  #         sidebar = bslib::sidebar(
  #           bslib::accordion(
  #             id = "nested_accordion",
  #             bslib::accordion_panel(
  #
  #             ),
  #             bslib::accordion_panel(
  #
  #             ),
  #           )
  #         ), #main component of sidebar
  #
  #       ),
  #     ),
  #   )
  # )

# }
