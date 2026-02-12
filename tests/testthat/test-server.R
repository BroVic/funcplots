library(shiny)
library(testthat)
source(here::here("server.R"))
source(here::here("R/funs.R"))

test_that("function is correctly evaluated", {
  testServer(server, {
    
    session$setInputs(
      expr = "x^2",
      `xval-min-value` = -5,
      `xval-max-value` = 5,
      color = 'red',
      linewidth = 1
    )
    
    expect_true(exists('latex'))
    expect_true(isTruthy(latex))
    expect_equal(latex(), "x^2")
    expect_true(exists("xydata"))
    expect_true(isTruthy(xydata))
    
    session$setInputs(go = 1)
    expect_s3_class(xydata(), "data.frame")
    expect_type(xydata()$x, "double")
    expect_type(xydata()$y, "double")
    expect_equal(expr_string(), "x^2")
    expect_type(output$plot, 'list')
  })
})
