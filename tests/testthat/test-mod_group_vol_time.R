test_that("Module's server errors if given an incorrect input", {
  expect_error(testServer(
    mod_group_vol_time_server,
    args = list(
      bad_input = "really bad!")),
    "unused argument"
  )
})

test_that("Module's server function accepts the right named inputs", {
  expect_silent(
    testServer(
      mod_group_vol_time_server,
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

test_that("Module renders a plot when correct inputs are set and interacts with its modules",{
  #This is rather a long test, it'll stay like this at least for now as setting up the testServer code each time takes a while.
  testServer(
    mod_group_vol_time_server,
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


      # Should error as inpouts aren't set
      expect_error(group_vol_time_reactive(),
                   regexp = "date >=")
      # browser()

      session$setInputs(
        dateBreak = "day",
        height = 600,
        width = 400,
        nrow = 2,
        #So to pass stuff into the modules that need them we can pre-prepend the namespace with syms
        `dateRangeGroupVol-dateRange` = list(as.Date("2023-01-03"), as.Date("2023-01-09"))
      )

      expect_true(is.reactive(group_vol_time_reactive))
      plot <- group_vol_time_reactive()

      expect_true(inherits(plot, "gg"))

      #Check range of dates is as expected:
      expect_true(max(plot$data$plot_date) == as.Date("2023-01-09"))
      expect_true(min(plot$data$plot_date) == as.Date("2023-01-03"))

      #Check the output is rendering with the correct names
      expect_true(
        all(
          c("src", "width", "height", "alt", "coordmap") %in% names(output$groupVolTime)
          )
      )

      expect_true(output$groupVolTime$alt == "Plot object")

      #Correct var is facetted
      expect_true(output$groupVolTime$coordmap$panels[[7]]$mapping$panelvar1 == "facet_var")

      #Check interaction with labels module works:
      session$setInputs(`groupVolTimeTitles-Title` = "New Title Please!",
                        `groupVolTimeTitles-Subtitle` = "New Subtitle Please...", )
      titled_plot <-group_vol_time_reactive()
      expect_true(titled_plot$labels$title == "New Title Please!")
      expect_true(titled_plot$labels$subtitle == "New Subtitle Please...")

      # Check the plot is trying to save to a file.
      plot_output <- output$saveGroupVolTime
      expect_true(startsWith(plot_output, "/var/fold"))
      expect_true(endsWith(plot_output, ".png"))
      expect_true(grepl('group_vol_time', plot_output))
    })
})


test_that("Module UI renders with correct tags + icons", {
  ui <- mod_group_vol_time_ui(id = "test")
  golem::expect_shinytaglist(ui)
  # Check that formals have not been removed


  ui_char <- as.character(ui)

  expect_true(stringr::str_detect(ui_char,stringr::fixed('id="test-nestedAccordion1"')))
  expect_true(stringr::str_detect(ui_char,stringr::fixed('<div class="bslib-sidebar-layout')))
  expect_true(stringr::str_detect(ui_char,stringr::fixed('id="test-groupVolTime')))
  expect_true(stringr::str_detect(ui_char,stringr::fixed('id="test-dateRangeGroupVol')))
  expect_true(stringr::str_detect(ui_char,stringr::fixed('id="test-groupVolTimeTitles')))
  expect_true(stringr::str_detect(ui_char,stringr::fixed('id="test-groupVolTime')))
  expect_true(stringr::str_detect(ui_char,stringr::fixed('id="test-dateBreak"')))

  expect_true(
    stringr::str_detect(
      ui_char,
      stringr::fixed(
        'aria-label="wand-magic-sparkles icon"></i>')
    )
  )

  expect_true(
    stringr::str_detect(
      ui_char,
      stringr::fixed(
        'aria-label="wrench icon"></i>')
    )
  )

})

