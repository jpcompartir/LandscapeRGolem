test_that("Module's server function accepts the right named inputs", {
  expect_silent(
    testServer(
      mod_delete_data_server,
      # Add here your module params
      args = list(
        r = list(
        )
      ),
      expr = {
        ns <- session$ns
      })
  )
})



testServer(
  mod_delete_data_server,
  # Add here your module params
  args = list(
    r  = shiny::reactiveValues(
      selected_range = NULL,
      remove_keys = NULL,
      keep_keys = NULL
    )
  )
  , {
    ns <- session$ns
    r$selected_range <- c(1, 2, 3, 4)
    #Pressing the delete button updates the keys
    expect_output(session$setInputs(delete = 1), regexp = "remove keys will update")

    r$selected_range <- c(5, 6)
    #Pressing the delete button wipes the values of selected_range
    session$setInputs(delete = 2)
    expect_equal(length(r$selected_range), 0 )

    expect_setequal(r$remove_keys, c(5, 6))

})

test_that("module ui works", {
  ui <- mod_delete_data_ui(id = "test")
  golem::expect_shinytaglist(ui)
  # Check that formals have not been removed

  ui_char <- as.character(ui)

  expect_match(ui_char, fixed = TRUE, 'id="test-delete" style="background: #ff7518; border-radius: 100px; color: #ffffff; border:none;')
  })

