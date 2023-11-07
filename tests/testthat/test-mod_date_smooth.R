testServer(
  mod_date_smooth_server,
  # Add here your module params
  args = list()
  , {
    ns <- session$ns


    # Testing the Dynamic UI is properly rendered
    session$setInputs(dateSmooth = "none")
    expect_null(output$smoothControls)
    expect_equal(length(output$smoothControls), 0)

    session$setInputs(dateSmooth = "loess")
    expect_equal(length(output$smoothControls), 2)
    expect_equal(names(output$smoothControls), c("html", "deps"))
    smooth_ui_char <- as.character(output$smoothControls$html)
    expect_true(stringr::str_detect(smooth_ui_char, 'id="proxy1-smoothSe-label'))
    expect_true(stringr::str_detect(smooth_ui_char, stringr::fixed('<input id="proxy1-smoothColour" type="text" class="shiny-input-text form-control" value="#000000"/>')))

})

test_that("module ui works", {
  ui <- mod_date_smooth_ui(id = "test")
  golem::expect_shinytaglist(ui)

  ui_char <- as.character(ui)

  expect_true(stringr::str_detect(ui_char, 'id="test-dateSmooth'))
  expect_true(stringr::str_detect(ui_char, 'id="test-smoothControls'))

  #Options are present in UI
  expect_true(stringr::str_detect(ui_char, 'value="loess"'))
  expect_true(stringr::str_detect(ui_char, 'value="lm"'))
  expect_true(stringr::str_detect(ui_char, 'value="glm"'))
  expect_true(stringr::str_detect(ui_char, 'value="gam"'))

})

