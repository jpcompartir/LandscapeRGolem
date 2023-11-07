test_that("Module's server errors if given an incorrect input", {
  expect_error(testServer(
    mod_c_groups_global_server,
    args = list(
      bad_input = "really bad!")),
    "unused argument"
  )
})


test_that("input$groupVarGlobal is updating as intended", {
  testServer(
    mod_c_groups_global_server,
    args = list(
      highlighted_dataframe = generate_dummy_data,
      r = list()
    ), expr = {

      ns <- session$ns
      session$setInputs(groupVarGlobal = "cluster")

      #Check that cluster gets set appropriately and interacts with the observe
      expect_true(
        all(
          c(1:10) %in% highlighted_dataframe()[[input$groupVarGlobal]]
        )
      )

      #Update to diff column
      session$setInputs(groupVarGlobal = "sentiment")

      #Check not everything is evaluating to TRUE
      expect_false(
        "negative" == unique(highlighted_dataframe()[[input$groupVarGlobal]])
      )

      #Check input has been updated and is interacting properly
      expect_true(
        "positive" == unique(highlighted_dataframe()[[input$groupVarGlobal]])
        )
    })
})


test_that("module ui works and renders the correct divs", {
  ui <- mod_c_groups_global_ui(id = "test")
  golem::expect_shinytaglist(ui)
  # Check that formals have not been removed
  fmls <- formals(mod_c_groups_global_ui)
  for (i in c("id")){
    expect_true(i %in% names(fmls))
  }

  ui_char <- as.character(ui)

  expect_false(stringr::str_detect(ui_char, "bigramTag"))

  expect_true(stringr::str_detect(ui_char,  'id="test-groupVarGlobal'))
  expect_true(stringr::str_detect(ui_char,  'id="test-subGroups'))
  expect_true(stringr::str_detect(ui_char,  'id="test-updateSubgroupsButton'))
  expect_true(stringr::str_detect(ui_char,  'id="test-groupsRow'))
})

