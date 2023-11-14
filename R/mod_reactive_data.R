#' reactive_data UI Function
#'
#' Left empty as this module has no use of a UI and isn't called inside the app.
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_reactive_data_ui <- function(id){
  ns <- NS(id)
  tagList(

  )
}

#' reactive_data Server Functions
#' @param data original data input to app, not as a reactive expression
#' @param r list of reactiveValues to pass keep_keys, filterPattern and x1/y1 for filtering via co-ordinates.
#'
#' @noRd
mod_reactive_data_server <- function(id, data, r){
  moduleServer(id, function(input, output, session){
    ns <- session$ns

    # stopifnot(inherits(data, "data.frame"), is.reactive(r))

    reactive_data <- shiny::reactive({
      reactive_data <- data %>%
        dplyr::filter(
          V1 >= r$x1[[1]],
          V1 <= r$x1[[2]],
          V2 >= r$y1[[1]],
          V2 <= r$y1[[2]]
                      )

      if(!is.null(r$remove_keys)){
        reactive_data <- reactive_data %>%
          dplyr::filter(document %in% r$keep_keys)
      }

      if(r$filterPattern != ""){
        reactive_data <- reactive_data %>%
          dplyr::filter(grepl(r$filterPattern, text, ignore.case = TRUE))
      }

      return(reactive_data) # return it from the reactive
    })

    #Return it from the module in a named list so it's accessible in app_server.R. But, return as the reactive or the called data? Not sure what practical difference it would make here.
    return(list(reactive_data = reactive_data))

  })
}

## To be copied in the UI
# mod_reactive_data_ui("reactive_data_1")

## To be copied in the server
# mod_reactive_data_server("reactive_data_1")
