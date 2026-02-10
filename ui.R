library(shiny)
library(bslib)

szNumImput <- function() {
  "70%"
}
ui <- page_sidebar(
  
  plotOutput("plot"),
  
  colourpicker::colourInput(
    inputId = "color",
    label = "Pick a color",
    value = "blue",
    showColour = "background",
    palette = "limited",
    width = "30%"
  ), 
  
  sliderInput("linewidth", "Linewidth", 1, 5, 2, ticks = FALSE),
  
  sidebar = sidebar(
    width = 350,
    
    withMathJax(),
    
    input_dark_mode(id = 'theme'),
    
    textInput(
      "expr",
      "Enter an expression with variable 'x'", 
      value = "x^2",
      placeholder = r"(e.g., x^3 - 4x^2 + 5x - 6, \sin x, e^x)"
    ),
    
    uiOutput("equation"),

    actionButton("go", "Plot!"),
    
    card(
      card_header("Axes"),
      
      card_body(
        axisLimitsUI("xval", "x", min = -5, max = 5, width = "70%"),
        axisLimitsUI("yval", "y", min = 0, max = 30, width = "70%")
      ),
      
      id = "axes"
    )
  ),
  
  title = "Display Mathematical Functions",
  
  window_title = "Function Plots",
  
  lang = "en",
  
  theme = bs_theme(bootswatch = 'flatly')
)
