test_that("Module's server errors if given an incorrect input", {
  expect_error(testServer(
    mod_download_data_server,
    args = list(
      bad_input = "really bad!")),
    "unused argument"
  )
})

test_that("Module's server function accepts the right named inputs", {
  expect_silent(
    testServer(
      mod_download_data_server,
      # Add here your module params
      args = list(
        data_object = list()),
      expr = {
        ns <- session$ns
      })
  )
})

test_that("File gets downloaded to a temp dir with correct extension", {
  testServer(
    app = mod_download_data_server,
    args = list(
      data_object = generate_dummy_data
    ),
    expr = {

      x <- output$download
      expect_true(startsWith(x, "/var/folders"))
      expect_true(endsWith(x, ".csv"))

    }
  )
})


test_that("module ui works", {
  ui <- mod_download_data_ui(id = "test", label = "testData")
  golem::expect_shinytaglist(ui)
  # Check that formals have not been removed
  fmls <- formals(mod_download_data_ui)

  expect_true(all(names(fmls) == c("id", "label")))


  ui_char <- as.character(ui)

  expect_true(stringr::str_detect(ui_char, "test-fileName"))
  expect_true(stringr::str_detect(ui_char, "test-download"))
  expect_true(stringr::str_detect(ui_char, 'aria-label="download icon"'))

  expect_true(stringr::str_detect(ui_char, stringr::fixed('placeholder=\"filename excluding .csv\"')))
})
