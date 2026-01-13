library(shiny)

# There is a design decision in the server function that needs to be 
# communicated. The expression that is received from the user is going to be
# modified (if necessary) independently of the actual plotting. Thus, the same
# input will be parsed for display as MathJax AND evaluated for plotting. Any
# changes that were made to enhance its rendering as mathematical notation will
# be ignored in subsequent steps.
server <- function(input, output, session) {
  output$equation <- renderUI({
    expr <- input_to_mathjax(input$expr)
    withMathJax(helpText(expr))
  })
  
  # This reactive element exist purely for the purpose of isolating the
  # reactivity of the expression and plotting limits, making them relevant
  # only when the actionButton is clicked
  result <- eventReactive(input$go, {
    req(input$xmin, input$xmax)
    expr_string <- latex2r::latex2r(input$expr)
    evaluate_expr(expr_string, input$xmin, input$xmax)
  })

  output$plot <- renderPlot({
    plot_function(result()$x, result()$y)
  })
}
