library(shiny)


ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      withMathJax(), 
      textInput("expr", "Enter an expression with variable 'x'", "x^2"),
      uiOutput("equation"),
      hr(),
      numericInput("min", "x-minimum", -5, width = "30%"),
      numericInput("max", "x-maximum", 5, width = "30%"),
      actionButton("go", "Plot!")
    ),
    mainPanel(
      plotOutput("plot")
    )
  )
)
