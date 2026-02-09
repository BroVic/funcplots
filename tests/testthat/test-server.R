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
      color = 'red',
      linewidth = 1
    )
    
    expect_true(exists('latex'))
    expect_true(isTruthy(latex))
    expect_equal(latex(), "x^2")
    
    expect_true(exists("xydata"))
    expect_true(isTruthy(xydata))
    
    expect_type(output$plot, 'list') # plot on first run
    
    session$setInputs(go = 1)
    expect_type(xydata(), "list")
    expect_type(xydata()$x, "double")
    expect_type(xydata()$y, "double")
    expect_equal(expr_string(), "x^2")
    expect_type(output$plot, 'list')
  })
})
