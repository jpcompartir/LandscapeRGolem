test_that("mod_reactive_data's arguments are working correctly and it responds to changes in reactiveValues as it should ", {
  testServer(
    mod_reactive_data_server,
    # Add here your module params
    args = list(
      r = shiny::reactiveValues(
        x1 = c(0.4, 0.6),
        y1 = c(0.3, 0.6),
        keep_keys = c(1:10),
        filterPattern = ""
      ),
      data = generate_dummy_data(length = 50)
    )
    , {
      ns <- session$ns

      expect_true(is.reactive(reactive_data))
      expect_equal(nrow(reactive_data()), 3)

      #Does widening the coords increase rows?
      r$x1 <- c(0.2, 0.7)
      expect_equal(nrow(reactive_data()), 15)
      r$y1 <- c(0, 1)
      expect_equal(nrow(reactive_data()), 33)

      #Does filtering for a word that isn't in the text make rows == 0?
      r$filterPattern <- "microsoft"
      expect_equal(nrow(reactive_data()), 0)
      #Does filtering for a word that is in all of the texts take nrow back to 33?
      r$filterPattern <- "words"
      expect_equal(nrow(reactive_data()), 33)

      #Does making remove_keys not null add some filtering?
      r$remove_keys = c(11:50)
      expect_equal(nrow(reactive_data()), 7)

      expect_contains(names(session$getReturned()), "reactive_data")
    })

})

