#Mod label data does the labelling of the data whereas mod_labelled_tab presents that data to the user. So the testing of this module is mainly to check that given an update in selected_range() there is an update in the labels, and that new labels are appended.

test_that("Module's server errors if given an incorrect input", {
  expect_error(testServer(
    mod_label_data_server,
    args = list(
      bad_input = "really bad!")),
    "unused argument"
  )
})

test_that("Module's server function accepts the right named inputs", {
  expect_silent(
    testServer(
      mod_label_data_server,
      # Add here your module params
      args = list(
        reactive_dataframe = list(),
        r = list(
        )
      ),
      expr = {
        ns <- session$ns
      })
  )
})

test_that("Module works when we provide the right inputs, that labels can be updated and label_ids are updated with them.", {
  testServer(
    mod_label_data_server,
    # Add here your module params
    args = list(reactive_dataframe = generate_dummy_data,
                # selected_range = function(){
                #   return(list(key = c(3, 4, 5)))
                # },
                r = shiny::reactiveValues(
                  labels = c("label1", "label2"),
                  label_ids = c(1, 2),
                  selected_range = c(1, 2, 3, 4, 5)
                )
    )
    , {
      ns <- session$ns
      expect_true(all(r$labels %in% c("label1", "label2")))
      expect_true(all(r$label_ids %in% c(1, 2)))

      browser()
      expect_equal(length(r$label_ids), 2)

      session$setInputs(labelText = "Dummy Label")
      session$setInputs(labelNow = 1)

      expect_equal(length(r$labels), 7)
      expect_true(
        all(
          r$labels ==
            c("label1", "label2", "Dummy Label", "Dummy Label", "Dummy Label", "Dummy Label", "Dummy Label")
        )
      )

      #overwriting doesn't ruin everything:
      session$setInputs(labelText = "overwrite")
      session$setInputs(labelNow = 1)
      expect_true(length(r$labels) == length(r$label_ids))

    })
})



test_that("module ui works", {
  ui <- mod_label_data_ui(id = "test")
  golem::expect_shinytaglist(ui)

  ui_char <- as.character(ui)

  expect_true(stringr::str_detect(ui_char, stringr::fixed("test-labelSelection")))
  expect_true(stringr::str_detect(ui_char, stringr::fixed("test-labelButton")))
  expect_true(stringr::str_detect(ui_char, stringr::fixed('id="test-labelledDT')))

})

