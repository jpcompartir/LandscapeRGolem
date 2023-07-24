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
