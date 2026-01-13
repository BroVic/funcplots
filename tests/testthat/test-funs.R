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


test_that("Strings with math symbols are convered to MathJax expressions", {
  eq <- function(x) paste0("$$f(x) = ", x, "$$")
  
  e1 <- "x^3 + 6x^2 - 14"
  expect_identical(input_to_mathjax(e1), eq(e1))
  
  e2 <- "\\left(\\frac{x - 1}{x + 2}\\right)^x"
  expect_identical(input_to_mathjax(e2), eq(e2))
})

# Evaluation of expression strings ----
test_that("MathJax expressions are converted into valid R expresssions", {
  expect_identical(mathjax_to_r("\\sin60"), "sin(60)")
  expect_identical(mathjax_to_r("\\sinx"), "sin(x)")
  expect_identical(mathjax_to_r("\\frac{1}{2}"), "(1)/(2)")
  expect_identical(mathjax_to_r("\\frac{1}{2}x"), "(1)/(2)*x")
  expect_identical(mathjax_to_r("2 \\times 42"), "2*42")
  expect_identical(mathjax_to_r("\\left(\\frac{x - 1}{x + 2}\\right)^x"),
                   "((x-1)(x+2))^x")
  expect_identical(mathjax_to_r("x!"), "factorial(x)")
  expect_identical(mathjax_to_r("6!"), "factorial(6)")
  expect_identical(mathjax_to_r("\\frac{x}{6!}"), "(x)/factorial(6)")
  expect_identical(mathjax_to_r("7\\cdot x"), "7*x")
})


test_that("A valid equation is returned", {
  result <- evaluate_expr("x^3", -10, 10)
  
  expect_type(result, "list")
  expect_length(result, 2L)
  expect_type(result$x, "double")
  expect_type(result$y, "double")
  expect_type(evaluate_expr("1/2 * x", -5, 5), "list")
})


test_that("Algebra strings become computable entities", {
  expect_identical(process_parsed_expr("2x"), "2 * x")
  expect_identical(process_parsed_expr("x^2"), "x^2")
  expect_identical(process_parsed_expr("1/2x"), "1/2 * x")
  expect_identical(process_parsed_expr("1x/2"), "1 * x/2")
})


test_that("The expression can be parsed into component parts", {
  result <- deconstruct_math_expr("3x^3 + 2x^2 - 10x + 24")
  
  expect_type(result, "list")
  expect_length(result, 4)
  expect_identical(deconstruct_math_expr("x^2"), list("x^2"))
  expect_identical(deconstruct_math_expr("a + 2"), list("a", "+2"))
  expect_identical(deconstruct_math_expr("-2"), list("-2"))
  expect_identical(deconstruct_math_expr("-2x^2 + 3x - 9"), 
                   list("-2x^2", "+3x", "-9"))
  expect_length(deconstruct_math_expr("1/2x"), 1)
})


# Plotting of functions ----

test_that("Plot objects are created", {
  result <- evaluate_expr("x^2", -5, 5)
  expect_s3_class(plot_function(result$x, result$y), "ggplot")
  
  result2 <- evaluate_expr("1/2*x", -5, 5)
  expect_s3_class(plot_function(result2$x, result2$y), "ggplot")
})
