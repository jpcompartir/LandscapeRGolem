# #Informal test to see if highlighted_dataframe() can be turned into a plot, i.e. it can mimic the reactive behaviour needed elsewhere
# generate_dummy_data() %>%
#   make_bigram_viz(text_var = text, top_n = 5, min = 5, remove_stopwords = TRUE)
test_that("mod_bigram_network_server generates a plot with correct inputs",{
  testServer(
    app = mod_bigram_network_server,

    # Add here your module params
    args = list(
      highlighted_dataframe = function() {generate_wlos_data(size = 50)}
    ),

    expr = {
      ns <- session$ns

      session$setInputs(topN = 20,
                        minFreq = 2,
                        removeStopwords = FALSE,
                        width = 666,
                        height = 666)

      expect_true(is.reactive(bigram_reactive))
      bigram_plot <- bigram_reactive()
      bigram_plot$data

      expect_true(all(c('data', "layers", "scales", "mapping") %in% names(bigram_plot)))
      expect_true(inherits(bigram_plot, "gg"))

      expect_equal(nrow(bigram_plot$data), 52)

      session$setInputs(minFreq = 4, updatePlotsButton =1)
      expect_equal(nrow(bigram_reactive()$data),12)
    })
})


test_that("module ui works", {
  ui <- mod_bigram_network_ui(id = "test")
  golem::expect_shinytaglist(ui)

  # Check that formals have not been removed
  fmls <- formals(mod_bigram_network_ui)
  for (i in c("id")){
    expect_true(i %in% names(fmls))
  }
  ui_string <-as.character(ui)
  stringr::str_detect(ui_string, stringr::fixed('id="test-removeStopwords'))


  # We don't find IDS that we shouldn't:
  expect_false(stringr::str_detect(ui_string, stringr::fixed('id="test-bogiesN')))

  #Ids to be applied all at once in the the vapply line of code below:
  # ids_that_should_exist <- list(
  #   stringr::fixed('id="test-topN'),
  #   stringr::fixed('id="test-bigramPlot"'),
  #   stringr::fixed('id="test-minFreq"'),
  #   stringr::fixed('id="test-removeStopwords"'),
  #   stringr::fixed('id="test-updatePlotsButton"'),
  #   stringr::fixed('id="test-height-label'),
  #   stringr::fixed('id="test-updatePlotsButton')
  # )
  #
  # #Using the *apply family rather than map as LandscapeRGolem has no {purrr} dep.
  # vapply(
  #   ids_that_should_exist,
  #   FUN = function(x) expect_true(stringr::str_detect(ui_string, pattern = x)),
  #   FUN.VALUE =logical(length(1L))
  # )

  #Write the tests out individually so the error message are more informative.
  expect_true(stringr::str_detect(ui_string, pattern = stringr::fixed('id="test-topN')))
  expect_true(stringr::str_detect(ui_string, pattern = stringr::fixed('id="test-bigramPlot"')))
  expect_true(stringr::str_detect(ui_string, pattern = stringr::fixed('id="test-minFreq"')))
  expect_true(stringr::str_detect(ui_string, pattern = stringr::fixed('id="test-removeStopwords"')))
  expect_true(stringr::str_detect(ui_string, pattern = stringr::fixed('id="test-updatePlotsButton"')))
  expect_true(stringr::str_detect(ui_string, pattern = stringr::fixed('id="test-height-label')))
  expect_true(stringr::str_detect(ui_string, pattern = stringr::fixed('id="test-updatePlotsButton')))
})


# #Each time you run this snapshot you get different values for:
# bslib-sidebar-2570, not sure why that is/would be but makes me think snapshots may not be the right way to go
# test_that("module UI's snapshot persists", {
#   set.seed(1234)
#   expect_snapshot(mod_bigram_network_ui("test"))
# })
