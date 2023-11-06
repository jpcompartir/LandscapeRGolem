test_that("Module's server errors if given an incorrect input", {
  expect_error(testServer(
    mod_compare_groups_server,
    args = list(
      bad_input = "really bad!"))
  )
})

test_that("Module's server function accepts the right named inputs", {
  expect_silent(
    testServer(
      mod_compare_groups_server,
      # Add here your module params
      args = list(
        highlighted_dataframe = list(),
        r = list()),
      expr = {
        ns <- session$ns
      })
  )
})



test_that("module ui works", {
  ui <- mod_compare_groups_ui(id = "test")
  golem::expect_shinytaglist(ui)
  # Check that formals have not been removed
  fmls <- formals(mod_compare_groups_ui)
  for (i in c("id")){
    expect_true(i %in% names(fmls))
  }

  ui_char <- as.character(ui)

  # Test that a bad tag isn't found
  expect_false(stringr::str_detect(ui_char, "badTag"))

  # ids_that_should_exist <- list(
  #   "compareGroupsAccordion",
  #   "groupGlobalsTag",
  #   "wlosTag",
  #   "groupSentimentTag",
  #   "groupVolTimeTag"
  # )
  #
  # # Check that the tags that should exist, do exist
  # lapply(ids_that_should_exist, function(x){
  #   expect_true(stringr::str_detect(ui_char, x))
  # })
  #Write the tests out individually so the error message are more informative.
  expect_true(stringr::str_detect(ui_char, "compareGroupsAccordio"))
  expect_true(stringr::str_detect(ui_char, "groupGlobalsTag"))
  expect_true(stringr::str_detect(ui_char, "wlosTag"))
  expect_true(stringr::str_detect(ui_char, "groupSentimentTag"))
  expect_true(stringr::str_detect(ui_char, "groupVolTimeTags"))

})

