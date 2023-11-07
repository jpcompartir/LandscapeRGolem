test_that("Module's server errors if given an incorrect input", {
  expect_error(testServer(
    mod_data_table_server,
    args = list(
      bad_input = "really bad!")),
    "unused argument"
  )
})

test_that("Module's server function accepts the right named inputs", {
  expect_silent(
    testServer(
      mod_data_table_server,
      # Add here your module params
      args = list(
        highlighted_dataframe = list()
        ),
      expr = {
        ns <- session$ns
      })
  )
})

test_that("make_dt_tab_output function is generating a data table",{
  data_imitating_reactive <- generate_dummy_data

  dt <- make_dt_tab_output(data_imitating_reactive)

  expect_false(inherits(dt, "gg")) # Doesn't inherit everything
  expect_true(inherits(dt, "datatables")) # Does inherit something it should
  expect_equal(dt$x$style, "bootstrap5")  #style is set by the function
  expect_equal(dt$x$filter, "top") #filter is set by the function

  data_imitating_called_reactive <- generate_dummy_data()
  expect_error(make_dt_tab_output(data_imiating_called_reactive))

  expect_true(all(c("style", "filter", "vertical", "filterHTML", "data", "container", "options", "selection") %in% names(dt$x)))
})

test_that("output$highlightedTable is a JSON object", {
  testServer(
    mod_data_table_server,
    # Add here your module params
    args = list(
      highlighted_dataframe = generate_dummy_data
    )
    , {
      ns <- session$ns

      expect_true(inherits(output$highlightedTable, "json"))
})
})


test_that("module ui works", {
  ui <- mod_data_table_ui(id = "test")
  golem::expect_shinytaglist(ui)
  # Check that formals have not been removed
  fmls <- formals(mod_data_table_ui)
  for (i in c("id")){
    expect_true(i %in% names(fmls))
  }

  ui_char <- as.character(ui)

  expect_false(stringr::str_detect(ui_char, 'id="test-bigramTag')) # Check we can get a false like this
  expect_true(stringr::str_detect(ui_char, 'id="test-highlightedTable')) # Check w eget what we want
})


