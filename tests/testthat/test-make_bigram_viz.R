test_that("make_bigram_viz takes an input and renders a ggplot object", {

  #Depends on generate_dummy_data func
  data <- generate_dummy_data(length = 50)

  bigram <- make_bigram_viz(data, text_var = text, top_n = 4, min = 20)

  expect_true(
    inherits(bigram, "gg")
    )
  expect_true(
    all(
      names(bigram) == c("data", "layers", "scales", "mapping", "theme", "coordinates", "facet", "plot_env", "labels")
      )
    )

})
