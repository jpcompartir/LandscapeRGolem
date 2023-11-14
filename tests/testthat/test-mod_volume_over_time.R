test_that("volume_reactive renders a plot when over_time_data is rendered and inputs are set", {
  testServer(
    mod_volume_over_time_server,
    # Add here your module params
    args = list(
      highlighted_dataframe = generate_sentiment_data,
      r = shiny::reactiveValues()
    )
    , {
      ns <- session$ns
      expect_error(date_range_vot$over_time_data())
      session$setInputs(
        `dateRangeVot-dateRange` = c(as.Date("2023-01-03"), as.Date("2023-01-06"))
      )
      expect_true(inherits(date_range_vot$over_time_data(), "data.frame"))

      session$setInputs(
        dateBreak = "day",
        volumeHex = "#0f50d2",
        dateSmooth = "none",
        smoothSe = FALSE
      )
      plot <- volume_reactive()
      expect_equal(nrow(plot$data), 4)
      plot_build <- ggplot2::ggplot_build(plot)
      expect_contains(plot_build[[1]][[1]]$fill, "#0f50d2")

      #Check no labels
      expect_null(unlist(plot$labels))

      #Set labels
      session$setInputs(
        `volumeTitles-Title` = "My test title",
        `volumeTitles-Subtitle` = "My test subtitle",
        `volumeTitles-Caption` = "My test caption"
      )

      plot_labelled <- volume_reactive()
      expect_setequal(unlist(plot_labelled$labels[c("title", "subtitle", "caption")]), c("My test title", "My test subtitle", "My test caption"))

      # No smooth layer present yet
      expect_equal(length(plot_labelled$layers),1 )

      #Se gets added when input is set:
      session$setInputs(
        dateSmooth = "lm",
        smoothSe = TRUE,
        smoothColour = "#ffb600"
      )

      plot_se <- volume_reactive()

      #Smooth layer present
      expect_equal(length(plot_se$layers), 2)
      expect_true(plot_se$layers[[2]]$geom_params$se)

    })
})


test_that("module ui works", {
  expect_error(mod_volume_over_time_ui(id = "test"))

  ui <- mod_volume_over_time_ui(
    id = "test",
    distribution_tab_height = "450px",
    distribution_tab_width = "450px"
  )
  golem::expect_shinytaglist(ui)
  # Check that formals have not been removed

  ui_char <- as.character(ui)

  #Check for IDS
  expect_match(ui_char, stringr::fixed('test-height'))
  expect_match(ui_char, stringr::fixed('test-width'))
  expect_match(ui_char, stringr::fixed('test-dateRangeVot'))
  expect_match(ui_char, stringr::fixed('test-dateBreak'))
  expect_match(ui_char, stringr::fixed('test-dateSmooth'))
  expect_match(ui_char, stringr::fixed('test-volumeHex'))
  expect_match(ui_char, stringr::fixed('test-volumeTitles'))
  expect_match(ui_char, stringr::fixed('test-saveVolume'))

  #Check for date break values
  expect_true(stringr::str_detect(ui_char, stringr::fixed(
    '<option value="week" selected>week</option>
<option value="month">month</option>
<option value="quarter">quarter</option>
<option value="year">year</option></select>')))

  #Check for smooth values
  expect_true(stringr::str_detect(ui_char, stringr::fixed(
    '<option value="loess">loess</option>
<option value="lm">lm</option>
<option value="glm">glm</option>
<option value="gam">gam</option>'
  )))

})

