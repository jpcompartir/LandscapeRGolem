globalVariables(c(".data", ":=", "V1", "V2", "clean_text", "cluster", "document", "mention_content", "permalink", "sentiment", "text", "topic"))

wlos_text <- function() {
  text <- shiny::HTML(
    "
  <div class='row'>
    <div class='col-sm-6'>
      <p> Below you'll find a Weighted Log-odds (WLOs) Chart, this chart helps you to identify the key textual differences between groups. You can use this chart to understand why one cluster, topic, or grouping variable has been separated from the others.
  <br>
  The important inputs to consider when rendering a WLOs chart are:
  </p>
    <ul>
    <li><b>top_n</b> = <i>the number of terms to show on each chart</i></li>
    <li><b>number of rows</b> = <i>the number of rows to place the charts on</i></li>
    <li><b>top terms cutoff</b> = <i>the minimum rank, in order of frequency, for a term to be included</i></li>
    <li><b>filter by</b> = <i>determines how the data should be filtered</i>
    <ul>
  <li><b>association</b> = Take the most frequent [top terms cutoff] terms, then take the most associated [top_n] terms per group </li>
  <li><b>frequencuy</b> = Take the [top_n] most frequent terms per group and see how associated they are with each group</li>
  </ul>
  </li>
    </ul>
    </div>
    <div class='col-sm-6'>
      <p>The top_terms_cutoff input will have a big effect on the output of your chart. If you wish to see how <strong> the most frequent terms from the entire data set</strong> are spread across groups, set this to a lower number.  However, provided groups are of similar sizes, the highest frequency terms will often be present in <strong>all groups</strong> so may <strong>understate</strong> the differences between groups.
  <br>
  <br>
  <strong> Warning: </strong> <i>if one group has a very low, and another a very high, number of mentions, you may find that the very low frequency group has very few terms in its chart (even none!) when you set the top_terms_cutoff value to a low number.</i>
  <br>
  <br>
  On the other hand, if the number is <strong>too high</strong>, you risk filling the plot with low-frequency terms which are only present in a <strong>small number of documents</strong>, this can <strong>exaggerate</strong> the differences between groups.
      </p>
  <br>
    </div>
  </div>
"
  )

  return(text)
}

bigram_text <- function() {
  text <- shiny::HTML(
    "
<div class='row'>
  <div class='col-sm-6'>
    <p style='font-size: 14px;'>Below you'll find a bigram network, this network will help you estimate how clean your selected data is. Remember that long and connected chains of words may represent spam or unwanted mentions.</p>
     <p style='font-size:14px;'>This bigram network is restricted to a maximum of 5,000 data points for speed and user experience. It is therefore not recommended to be saved or exported, hence there being no download button. If the data looks clean, download the selection and create the network in the standard way in R/Rstudio. </p>
  </div>
  <div class='col-sm-6'>
    <p style-'font-size:14px;'>
    Alongside height and width, there are three parameters you can interact with:
    </p>
    <ul>
    <li><b>top_n</b> = <i>the number of <strong>bigrams</strong> to show in the network, ordered by frequency. </i></li>
    <li><b>min_freq</b> = <i>the minimum frequency each bigram must have been seen in order to appear in the network</i></li>
    <li><b>remove_stopwords</b> = <i>Whether to remove stopwords from the selected data. This can be time-intensive, so its default value is false.</i></li>
    </ul>
    <p>You'll need to click 'update plot' for these changes to take effect.</p>
   </div>
 </div>
")

  return(text)
}

#For testing etc.
generate_dummy_data <- function(length = 10){
  set.seed(1234)
  data <- data.frame(
    document = seq(1:length),
    date = rep(as.Date("2020-01-01"), length),
    text = rep("This is a test with some extra words because we need them for the bigram viz test function", length),
    sentiment = rep("positive", length),
    cluster = 1:length,
    permalink = rep("https://www.google.com", length),
    V1 = runif(length, 0, 1),
    V2 = runif(length, 0, 1)
  )

  data$clean_text <- data$text

  return(data)
}

generate_date_sequence_data <- function() {
  set.seed(1234)

  data <- data.frame(
    document = seq(1:10),
    date = as.Date(c("2023-01-01", "2023-01-02", "2023-01-03", "2023-01-04", "2023-01-05",
                     "2023-01-06", "2023-01-07", "2023-01-08", "2023-01-09", "2023-01-10")),
    text = rep("This is a test with some extra words because we need them for the bigram viz test function", 10),
    sentiment = rep("positive", 10),
    cluster = 1:10,
    permalink = rep("https://www.google.com", 10),
    V1 = runif(10, 0, 1),
    V2 = runif(10, 0, 1)
  )

  data$clean_text = data$text

  return(data)
}

generate_sentiment_data <- function(size = 30) {
  set.seed(123)

  data <- data.frame(
    document = seq(1:size),
    date = sample(replace = TRUE, size = size, x =
                    as.Date(
                      c("2023-01-01", "2023-01-02", "2023-01-03", "2023-01-04", "2023-01-05", "2023-01-06", "2023-01-07", "2023-01-08", "2023-01-09", "2023-01-10")
                    )
    ),
    text = rep("This is a test with some extra words because we need them for the bigram viz test function", size),
    sentiment = sample(c("positive","negative", "neutral"),
                       size = size,
                       replace = TRUE)
    ,
    cluster = sample(
      x = c(1, 2, 3, 4),
      size = size,
      replace = TRUE
      ),
    permalink = sample(c("https://www.google.com",
                         "https://www.facebook.com",
                         "https://www.twitter.com"),
                       size = size,
                       replace = TRUE),
    V1 = runif(size, 0, 1),
    V2 = runif(size, 0, 1)
  )

  data$clean_text = data$text

  return(data)

}

# Utility function for mod_bigram_network
make_bigram_viz <- function(data, text_var = mention_content, top_n = 50, min = 10, ...) {
  requireNamespace("ParseR")

  counts <- data %>%
    ParseR::count_ngram(text_var = {{ text_var }}, top_n = top_n, min_freq = min, ...)
  plot <- counts[["viz"]] %>%
    ParseR::viz_ngram()

  return(plot)
}

make_dt_tab_output <- function(data) {
  stopifnot(is.reactive(data) | is.function(data))
  table <- data() %>%
    dplyr::select(date, text, cluster, sentiment, permalink) %>%
    DT::datatable(
      filter = "top",
      options = list(
        pageLength = 25,
        dom = '<"top" ifp> rt<"bottom"lp>',
        autoWidth = FALSE
      ),
      style = "bootstrap5",
      rownames = FALSE,
      escape = FALSE
    )

  return(table)
}

#Custom expectation for code ran properly. Informs if NULL return value
expect_valid <- function(expr) {
  result <- tryCatch({
    expr
  }, error = function(e) {
    e
  })

  # Check if result is an error
  if (inherits(result, "error")) {
    testthat::expect(
      FALSE,
      sprintf("code did not run successfully. Error: %s", result$message)
    )
  } else if (is.null(result)) {
    testthat::expect(
      FALSE,
      "code ran but returned NULL"
    )
  } else {
    testthat::expect(
      TRUE,
      "code ran successfully and returned non-NULL"
    )
  }
}
