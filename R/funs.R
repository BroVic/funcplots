library(stringr)

# Display equation ----

# Processes the supplied input in order to properly present
# input as a typeset mathematical expression/equation
input_to_mathjax <- function(expr) {
  expr_out <- expr %>% 
    remove_mathjax_tags() %>% 
    make_mathjax_fractions()
  
  paste0("$$f(x) = ", expr_out, "$$")
}




remove_mathjax_tags <- function(str) {
  str %>% 
    str_remove_all("(^\\$)|(\\$$)") %>%
    str_remove_all("(^\\$)|(\\$$)") %>%
    str_replace("^(\\\\\\()(.+)(\\\\\\))$", "\\2")
}




# deal with input values that are fractions - the intention is to first
# make them look appealing in the expression, and secondly to make sure
# the fraction is valid
make_mathjax_fractions <- function(expr) {
  if (str_detect(expr, "\\frac"))
    expr <- str_replace_all(expr, "(\\frac)", "\\\\frac")
  
  mj <- expr %>% 
    str_replace_all("\\(([^(]+)\\)/\\(([^)]+)\\)", "\\\\frac{\\1}{\\2}") %>% 
    str_replace_all("([[:digit:]]+)/([[:digit:]]+)", "\\\\frac{\\1}{\\2}")
  
  if (str_detect(mj, "left|right"))
    return(mj)
  
  str_replace_all(mj, "\\((\\\\frac.+)\\)", "\\\\left(\\1\\\\right)")
}




# Evaluate expression ----

evaluate_expr <- function(expr_str, xmin, xmax) {
  x <- seq(xmin, xmax, by = .001)
  y <- eval(parse(text = expr_str))
  list(x = x, y = y)
}




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
  str_flatten(out)
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
    str_replace_all("(\\\\)?(sin|cos|tan)(\\s*)\\{?(\\w+)\\}?", "\\2(\\4)")
}




# Plot expression ----
plot_function <- function(x, y) {
  stopifnot(is.numeric(x) && is.numeric(y))
  require(ggplot2)
  require(scales)
  
  data.frame(x = x, y = y) |>
    ggplot(aes(x, y)) +
    geom_line() +
    theme_minimal(base_size = 13)
}
