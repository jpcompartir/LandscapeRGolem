# Super important module to test as it powers the whole app! Start with standard input tests for the server and then move on to the more meaty server test which will test the intended behaviours.
test_that("Module's server errors if given an incorrect input", {
  expect_error(testServer(
    mod_umap_plot_server,
    args = list(
      bad_input = "really bad!")),
    "unused argument"
  )
})

test_that("Module's server function accepts the right named inputs", {
  expect_silent(
    testServer(
      mod_umap_plot_server,
      # Add here your module params
      args = list(
        reactive_dataframe = list(),
        r = list()
      ),
      expr = {
        ns <- session$ns
      })
  )
})

test_that("Module returns a json object as the output$umapPlot", {
  testServer(
    mod_umap_plot_server,
    # Add here your module params
    args = list(
      reactive_dataframe = generate_dummy_data,
      r = shiny::reactiveValues(
        x1 = c(-10, 10),
        y1 = c(-10, 10),
        colour_var = "cluster"
      )
    ),
    expr = {
      ns <- session$ns

      expect_true(inherits(output$umapPlot, "json"))

      expect_equal(nrow(reactive_dataframe()), 10)

      # convert output$umapPlot to a list or data frame with only base R
      if(requireNamespace("jsonlite")){
        plotly_data <- jsonlite::fromJSON(output$umapPlot[[1]])

        expect_contains(
          names(plotly_data$deps), c("name", "version", "src", "script", "stylesheet")
        )

        expect_contains(
          plotly_data$x$shinyEvents, c("plotly_hover", "plotly_selected", "plotly_click")
        )
      }

      #Change the r$colour_var to something that doesn't exist and raise an erorr in the plot!
      # browser()
    })
})

test_that("Module communicates with mod_delete_data (more of an integration than a unit test", {
  testServer(
    mod_umap_plot_server,
    # Add here your module params
    args = list(
      reactive_dataframe = generate_dummy_data,
      r = shiny::reactiveValues()
    ),
    expr = {
      ns <- session$ns
      expect_null(r$selected_range)
      r$selected_range <- c(1, 2, 3)
      expect_equal(length(r$selected_range),3)
      expect_output(session$setInputs(`deleteData-delete` = 1), regexp = "remove keys will update")

      #r$selected_range gets flushed
      expect_equal(length(r$selected_range), 0)

      # browser()
    })
})


test_that("module ui works", {
  ui <- mod_umap_plot_ui(id = "test")
  golem::expect_shinytaglist(ui)

  ui_char <- as.character(ui)

  #Notify us when total # of divs change
  expect_equal(stringr::str_count("div>", string = ui_char), 19)
  expect_match(ui_char,'<div class="col-sm-6" style="width:50%; height: 10000px; position: relative;">', fixed = TRUE)

  expect_match(ui_char, 'id="test-umapPlot" style="width:100%;height:600px;', fixed = TRUE)
  expect_match(ui_char, 'test-button')
  expect_match(ui_char, 'test-delete')
  expect_match(ui_char, 'slider1')
  expect_match(ui_char, 'test-x1')
  expect_match(ui_char, 'slider2')
  expect_match(ui_char, 'test-y1')

  expect_match(ui_char, '<style>#test-y1 .noUi-connect {background: #ff7618;}</style>', fixed = TRUE)

})

