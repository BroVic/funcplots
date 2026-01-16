
# Processes a mathematical expression from its formula to
# a form that can be understood by R. For example, the 
# expression `2x` would now be processed to correctly be
# read in its form `2 * x`.
process_parsed_expr <- function(expr) {
  expr_terms <- deconstruct_math_expr(expr)
  
  out <- purrr::map_chr(expr_terms, function(elem) {
    expr_zero_frac <- str_replace_all(elem, "[^1-9][^0-9]?0/[1-9]+", "0")
    
    if (str_detect(expr_zero_frac, "[[:digit:]]+/0"))
      stop("The expression is undefined")
    
    expr_zero_frac %>%
      str_replace_all("([1-9][0-9]*)([a-zA-Z])", "\\1 * \\2") %>%
      str_squish() %>% 
      mathjax_to_r()
  })
  
  out %>% 
    str_flatten() %>% 
    str_replace_all("\\s")
}




# Parse a mathematical expression presented in string format by
# breaking it up into sequential segments separated by add/subtract
# operators
deconstruct_math_expr <- function(expr) {
  expr <- stringr::str_remove_all(expr, " ")
  expr_raw <- charToRaw(expr)
  operator_positions <- list()
  operators <- structure(charToRaw("+-"), names = c("plus", "minus"))
  
  for (sign in names(operators))
    operator_positions[[sign]] <- which(expr_raw %in% operators[sign])
  
  positions <- sort(unlist(operator_positions))
  
  ## In the event that the first character of an expression is one of the 
  ## 'sign' operators, we have to count it not as a term separator but as
  ## part of the first term.
  if (expr_raw[1] %in% operators)
    positions <- positions[-1]
    
  term_list <- list()
  end <- length(expr_raw)
  
  for (pos in rev(positions)) {
    if (pos < end) {
      term_list <- c(term_list, list(expr_raw[pos:end]))
      end <- pos - 1L
    }
  }
  term_list <- rev(c(term_list, list(expr_raw[1:end])))
  lapply(term_list, rawToChar)
}




mathjax_to_r <- function(expr) {
  expr %>% 
    str_replace_all("\\\\times", "*") %>% 
    str_replace_all("\\\\frac\\{(\\d+)\\}\\{(\\d+)\\}", "\\1/\\2") %>% 
    str_replace_all("(\\\\)?(sin|cos|tan)(\\s*)\\{?(\\w+)\\}?", "\\2(\\4)") %>% 
    str_replace_all("\\\\cdot ", "* ")
}


######################    UNIT TESTS     ########################

# test_that("MathJax expressions are converted into valid R expresssions", {
#   expect_identical(mathjax_to_r("\\sin60"), "sin(60)")
#   expect_identical(mathjax_to_r("\\sinx"), "sin(x)")
#   expect_identical(mathjax_to_r("\\frac{1}{2}"), "(1)/(2)")
#   expect_identical(mathjax_to_r("\\frac{1}{2}x"), "(1)/(2)*x")
#   expect_identical(mathjax_to_r("2 \\times 42"), "2*42")
#   expect_identical(mathjax_to_r("\\left(\\frac{x - 1}{x + 2}\\right)^x"),
#                    "((x-1)(x+2))^x")
#   expect_identical(mathjax_to_r("x!"), "factorial(x)")
#   expect_identical(mathjax_to_r("6!"), "factorial(6)")
#   expect_identical(mathjax_to_r("\\frac{x}{6!}"), "(x)/factorial(6)")
#   expect_identical(mathjax_to_r("7\\cdot x"), "7*x")
# })

 
# test_that("A valid equation is returned", {
#   result <- evaluate_expr("x^3", -10, 10)
#   
#   expect_type(result, "list")
#   expect_length(result, 2L)
#   expect_type(result$x, "double")
#   expect_type(result$y, "double")
#   expect_type(evaluate_expr("1/2 * x", -5, 5), "list")
# })


# test_that("Algebra strings become computable entities", {
#   expect_identical(process_parsed_expr("2x"), "2 * x")
#   expect_identical(process_parsed_expr("x^2"), "x^2")
#   expect_identical(process_parsed_expr("1/2x"), "1/2 * x")
#   expect_identical(process_parsed_expr("1x/2"), "1 * x/2")
# })


# test_that("The expression can be parsed into component parts", {
#   result <- deconstruct_math_expr("3x^3 + 2x^2 - 10x + 24")
#   
#   expect_type(result, "list")
#   expect_length(result, 4)
#   expect_identical(deconstruct_math_expr("x^2"), list("x^2"))
#   expect_identical(deconstruct_math_expr("a + 2"), list("a", "+2"))
#   expect_identical(deconstruct_math_expr("-2"), list("-2"))
#   expect_identical(deconstruct_math_expr("-2x^2 + 3x - 9"), 
#                    list("-2x^2", "+3x", "-9"))
#   expect_length(deconstruct_math_expr("1/2x"), 1)
# })
