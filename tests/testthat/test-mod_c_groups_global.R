test_that("Module's server errors if given an incorrect input", {
  expect_error(testServer(
    mod_c_groups_global_server,
    args = list(
      bad_input = "really bad!")),
    "unused argument"
  )
})

test_that("the subgroups reactivity is working and inputs update", {
  testServer(
    mod_c_groups_global_server,
    args = list(
      highlighted_dataframe = generate_sentiment_data,
      r = shiny::reactiveValues()
    ), expr = {

      ns <- session$ns

      # browser()
      # test session starts off with nothing in reactiveValues
      expect_length(names(r), 0)

      # Set as sentiment, check values line up
      session$setInputs(column = "sentiment")
      expect_setequal(subgroups(), c("negative", "neutral", "positive"))

      #Change input, check app reacts properly
      session$setInputs(column = "cluster")
      expect_setequal(subgroups(), c(1, 2, 3, 4))

      #Set this value as it won't populate in the testServer
      r$grouping_variables <- sort(get_group_variables(highlighted_dataframe()))


      expect_setequal(names(r), c("global_group_var", "grouped_data", "grouping_variables"))

      # Check that group_df_filtered is. null before we select subgroups and update
      expect_null(group_df_filtered())

      #Now update the selection of subgroups, then press the button and group_df_filtered should update
      session$setInputs(subgroups = c(1, 2))
      session$setInputs(updateSubgroups = 1)

      # CHeck that updating subgroups has rendered the group_df_filtered data frame, and then that this data frame is passed to r$ so that it can be used in other modules
      expect_true(!is.null(group_df_filtered()))
      expect_true(!is.null(r$grouped_data()))
    })
})


test_that("module ui works and renders the correct divs", {
  ui <- mod_c_groups_global_ui(id = "test")
  golem::expect_shinytaglist(ui)
  # Check that formals have not been removed

  ui_char <- as.character(ui)

  expect_false(stringr::str_detect(ui_char, "bigramTag"))

  expect_true(stringr::str_detect(ui_char,  'id="test-selectColumn'))
  expect_true(stringr::str_detect(ui_char,  'id="test-selectSubgroups'))
  expect_true(stringr::str_detect(ui_char,  'id="test-filterSubgroups'))
})


