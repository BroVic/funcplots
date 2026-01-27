library(testthat)
here::i_am("tests/testthat/test-funs.R")
source(here::here("R/funs.R"))

# Display of equations ----
test_that("Functions markup is performed properly", {
  expect_identical(make_mathjax_fractions("1/2"), "\\frac{1}{2}")
  expect_identical(make_mathjax_fractions("\frac{1}{2}"), "\\frac{1}{2}")
  expect_identical(make_mathjax_fractions("(x - 1)/(x + 2)"),
                   "\\frac{x - 1}{x + 2}")
  expect_identical(make_mathjax_fractions("((x - 1)/(x + 2))"),
                   "\\left(\\frac{x - 1}{x + 2}\\right)")
  expect_identical(make_mathjax_fractions("((x - 1)/(x + 2))^x"),
                   "\\left(\\frac{x - 1}{x + 2}\\right)^x")
})


test_that("Strings are stripped of any pre-existing tags for MathJax", {
  expect_identical(remove_mathjax_tags("$x$"), "x")
  expect_identical(remove_mathjax_tags("$$x$$"), "x")
  expect_identical(remove_mathjax_tags("\\(x\\)"), "x")
})


test_that("Strings with math symbols are converted to MathJax expressions", {
  eq <- function(x) paste0("$$f(x) = ", x, "$$")
  
  e1 <- "x^3 + 6x^2 - 14"
  expect_identical(input_to_mathjax(e1), eq(e1))
  
  e2 <- "\\left(\\frac{x - 1}{x + 2}\\right)^x"
  expect_identical(input_to_mathjax(e2), eq(e2))
  
  e3 <- "9\\sqrt{3}{45}"
  expect_identical(input_to_mathjax(e3), eq(e3))
})


# Evaluation of expressions ----
test_that("higher-order root functions are translated to inverted powers", {
  expect_identical(modify_roots("\\sqrt[3]x"), "x^(1/3)")
  expect_identical(modify_roots("\\sqrt[3]{x}"), "x^(1/3)")
})


# Plotting of functions ----
test_that("Plot objects are created", {
  result <- evaluate_expr("x^2", -5, 5)
  expect_s3_class(plot_function(result$x, result$y), "ggplot")
  
  result2 <- evaluate_expr("1/2*x", -5, 5)
  expect_s3_class(plot_function(result2$x, result2$y), "ggplot")
})
