test_that("Module's server errors if given an incorrect input", {
  expect_error(testServer(
    mod_group_sentiment_server,
    args = list(
      bad_input = "really bad!")),
    "unused argument"
  )
})

test_that("Module's server function accepts the right named inputs", {
  expect_silent(
    testServer(
      mod_group_sentiment_server,
      # Add here your module params
      args = list(
        highlighted_dataframe = list(),
        r = list()
      ),
      expr = {
        ns <- session$ns
      })
  )
})

test_that("Module produces the plot as expected", {
  testServer(
    app = mod_group_sentiment_server,
    args = list(
      highlighted_dataframe = generate_dummy_data,
      r = shiny::reactiveValues(global_group_var = "cluster",
                                current_subgroups = 1:5)
    ),
    expr = {
      ns <- session$ns

      session$setInputs(
        width = "450px",
        height = "450px",
        chartType = "volume",
        labelsType = "volume")

      expect_true(is.reactive(group_sent_reactive))
      plot <- group_sent_reactive()
      plot_build <- ggplot2::ggplot_build(plot)

      expect_true(inherits(plot, "gg"))
      expect_true(all(c("group_var", "sentiment_var", "n", "percent", ".total", "percent_character") %in% names(plot$data)))


      session$setInputs(
        chartType = "percent",
        labelsType = "percent"
      )
      plot_two <- group_sent_reactive()
      plot_two_build <- ggplot2::ggplot_build(plot_two)

      # Check the first plot has different labels to the second, and that the second's are percentages
      expect_equal(unique(plot_build[[1]][[2]][["label"]]), "1")
      expect_equal(unique(plot_two_build[[1]][[2]][["label"]]), "100%")
    }
  )
})


test_that("module ui works", {
  ui <- mod_group_sentiment_ui(id = "test")
  golem::expect_shinytaglist(ui)

  ui_char <- as.character(ui)

  #icons
  c("wand-magic-sparkles", "wrench")

  expect_true(stringr::str_detect(ui_char, "test-nestedAccordion1"))
  expect_true(stringr::str_detect(ui_char, "test-height"))
  expect_true(stringr::str_detect(ui_char, "test-width"))
  expect_true(stringr::str_detect(ui_char, "test-labelsType"))
  expect_true(stringr::str_detect(ui_char, "test-groupSentimentTitles"))
  expect_true(stringr::str_detect(ui_char, "test-groupSentimentPlot"))
  expect_true(stringr::str_detect(ui_char, "test-saveGroupSentiment"))

  expect_true(
    stringr::str_detect(
      ui_char,
      stringr::fixed('<div class="shiny-plot-output html-fill-item" id="test-groupSentimentPlot" style="width:450px;height:450px;"></div>')
    )
  )


  expect_true(
    stringr::str_detect(
      ui_char,
      stringr::fixed(
        'aria-label="wrench icon"')
    )
  )

  expect_true(
    stringr::str_detect(
      ui_char,
      stringr::fixed(
        '<i class="fas fa-wand-magic-sparkles" role="presentation" aria-label="wand-magic-sparkles icon"></i>')
    )
  )
})