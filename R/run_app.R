#' Run the Shiny Application
#'
#' @param ... arguments to pass to golem_opts.
#' See `?golem::get_golem_options` for more details.
#' @inheritParams shiny::shinyApp
#'
#' @export
#' @importFrom shiny shinyApp
#' @importFrom golem with_golem_options
run_app <- function(onStart = NULL,
                    options = list(),
                    enableBookmarking = NULL,
                    uiPattern = "/",
                    ...) {
  golem::with_golem_options(
    app = shiny::shinyApp(
      ui = app_ui,
      server = function(input, output, session) {
        app_server(input, output, session, data = NULL)
      },
      # server = app_server,
      onStart = onStart,
      options = options,
      enableBookmarking = enableBookmarking,
      uiPattern = uiPattern
    ),
    golem_opts = list(...)
  )
}


#' Run the Shiny Application from anoher project
#'
#' @param ... arguments to pass to golem_opts.
#' See `?golem::get_golem_options` for more details.
#' @inheritParams shiny::shinyApp
#'
#' @export
#' @importFrom shiny shinyApp
#' @importFrom golem with_golem_options
run_app_from_other_project <- function(onStart = NULL,
                                       options = list(),
                                       enableBookmarking = NULL,
                                       uiPattern = "/",
                                       data,
                                       ...) {
  golem::with_golem_options(
    app = shiny::shinyApp(
      ui = app_ui,
      server = function(input, output, session) {
        app_server(input, output, session, data)
      },
      # server = app_server,
      onStart = onStart,
      options = options,
      enableBookmarking = enableBookmarking,
      uiPattern = uiPattern
    ),
    golem_opts = list(...)
  )
}
