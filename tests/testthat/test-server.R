library(shiny)
library(testthat)
here::i_am("tests/testthat/test-server.R")
source(here::here("server.R"))
source(here::here("R/funs.R"))

test_that("function is correctly evaluated", {
  testServer(server, {
    session$setInputs(expr = "x^2", xmin = -5, xmax = 5)
    expect_true(exists("result"))
    expect_true(isTruthy(result))
    
    session$setInputs(go = 1)
    expect_type(result(), "list")
    expect_type(result()$x, "double")
    expect_type(result()$y, "double")
    expect_type(output$plot, 'list')
  })
})
