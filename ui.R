library(shiny)
library(bslib)

ui <- page_sidebar(
  plotOutput("plot"),
  
  accordion(
    accordion_panel(
      title = "Plot Settings",
      
      colourpicker::colourInput(
        inputId = "color",
        label = "Pick a color",
        value = "blue",
        showColour = "background",
        palette = "limited",
        width = "30%"
      ), 
      
      sliderInput("linewidth", "Linewidth", 1, 5, 2, ticks = FALSE)
    ),
    
    open = FALSE
  ),
  
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
      card_body(
        numericInput("min", "", value = -5, width = "70px"),
        numericInput("max", "", value = 5, width = "70px")
      ),
      id = "axis"
    )
  ),
  
  title = "Display Mathematical Functions",
  window_title = "Function Plots",
  lang = "en",
  theme = bs_theme(bootswatch = 'flatly')
)
