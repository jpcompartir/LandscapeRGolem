#' labelled_tab UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_labelled_tab_ui <- function(id){
  ns <- NS(id)
  tagList(
    #Module which will be called by app.ui to render the data processed by mod_label_data
    shiny::fluidRow(
      mod_download_data_ui(id = ns("downloadLabelledData"),
                           label = "Labelled Data")
    ),
    DT::dataTableOutput(
      outputId = ns("labelledDT")
    )
  )
}

#' labelled_tag Server Functions
#'
#' @param id as set in ui
#' @param reactive_dataframe for joining with labelled data frame
#' @param r passing the requisite reactive values from app_server.R
#'
#' @noRd
mod_labelled_tab_server <- function(id,
                                    reactive_dataframe,
                                    r){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    labelled_df <- reactive({
      if (length(r$label_id < 1)) {
        validate("You must label data first to join the tables")
      }

      labelled_lookup <- tibble::tibble(
        document = as.numeric(r$label_ids),
        label = r$labels
      )

      labelled_data <- labelled_lookup %>%
        dplyr::left_join(reactive_dataframe(), by = "document") #Keep the rows in labelled_lookup and add the original columns

      return(labelled_data)
    })

    output$labelledDT <- DT::renderDataTable({
      if (nrow(labelled_df()) < 1) {
        validate("You must label data first to view the labelled data table")
      }

      labelled_df() %>%
        DT::datatable(
          filter = "top",
          options = list(
            pagelength = 10,
            dom = '<"top" ifp> rt<"bottom"lp>',
            autowidth = FALSE),
          style = "bootstrap",
          rownames = FALSE,
          escape = FALSE)
    })

    mod_download_data_server("downloadLabelledData",
                             data_object = labelled_df) #the module calls the reactive object when saving

  })
}

## To be copied in the UI
# mod_labelled_tab_ui("labelled_tab_1")

## To be copied in the server
# mod_labelled_tab_server("labelled_tab_1")
