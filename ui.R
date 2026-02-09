library(shiny)
library(bslib)

ui <- page_sidebar(
  plotOutput("plot"),
  
  colourpicker::colourInput(
    inputId = "color",
    label = "Pick a color",
    value = "black",
    showColour = "background",
    palette = "limited",
    width = "30%"
  ), 
  
  sliderInput("linewidth", "Linewidth", 1, 10, 1, ticks = FALSE),
  
  input_dark_mode(id = 'theme'),
  
  sidebar = sidebar(
    withMathJax(),
    
    textInput("expr", "Enter an expression with variable 'x'", "x^2"),
    
    uiOutput("equation"),
    
    hr(),
   
    layout_columns(
      numericInput("xmin", "minimum", -5, width = "70%"),
      numericInput("xmax", "maximum", 5, width = "70%")
    ), 
      
    actionButton("go", "Plot!")
  )
)
