test_that("Module's server errors if given an incorrect input", {
  expect_error(testServer(
    mod_sent_time_server,
    args = list(
      bad_input = "really bad!")),
    "unused argument"
  )
})

test_that("Module's server function accepts the right named inputs", {
  expect_silent(
    testServer(
      mod_sent_time_server,
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

test_that("Module takes the right inputs, interacts with sub modules and responds to varying inputs ", {
  testServer(
    mod_sent_time_server,
    # Add here your module params
    args = list(
      highlighted_dataframe = generate_date_sequence_data,
      r = shiny::reactiveValues(global_group_var = "cluster",
                                current_subgroups = 1:5,
                                date_min = as.Date("2023-01-02"),
                                date_max = as.Date("2023-01-09"))
    )
    , {
      ns <- session$ns
      expect_error(sent_time_reactive(),
                   regexp = "date >=")
      expect_true(is.reactive(sent_time_reactive))

      #Check that all the titles are NULL before we interact with the module by setting the inputs
      expect_true(all(vapply(sent_time_titles$labels(), function(x) is.null(x), FUN.VALUE = logical(1))))

      session$setInputs(
        `sentTimeTitles-Title` = "My test title",
        `sentTimeTitles-Subtitle` = "My test subtitle",
        `sentTimeTitles-Caption` = "My test caption"
      )

      # Check they're set and returned by the module
      expect_equal(sent_time_titles$labels()$title, "My test title")
      expect_equal(sent_time_titles$labels()$subtitle, "My test subtitle")
      expect_equal(sent_time_titles$labels()$caption, "My test caption")

      #Shouldn't run yet
      expect_error(sent_date_range_vot$over_time_data())
      session$setInputs(
        `dateRangeSent-dateRange` = c(as.Date("2023-01-03"), as.Date("2023-01-06"))
      )

      # Should run now
      expect_silent(sent_date_range_vot$over_time_data())

      #Check values align with expectation
      over_time_data <- sent_date_range_vot$over_time_data()
      expect_equal(min(over_time_data$date), as.Date("2023-01-03"))
      expect_equal(max(over_time_data$date), as.Date("2023-01-06"))

      #Should run now
      expect_silent(sent_time_reactive())
      plot <- sent_time_reactive()

      #Check plot has the right labels and class
      expect_true(inherits( plot, "gg"))
      expect_equal(plot$labels$title, "My test title")
      expect_equal(plot$labels$subtitle, "My test subtitle")
      expect_equal(plot$labels$caption, "My test caption")
      expect_equal(plot$labels$fill, "sentiment")

      #Shouldn't run yet as width and height not set
      expect_error(output$sentTimePlot)

      session$setInputs(width = 400, height = 500)
      expect_equal(output$sentTimePlot$alt, "Plot object")
      expect_true(inherits(output$sentTimePlot, "list"))

      #Check the save seems right
      expect_true(endsWith(output$saveSentTime, ".png"))
      expect_true(startsWith(output$saveSentTime, "/var/folders/"))
      expect_true(grepl("sentiment_time_plot", output$saveSentTime))
    })
})



test_that("module ui works", {
  expect_error(
    mod_sent_time_ui(id = "test"),
    regexp = 'argument "distribution_tab')

  ui <- mod_sent_time_ui(
    id = "test",
    distribution_tab_height = "450px",
    distribution_tab_width = "450px")
  golem::expect_shinytaglist(ui)

  ui_char <- as.character(ui)

  expect_true(stringr::str_detect(ui_char, "test-dateRangeSent"))
  expect_true(stringr::str_detect(ui_char, "test-dateBreak"))
  expect_true(stringr::str_detect(ui_char, "test-sentTimeTitles"))
  expect_true(stringr::str_detect(ui_char, "test-saveSentTime"))
  expect_true(stringr::str_detect(ui_char, "test-sentTimePlot"))

  #Date formatting remains consistent
  expect_true(stringr::str_detect(ui_char, stringr::fixed('title="Date format: yyyy-mm-dd"')))

  #Appropriate values are set for the dateRanges
  expect_true(stringr::str_detect(ui_char, stringr::fixed(
    '<option value="week" selected>week</option>
<option value="month">month</option>
<option value="quarter">quarter</option>
<option value="year">year</option></select>')))


})

