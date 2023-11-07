test_that("Module's server errors if given an incorrect input", {
  expect_error(testServer(
    mod_distribution_tab_server,
    args = list(
      bad_input = "really bad!")),
    "unused argument"
  )
})

test_that("Module's server function accepts the right named inputs", {
  expect_silent(
    testServer(
      mod_distribution_tab_server,
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
  ui <- mod_distribution_tab_ui(id = "test",
                                distribution_tab_height = 400,
                                distribution_tab_width = 450)
  golem::expect_shinytaglist(ui)
  # Check that formals have not been removed
  fmls <- formals(mod_distribution_tab_ui)
  expect_true(
    all(
      c("id", "distribution_tab_height", "distribution_tab_width") %in% names(fmls)
      )
    )

  ui_char <- as.character(ui)

  expect_true(stringr::str_detect(ui_char, "test-volumeModule"))
  expect_true(stringr::str_detect(ui_char, "test-sentimentModule"))
  expect_true(stringr::str_detect(ui_char, "test-tokenModule"))
  expect_true(stringr::str_detect(ui_char, "test-sentTimeModule"))

})

