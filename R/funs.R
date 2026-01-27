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



# Remove any MathJax tabs that are part of a string. This is based on a design
# decision that assumes that the user has some knowledge of MathJax syntax
# and may have included it when entering an expression. 
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




# Change a LaTeX expression that has higher-order roots and represent them as
# inverted powers, so that the expression can be correctly parsed. This is
# necessary because the latex2r::latex2r() function does not support handling
# of the higher-order roots e.g. \\sqrt[3]x--in this case we would change it to
# x^(1/3)
modify_roots <- function(expr_str) {
  root_fun <- "(\\\\sqrt\\[)(\\d+)(\\])(\\{?)([0-9]+|[[:alpha:]])(\\}?)"

  expr_str %>%
    str_replace_all(root_fun, "\\5^(1/\\2)") %>%
    str_trim()
}




generate_r_expr <- function(latex_str) {
  latex_str |>
    modify_roots() |>
    latex2r::latex2r()
}



# Plot expression ----
plot_function <- function(x, y, ...) {
  stopifnot(is.numeric(x) && is.numeric(y))
  require(ggplot2)
  require(scales)
  
  data.frame(x = x, y = y) |>
    ggplot(aes(x, y)) +
    geom_line(...) +
    labs(y = "f(x)") +
    theme_minimal(base_size = 13) +
    theme(
      axis.title = element_text(family = "serif", face = "italic", size = 16),
      axis.title.y = element_text(angle = 0, vjust = 0.5),
      axis.text = element_text(size = 10)
    ) +
    scale_x_continuous(n.breaks = 10)
}
