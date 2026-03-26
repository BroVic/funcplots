library(testthat)
source(here::here("R/funs.R"))

# Display of equations ----
test_that("Functions markup is performed properly", {
  expect_identical(make_latex_fractions("1/2"), "\\frac{1}{2}")
  expect_identical(make_latex_fractions("\frac{1}{2}"), "\\frac{1}{2}")
  expect_identical(make_latex_fractions("(x - 1)/(x + 2)"),
                   "\\frac{x - 1}{x + 2}")
  expect_identical(make_latex_fractions("((x - 1)/(x + 2))"),
                   "\\left(\\frac{x - 1}{x + 2}\\right)")
  expect_identical(make_latex_fractions("((x - 1)/(x + 2))^x"),
                   "\\left(\\frac{x - 1}{x + 2}\\right)^x")
})


test_that("Strings are stripped of any pre-existing tags for MathJax", {
  expect_identical(remove_mathjax_delims("$x$"), "x")
  expect_identical(remove_mathjax_delims("$$x$$"), "x")
  expect_identical(remove_mathjax_delims("\\(x\\)"), "x")
})


test_that("LaTEX strings are anchored with delimiters as a full equeation", {
  eq1 <- function(x) paste0("$f(x) = ", x, "$")
  eq2 <- function(x) paste0("$$f(x) = ", x, "$$")
  
  e1 <- "x^3 + 6x^2 - 14"
  expect_identical(finalize_equation(e1, "single"), eq1(e1))
  expect_identical(finalize_equation(e1), eq2(e1))
  
  e2 <- "\\left(\\frac{x - 1}{x + 2}\\right)^x"
  expect_identical(finalize_equation(e2, "single"), eq1(e2))
  expect_identical(finalize_equation(e2), eq2(e2))
  
  e3 <- "9\\sqrt{3}{45}"
  expect_identical(finalize_equation(e3, "single"), eq1(e3))
  expect_identical(finalize_equation(e3), eq2(e3))
})


# Evaluation of expressions ----
test_that("higher-order root functions are translated to inverted powers", {
  expect_identical(modify_roots("\\sqrt[3]x"), "x^(1/3)")
  expect_identical(modify_roots("\\sqrt[3]{x}"), "x^(1/3)")
  expect_identical(modify_roots("9\\sqrt[4]{y}"), "9y^(1/4)")
})


test_that("Valid R expessions are parsed from LaTeX as strings", {
  expect_type(generate_r_expr("\\sqrt[3]x"), "character")
  expect_identical(generate_r_expr("9\\sqrt[4]{y}"), "9 * y^(1 / 4)")
  expect_null(generate_r_expr("x +* 2"))
  expect_message(generate_r_expr("x +* 2"), "Invalid expression")
})


test_that("strings with R expressions are evaluated", {
  expect_s3_class(eval_r_expr("x^2", -5, 5), "data.frame")
  expect_s3_class(eval_r_expr("1/2*x", -5, 5), "data.frame")
  expect_named(eval_r_expr("1/x^2", -5, 5), c("x", "y"))
})


test_that("factorials are identified and parsed", {
  expect_equal(modify_factorials("4!"), "24")
  expect_equal(modify_factorials("5!"), "120")
  expect_equal(modify_factorials("1/5!"), "1/120")
})

# Plotting of functions ----
test_that("Plot objects are created", {
  result <- eval_r_expr("x^2", -5, 5)
  expect_s3_class(plot_function(result), "ggplot")
  expect_s3_class(plot_function(result, col = 'red', linewidth = 2), "ggplot")
  expect_s3_class(plot_function(result, equation = "$f(x) = x^2$"), 'ggplot')
})
