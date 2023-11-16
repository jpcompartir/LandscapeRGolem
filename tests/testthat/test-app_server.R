# # This is where the primary integration tests should probably live. Most module tests are unit tests, wherein each checks whether if it receives the right type of input, then it knows what to do with it. Integration tests are important because they test whether the modules will receive the right types of input. Without integration tests it's foreseeable that all of the unit tests are passing, but the app is not in fact working.


# if(interactive()){
#   test_that("app_server.R functions", {
#     myTestServer(
#       app = app_server,
#       args = list(),
#       expr = {
#         ns <- session$ns
#         expect_setequal(names(r), c("colour_var", "column_names", "global_group_var", "global_subgroups", "date_min", "date_max", "virid_colours", "keep_keys", "remove_keys", "selected_range"))
#
#         # browser()
#         x <- nrow(data %>% dplyr::filter(grepl("microsoft", text, ignore.case = TRUE)))
#
#         r$x1 <- c(-20, 20)
#         r$y1 <- c(-20, 20)
#         r$filterPattern <- "microsoft"
#         expect_equal(nrow(reactive_data_output$reactive_data()), x)
#         pre_delete <- reactive_data_output$reactive_data()$document
#
#         session$setInputs(
#           `landscapeTag-umapPlot-deleteData-delete` = 1
#         )
#         expect_true(length(r$selected_range) == 0)
#       }
#     )
#   })
# }



# test_that("app_ui.R is generating the right type of object and has some key tags/ids", {
#   ui <- app_ui()
#
# })
