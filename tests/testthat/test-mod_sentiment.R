test_that("Module's server errors if given an incorrect input", {
  expect_error(testServer(
    mod_sentiment_server,
    args = list(
      bad_input = "really bad!")),
    "unused argument"
  )
})

test_that("Module's server function accepts the right named inputs", {
  expect_silent(
    testServer(
      mod_sentiment_server,
      # Add here your module params
      args = list(
        highlighted_dataframe = list()
      ),
      expr = {
        ns <- session$ns
      })
  )
})

test_that("The sentiment plot renders with correct values and aesthetics + module interacts with sub-modules.", {
  testServer(
    mod_sentiment_server,
    # Add here your module params
    args = list(
      highlighted_dataframe = generate_sentiment_data
    ),
    expr = {
      ns <- session$ns
      expect_valid(sentiment_reactive())

      expect_error(output$sentimentPlot)
      session$setInputs(
        width = 400,
        height = 400
      )
      # browser()
      expect_valid(output$sentimentPlot)
      expect_equal(output$sentimentPlot$alt, "Plot object")

      plot <- sentiment_reactive()
      expect_setequal(plot$data$n, c(9, 10, 11))
      expect_equal(plot$labels$fill, "sentiment")

      expect_null(plot$labels$title)
      session$setInputs(`sentimentTitles-Title` = "My Title",
                        `sentimentTitles-Xlabel` = "My X",
                        `sentimentTitles-Ylabel` = "My Y",
                        `sentimentTitles-Caption` = "My caption",
                        `sentimentTitles-Subtitle` = "My subtitle")

      labelled_plot <- sentiment_reactive()
      expect_setequal(c("My X", "My Y", "My Title", "My subtitle", "My caption", "sentiment") ,unlist(labelled_plot$labels))


      expect_true(startsWith(output$saveSentiment, "/var/folders"))
      expect_true(endsWith(output$saveSentiment, ".png"))
      expect_match(output$saveSentiment, "sentiment_plot")
    })

})



test_that("module ui renders with correct IDs", {
  expect_error(
    mod_sentiment_ui(id = "test"),
    regexp = "distribution_tab_height")

  ui <- mod_sentiment_ui(
    id = "test",
    distribution_tab_height = "450px",
    distribution_tab_width = "450px"
  )
  golem::expect_shinytaglist(ui)
  # Check that formals have not been removed

  ui_char <- as.character(ui)

  #Use expect_match rather than stringr:: stuff! Refactor everything else?
  expect_match(ui_char, "test-sentimentTitles")
  expect_match(ui_char, "test-saveSentiment")
  expect_match(ui_char, "test-sentimentPlot")
  expect_match(ui_char, "test-height")
  expect_match(ui_char, "test-width")


})

