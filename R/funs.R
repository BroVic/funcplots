library(stringr)

# Display equation ----

# Processes the supplied input in order to properly present
# input as a typeset mathematical expression/equation
finalize_equation <- function(str, delim = c("double", "single")) {
  delim <- match.arg(delim)
  delimval <- "$$"
  
  if (identical(delim, "single"))
    delimval <- "$"
  
  paste0(delimval, "f(x) = ", str, delimval)
}


# Remove any MathJax tabs that are part of a string. This is based on a design
# decision that assumes that the user has some knowledge of MathJax syntax
# and may have included it when entering an expression. 
remove_mathjax_delims <- function(str) {
  str %>% 
    str_remove_all("(^\\$)|(\\$$)") %>%
    str_remove_all("(^\\$)|(\\$$)") %>%
    str_replace("^(\\\\\\()(.+)(\\\\\\))$", "\\2")
}




# deal with input values that are fractions - the intention is to first
# make them look appealing in the expression, and secondly to make sure
# the fraction is valid
make_latex_fractions <- function(expr) {
  if (str_detect(expr, "\\frac"))
    expr <- str_replace_all(expr, "(\\frac)", "\\\\frac")
  
  mj <- expr %>% 
    str_replace_all("\\(([^(]+)\\)/\\(([^)]+)\\)", "\\\\frac{\\1}{\\2}") %>% 
    str_replace_all("([[:digit:]]+)/([[:digit:]]+)", "\\\\frac{\\1}{\\2}")
  
  if (str_detect(mj, "left|right"))
    return(mj)
  
  str_replace_all(mj, "\\((\\\\frac.+)\\)", "\\\\left(\\1\\\\right)")
}




get_latex_str <- function(str) {
  str |>
    remove_mathjax_delims() |>
    make_latex_fractions()
}

# Evaluate expression ----

eval_r_expr <- function(expr_str, xmin, xmax) {
  x <- seq(xmin, xmax, by = .001)
  y <- eval(parse(text = expr_str))
  data.frame(x = x, y = y)
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




# Changes a number or symbol with factorial notation to the valid
# R expression. Because `{latex2r}` does not support factorials
# at all, we will have to expand the factorial to its component parts.
# We use the gamma function to obtain the factorial value to account
# for fractions.
modify_factorials <- function(str) {
  expand <- function(fct) {
    n <- as.numeric(fct)
    as.character(gamma(n + 1))
  }
  
  fctrgx <-"[[:digit:]]+!"
  fct_list <- str_extract_all(str, fctrgx)
  
  for (i in seq_along(fct_list)) {
    n_chr <- str_remove(fct_list[[i]], "!")
    rep <- expand(n_chr)
    str <- str_replace(str, fctrgx, rep)
  }
  str
}




generate_r_expr <- function(latex_str) {
  latex_str |>
    modify_roots() |>
    latex2r::latex2r()
}



# Plot expression ----
plot_function <- function(data, equation = NULL, ...) {
  stopifnot(identical(names(data), c('x', 'y')))
  require(ggplot2, quietly = TRUE)
  require(scales, quietly = TRUE)
  
  # eq <- if (is.null(equation))
  #   latex2exp::TeX(r"($ $)")
  # else
  #   latex2exp::TeX(equation)
  
  ggplot(data, aes(x, y)) +
    geom_line(...) +
    labs(y = "f(x)", alt = "A plot showing math function(s)") +
    theme(
      plot.title = element_text(hjust = 0.5, face = "bold", size = 16),
      axis.title = element_text(
        family = "serif", face = "bold.italic", size = 16
      ),
      axis.title.y = element_text(angle = 0, vjust = 0.5),
      axis.text = element_text(size = 10)
    ) +
    scale_x_continuous(n.breaks = 10)
}
