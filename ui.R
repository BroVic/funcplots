library(shiny)
library(colourpicker)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      withMathJax(),
      
      textInput("expr", "Enter an expression with variable 'x'", "x^2"),
      
      uiOutput("equation"),
      
      hr(),
      
      numericInput("xmin", "x-minimum", -5, width = "30%"),
      
      numericInput("xmax", "x-maximum", 5, width = "30%"),
      
      actionButton("go", "Plot!")
    ),
    mainPanel(
      plotOutput("plot"),
      
      colourInput(
        inputId = "color",
        label = "Pick a color",
        value = "black",
        showColour = "background",
        palette = "limited",
        width = "30%"
      ), 
      
      sliderInput("linewidth", "Linewidth", 1, 10, 1, ticks = FALSE)
    )
  )
)
