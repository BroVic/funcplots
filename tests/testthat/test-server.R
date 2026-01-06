library(shiny)
library(testthat)
here::i_am("tests/testthat/test-server.R")
source(here::here("server.R"))
source(here::here("R/funs.R"))

test_that("function is correctly evaluated", {
  testServer(server, {
    session$setInputs(
      expr = "x^2",
      xmin = -5,
      xmax = 5,
      go = isolate(session$input$go) + 1
    )
    
    expect_length(output$equation, 2L)
    expect_identical(input$expr, "x^2")
    expect_type(isolate(result()), "list")
    # print(result()$x)
  })
})
