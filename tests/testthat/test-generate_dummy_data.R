test_that("generate_dummy_data is stable", {
  data <- generate_dummy_data(length = 10)

  expect_true(
    all(
      names(data)  == c("document", "date", "text", "sentiment", "cluster", "permalink", "V1", "V2", "clean_text")
    )
  )

  expect_true(
    all(
      round(data$V1, 3) ==
        c(0.114, 0.622, 0.609, 0.623, 0.861, 0.640, 0.009, 0.233, 0.666, 0.514)
    )
  )
})
