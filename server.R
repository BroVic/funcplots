library(shiny)

# There is a design decision in the server function that needs to be 
# communicated. The expression that is received from the user is going to be
# modified (if necessary) independently of the actual plotting. Thus, the same
# input will be parsed for display as MathJax AND evaluated for plotting. Any
# changes that were made to enhance its rendering as mathematical notation will
# be ignored in subsequent steps.
server <- function(input, output, session) {
  
  # Reactive expressions ----
  latex <- reactive({
    req(input$expr)
    
    input$expr |>
      remove_mathjax_delims() |>
      make_latex_fractions()
  })
  
  result <- reactive({
    req(input$xmin, input$xmax)
    evaluate_expr(expr_string(), input$xmin, input$xmax)
  }) 
    
  # This reactive element exist purely for the purpose of isolating the
  # reactivity of the expression and plotting limits, making them relevant
  # only when the actionButton is clicked
  expr_string <- eventReactive(
    input$go,
    generate_r_expr(latex()),
    ignoreNULL = FALSE
  )

  
  # Outputs ----
  output$equation <- renderUI({
    latex_str <- finalize_equation(latex())
    withMathJax(helpText(latex_str))
  })
  
  
  output$plot <- renderPlot({
    plot_function(
      result()$x,
      result()$y, 
      col = input$color,
      linewidth = input$linewidth
    )
  })
}
