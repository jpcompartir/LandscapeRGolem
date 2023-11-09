test_that("Module's server errors if given an incorrect input", {
  expect_error(testServer(
    mod_token_plot_server,
    args = list(
      bad_input = "really bad!")),
    "unused argument"
  )
})

test_that("Module's server function accepts the right named inputs", {
  expect_silent(
    testServer(
      mod_token_plot_server,
      # Add here your module params
      args = list(
        highlighted_dataframe = list()
      ),
      expr = {
        ns <- session$ns
      })
  )
})

test_that("Plot is rendered with correct data, geoms, and colours. Labels module interacts properly",{
  testServer(
    mod_token_plot_server,
    # Add here your module params
    args = list(
      highlighted_dataframe = generate_dummy_data
    )
    , {
      ns <- session$ns

      # browser()
      session$setInputs(tokenHex = "#ff7518")
      expect_valid(token_reactive())
      plot <- token_reactive()
      expect_equal(max(plot$data$n), 20)
      expect_equal(min(plot$data$n), 10)

      expect_true(inherits(plot$layers[[1]]$geom, "GeomCol"))
      expect_equal(plot$layers[[1]]$aes_params$fill, "#ff7518")

      #Can we set the labels?

      expect_null(unlist(plot$labels))
      session$setInputs(`tokenTitles-Title` = "My Title",
                        `tokenTitles-Xlabel` = "My X",
                        `tokenTitles-Ylabel` = "My Y",
                        `tokenTitles-Caption` = "My caption",
                        `tokenTitles-Subtitle` = "My subtitle")

      labelled_plot <- token_reactive()
      expect_setequal(c("My X", "My Y", "My Title", "My subtitle", "My caption") ,unlist(labelled_plot$labels))

    })
})



test_that("module ui renders with appropriate tags", {
  expect_error(
    mod_token_plot_ui(id = "test")
  )
  ui <- mod_token_plot_ui(
    id = "test",
    distribution_tab_height = "450px",
    distribution_tab_width = "450px"
  )
  golem::expect_shinytaglist(ui)
  ui_char <- as.character(ui)

  expect_match(ui_char, "test-height")
  expect_match(ui_char, "test-width")
  expect_match(ui_char, "test-tokenHex")
  expect_match(ui_char, "test-tokenTitles")
  expect_match(ui_char, "test-saveToken")
  expect_match(ui_char, "test-tokenPlot")


  expect_match(ui_char, 'noUi-connect {background: #ff7518;}', fixed = TRUE)
})

