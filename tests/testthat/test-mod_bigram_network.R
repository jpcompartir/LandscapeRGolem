# #Informal test to see if highlighted_dataframe() can be turned into a plot, i.e. it can mimic the reactive behaviour needed elsewhere
# generate_dummy_data() %>%
#   make_bigram_viz(text_var = text, top_n = 5, min = 5, remove_stopwords = TRUE)

testServer(
  app = mod_bigram_network_server,

  # Add here your module params
  args = list(
    highlighted_dataframe = generate_dummy_data
  ),

  expr = {
    ns <- session$ns

    # #Set input -> check input is set
    session$setInputs(topN = 20)
    expect_true(input$topN == 20)

    session$setInputs(minFreq = 5)
    expect_equal(input$minFreq, 5)

    # expect_error(bigram_reactive())

    expect_error(is.reactive(object_that_doesnt_exist))
    expect_false(is.reactive("object_that_doesn't exist"))
    # print(highlighted_dataframe())
    session$setInputs(removeStopwords = TRUE)
    expect_true(input$removeStopwords)

    session$setInputs(width = 666)
    session$setInputs(height = 666)
    expect_equal(input$width, 666)
    expect_equal(input$height, 666)

    # expect_snapshot(print(bigram_reactive()))

    xd <- bigram_reactive()
    print(names(xd))
    print(length(xd))
    print(class(xd))
    expect_true(is.reactive(bigram_reactive))


    # print(highlighted_dataframe() %>%
    #         tibble())
    # print(highlighted_dataframe() %>%
    #   make_bigram_viz(text_var = text, top_n = input$topN, min = input$minFreq))

    # output$bigramPlotter <- shiny::renderPlot({
    #   highlighted_dataframe() %>%
    #     make_bigram_viz(text_var = text, top_n = input$topN, min = input$minFreq)
    # })
    #
    # print(str(output$bigramPlotter))
    # print(output$bigramPlotter)


    #
    # # Establish input isn't set
    # expect_true(is.null(session$topN))
    #
    # # Should error as inputs not set yet
    # expect_error(print(bigram_reactive()))
    #
    # expect_true(is.reactive(bigram_reactive))

    # print(output$bigramPlot)



    # Golem's given NS functions ----
    # expect_true(
    #   inherits(ns, "function")
    # )
    # expect_true(
    #   grepl(id, ns(""))
    # )
    # expect_true(
    #   grepl("test", ns("test"))
    # )
})

# test_that("module ui works", {
#   ui <- mod_bigram_network_ui(id = "test")
#   golem::expect_shinytaglist(ui)
#   # Check that formals have not been removed
#   fmls <- formals(mod_bigram_network_ui)
#   for (i in c("id")){
#     expect_true(i %in% names(fmls))
#   }
# })
