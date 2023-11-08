test_that("module ui works", {
  ui <- mod_landing_page_ui(id = "test")
  golem::expect_shinytaglist(ui)
  # Check that formals have not been removed
  ui_char <- as.character(ui)

  expect_equal(stringr::str_count(ui_char, "div"), 26)
  expect_equal(stringr::str_count(ui_char, "tipblock"), 2)

  #Starts as expected:
  expect_true(stringr::str_detect(ui_char, stringr::fixed("<h1>Welcome to <span style='color: #ff7518;'>LandscapeR!</span></h1>")))

  #ends as expected:
  expect_true(stringr::str_detect(
    ui_char,
    stringr::fixed("<p>It's important to remember that unless you tell the application to do so, it will reload with the data as it was when you first encountered it.</p>")))
})

