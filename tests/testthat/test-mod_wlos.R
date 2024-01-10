test_that("Module takes correct inputs and responds to its inputs being changed + reactiveValues being changed + renders plots.", {

  testServer(
    mod_wlos_server,
    # Add here your module params
    args = list(
      highlighted_dataframe = function(){generate_wlos_data(size = 50)},
      r = shiny::reactiveValues(
        grouped_data = function(){generate_wlos_data(size = 50)}
      )
    )
    , {
      ns <- session$ns
      # browser()
      session$setInputs(topN = 5,
                        updatePlotsButton = 1,
                        termCutoff = 10,
                        textSize = 3,
                        nrow = 3)

      r$global_group_var = "cluster"

      plot <- wlos_reactive()
      expect_true(inherits(plot, "gg"))
      expect_equal(length(plot$layers), 3)
      expect_contains(names(plot), c("data", "layers", "facet"))
      expect_equal(plot$facet$params$nrow, 3)

      #eventReactive listens to nrow (just added)
      session$setInputs(nrow = 4)
      session$setInputs(updatePlotsButton = 1)
      plot <- wlos_reactive()
      expect_equal(plot$facet$params$nrow, 4)

      session$setInputs(width = 400, height = 400)
      expect_true(startsWith(output$saveWLOs, "/var/folders"))
      expect_true(endsWith(output$saveWLOs, ".png"))
      expect_match(output$saveWLOs, "wlos_plot")


      r$global_group_var <- "sentiment"
      session$setInputs(updatePlotsButton = 2)
      plot <- wlos_reactive()
      expect_setequal(unique(plot$data$facet_var), c("negative", "neutral", "positive"))
    })

})

test_that("module ui works", {
  ui <- mod_wlos_ui(id = "test")
  golem::expect_shinytaglist(ui)

  ui_char <- as.character(ui)

  expect_match(ui_char, stringr::fixed('test-mainAccordion'))
  expect_match(ui_char, stringr::fixed('test-nestedAccordion1'))
  expect_match(ui_char, stringr::fixed('test-height'))
  expect_match(ui_char, stringr::fixed('test-width'))
  expect_match(ui_char, stringr::fixed('test-topN'))
  expect_match(ui_char, stringr::fixed('test-termCutoff'))
  expect_match(ui_char, stringr::fixed('test-textSize'))
  expect_match(ui_char, stringr::fixed('test-nrow'))
  expect_match(ui_char, stringr::fixed('test-updatePlotsButton'))
  expect_match(ui_char, stringr::fixed('test-saveWLOs'))
  expect_match(ui_char, stringr::fixed('test-wlosPlot'))


})

