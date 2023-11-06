test_that("Module's server errors if given an incorrect input", {
  expect_error(testServer(
    mod_conversation_landscape_server,
    args = list(
      bad_input = "really bad!"))
  )
})

test_that("Module's server function accepts the right named inputs", {
  expect_silent(
    testServer(
      mod_conversation_landscape_server,
      # Add here your module params
      args = list(
        highlighted_dataframe = list(),
        selected_range = list(),
        r = list()),
        expr = {
        ns <- session$ns
      })
  )

})


test_that("module ui works", {
  ui <- mod_conversation_landscape_ui(id = "test")
  golem::expect_shinytaglist(ui)

  ui_character <- as.character(ui)
  expect_true(nchar(ui_character) > 5000)

  #goTop element is present
  expect_true(stringr::str_detect(ui_character, stringr::fixed("<div id='goTop'></div>")))

  #ID that shouldn't exist, doesn't exist:
  expect_false(stringr::str_detect(ui_character, stringr::fixed("id='test-shouldntexist'")))

  ids_that_should_exist <-
    list(
      'id="test-colourVar',
      'id="test-allData',
      'id="test-filterPattern',
      'id="test-selectedData',
      'id="test-labelData',
      'id="test-umapPlot',
      'id="test-dataTable'
    )

  lapply(ids_that_should_exist, function(x) {
    expect_true(stringr::str_detect(ui_character, stringr::fixed(x)))
  })

  # Check that formals have not been removed
  fmls <- formals(mod_conversation_landscape_ui)
  for (i in c("id")){
    expect_true(i %in% names(fmls))
  }
})
