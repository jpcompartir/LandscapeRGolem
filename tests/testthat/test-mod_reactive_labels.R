test_that("Module responds to updated inputs and then returns those inputs", {
  testServer(
    mod_reactive_labels_server,
    # Add here your module params
    args = list()
    , {
      ns <- session$ns
      expect_true(is.null(session$getReturned()$labels()$x))

      session$setInputs(
        Title = "My Demo Title",
        Subtitle = "The Demo Subtitle",
        Caption = "The Demo Caption",
        Xlabel = "The Demo Xlabel",
        Ylabel = "The Demo Ylabel"
      )

      updated_labels <- session$getReturned()$labels()
      expect_equal(updated_labels$x, "The Demo Xlabel")
      expect_equal(updated_labels$y, "The Demo Ylabel")
      expect_equal(updated_labels$title, "My Demo Title")
      expect_equal(updated_labels$subtitle, "The Demo Subtitle")
      expect_equal(updated_labels$caption, "The Demo Caption")
    })
})


test_that("module ui works", {
  ui <- mod_reactive_labels_ui(id = "test")
  golem::expect_shinytaglist(ui)
  # Check that formals have not been removed
  ui_char <- as.character(ui)
  expect_true(stringr::str_detect(ui_char, "test-toggle"))
  expect_true(stringr::str_detect(ui_char, "Customise Titles\\?"))
})

