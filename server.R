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
    get_latex_str(input$expr)
  })
  
  
  xydata <- reactive({
    req(input$min, input$max)
    eval_r_expr(expr_string(), input$min, input$max) 
  }) 
    
  # This reactive element exist purely for the purpose of isolating the
  # reactivity of the expression from the plotting limits, making them
  # relevant only when the `actionButton` is clicked.
  expr_string <- reactive({
    generate_r_expr(latex())
  }) |>
    bindEvent(input$go, ignoreNULL = FALSE)

  
  # Outputs ----
  output$equation <- renderUI({
    withMathJax(
      helpText(
        finalize_equation(latex())
      )
    )
  })
  
  
  output$plot <- renderPlot({
    plot_function(
      xydata(),
      equation = finalize_equation(latex(), delim = 'single'),
      col = input$color,
      linewidth = input$linewidth
    )
  })
}
