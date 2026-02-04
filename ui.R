library(shiny)
library(colourpicker)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      withMathJax(),
      
      textInput("expr", "Enter an expression with variable 'x'", "x^2"),
      
      uiOutput("equation"),
      
      hr(),
      
      fluidRow(
        column(width = 6, numericInput("xmin", "minimum", -5, width = "70%")),
        column(width = 6, numericInput("xmax", "maximum", 5, width = "70%"))
      ),
      
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
