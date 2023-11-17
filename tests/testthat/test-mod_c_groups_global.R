test_that("Module's server errors if given an incorrect input", {
  expect_error(testServer(
    mod_c_groups_global_server,
    args = list(
      bad_input = "really bad!")),
    "unused argument"
  )
})

test_that("input$tabGroupVar is updating as intended", {
  testServer(
    mod_c_groups_global_server,
    args = list(
      highlighted_dataframe = generate_dummy_data,
      r = shiny::reactiveValues()
    ), expr = {

      ns <- session$ns
      # browser()
      session$setInputs(tabGroupVar = "cluster")

      #Check that cluster gets set appropriately and interacts with the observe
      expect_true(
        all(
          c(1:10) %in% highlighted_dataframe()[[input$tabGroupVar]]
        )
      )

      #Update to diff column
      session$setInputs(tabGroupVar = "sentiment")
      session$setInputs(subGroups = 1)

      session$setInputs(`test-updateSubgroupsButton` = 1)

      # browser()

      #Check not everything is evaluating to TRUE
      expect_false(
        "negative" == unique(highlighted_dataframe()[[input$tabGroupVar]])
      )

      #Check input has been updated and is interacting properly
      expect_true(
        "positive" == unique(highlighted_dataframe()[[input$tabGroupVar]])
        )


    })
})

test_that("the subgroups reactivity is working", {
  testServer(
    mod_c_groups_global_server,
    args = list(
      highlighted_dataframe = generate_sentiment_data,
      r = shiny::reactiveValues()
    ), expr = {

      ns <- session$ns

      expect_length(names(r), 0)
      #Update to diff column
      session$setInputs(tabGroupVar = "sentiment")
      session$setInputs(subGroups = 1)

      expect_setequal(names(r), c("global_group_var", "current_subgroups", "new_subgroups"))

      session$setInputs(`updateSubgroupsButton` = 1)

      #Check that changing to cluste has the right reactive changes
      session$setInputs(tabGroupVar = "cluster")
      expect_setequal(r$new_subgroups, c(1, 2, 3, 4))

      session$setInputs(subGroups = c( 1, 2))
      expect_setequal(r$new_subgroups, c(1, 2))
      #Testthat new_subgroups updates instantly, but current doesn't until button pressed
      expect_true(all(setdiff(r$current_subgroups, r$new_subgroups) == c(3, 4)))

      session$setInputs(`updateSubgroupsButton` = 2)
      expect_setequal(r$new_subgroups,r$current_subgroups)
    })
})


test_that("module ui works and renders the correct divs", {
  ui <- mod_c_groups_global_ui(id = "test")
  golem::expect_shinytaglist(ui)
  # Check that formals have not been removed

  ui_char <- as.character(ui)

  expect_false(stringr::str_detect(ui_char, "bigramTag"))

  expect_true(stringr::str_detect(ui_char,  'id="test-tabGroupVar'))
  expect_true(stringr::str_detect(ui_char,  'id="test-subGroups'))
  expect_true(stringr::str_detect(ui_char,  'id="test-updateSubgroupsButton'))
  expect_true(stringr::str_detect(ui_char,  'id="test-groupsRow'))
})


