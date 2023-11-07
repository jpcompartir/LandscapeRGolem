# The main tests for this module are that they take the right inputs (highlighted_dataframe, r) and that they don't take bad inputs (write something that fails to check that what's passing is legit). Then, we need to check what happens when we update the inputs, i.e. does over_time_data update? Looking at this, is this definitely the right behaviour for this module, or should the over_time_data be a module itself?

test_that("Module's server errors if given an incorrect input", {
  expect_error(testServer(
    mod_daterange_input_server,
    args = list(
      bad_input = "really bad!")),
    "unused argument"
  )
})

test_that("Module's server function accepts the right named inputs", {
  expect_silent(
    testServer(
      mod_daterange_input_server,
      # Add here your module params
      args = list(
        highlighted_dataframe = list(),
        r = list()),
      expr = {
        ns <- session$ns
      })
  )

})

test_that("Module's output is affected by changes to inputs" ,{
  testServer(
    mod_daterange_input_server,
    # Add here your module params
    args = list(
      highlighted_dataframe = generate_date_sequence_data,
      r = shiny::reactiveValues(
        date_min = as.Date("2023-01-01"),
        date_max = as.Date("2023-01-10")
      )
    ), {
      ns <- session$ns

      expect_true(
        is.reactive(
          session$getReturned()[["over_time_data"]]
        )
      )

      #Shouldn't be able to access this in its executed form as the right inputs aren't set. update*Input functions don't work in testServer- () after [["over_time_data"]] executes the reactiv
      expect_error(object = session$getReturned()[["over_time_data"]]())


      session$setInputs(
        dateRange = c(
          r$date_min,
          r$date_max
        )
      )

      # Return value is working
      expect_true(names(session$getReturned()) == "over_time_data")
      data <- session$getReturned()[["over_time_data"]]()

      expect_true(min(data$date) == as.Date("2023-01-01"))
      expect_true(max(data$date) == as.Date("2023-01-10"))

    })
})


test_that("module ui works", {
  ui <- mod_daterange_input_ui(id = "test")
  golem::expect_shinytaglist(ui)

  ui_char <- as.character(ui)
  expect_true(stringr::str_detect(ui_char, "test-dateRange"))
  expect_true(stringr::str_detect(ui_char, stringr::fixed('<div class="input-daterange')))

  # Check that the formatting of the dateRangeInput hasn't been altered
  expect_true(stringr::str_detect(ui_char, stringr::fixed("Date format: yyyy-mm-dd")))
})
