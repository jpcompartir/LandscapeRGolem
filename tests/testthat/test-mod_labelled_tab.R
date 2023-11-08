test_that("Module's server errors if given an incorrect input", {
  expect_error(testServer(
    mod_labelled_tab_server,
    args = list(
      bad_input = "really bad!")),
    "unused argument"
  )
})

test_that("Module's server function accepts the right named inputs", {
  expect_silent(
    testServer(
      mod_labelled_tab_server,
      # Add here your module params
      args = list(
        reactive_dataframe = list(),
        data = list(),
        r = list()
      ),
      expr = {
        ns <- session$ns
      })
  )
})

test_that("Labelled tab accepts its inputs and responds when those inputs are changed", {
  testServer(
    mod_labelled_tab_server,
    # Add here your module params
    args = list(
      # data = function(){return(generate_dummy_data(length = 20))},
      data = generate_dummy_data(length = 20), # Shouldn't be a reactive
      reactive_dataframe = generate_dummy_data,
      r = shiny::reactiveValues(
        label_ids = c(1, 2, 3),
        labels = c("label1", "label2", "label2")
      )
    )
    , {
      ns <- session$ns
      #
      expect_true(inherits(labelled_df(), "data.frame"))
      expect_true(nrow(labelled_df()) == 3)
      expect_true(all(r$label_ids == c(1, 2, 3)))

      # Should prevent labelled_df() from running and throw an error
      r$label_ids <- NULL
      expect_error(labelled_df(), "arguments imply differing")

      #Fix the changes but check
      r$label_ids <- c(4, 5, 6)
      r$labels <- c("label_four", "label5", "label_six")

      expect_true(all(labelled_df()$label ==  c("label_four", "label5", "label_six")))

      expect_true(inherits(output$labelledDT, "json"))
    })
})


test_that("module ui works", {
  ui <- mod_labelled_tab_ui(id = "test")
  golem::expect_shinytaglist(ui)
  # Check that formals have not been removed
  ui_char <- as.character(ui)

  expect_true(stringr::str_detect(ui_char, "test-downloadLabelledData-download"))

})

