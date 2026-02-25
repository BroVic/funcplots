library(shiny)
library(bslib)

ui <- page_sidebar(
  title = "Mathematical Function Visualizer",
  fillable = TRUE,
  window_title = "Function Plotting",
  lang = "en",
  theme = bs_theme(bootswatch = 'flatly'),
  
  sidebar = sidebar(
    width = 300,
    withMathJax(),
    input_dark_mode(id = 'theme'),
    
    textInput(
      "expr",
      "Enter an expression with variable 'x'", 
      value = "x^2",
      placeholder = r"(e.g., x^3 - 4x^2 + 5x - 6, \sin{x}, e^x)"
    ),
    
    uiOutput("equation"),
    actionButton("go", "Plot!"),
    
    card(
      card_body(
        layout_columns(
          h6("x:"),
          numericInput("min", "Minimum", value = -10, width = "70px"),
          numericInput("max", "Maximum", value = 10, width = "70px"),
          col_widths = c(2, 5, 5)
        )
      ),
      id = "axis"
    ),
    
    hr(),
    
    downloadLink("download", "Save plot as...", "download-button")
  ),
  
  div(
    style = "display: flex; 
             flex-direction: column;
             height: '100%';
             justify-content: space;",
    
    plotOutput("plot", height = "400px"),
    
    accordion(
      id = "settings", 
      open = FALSE,
      multiple = FALSE,
      
      accordion_panel(
        title = "Plot Settings",
        value = "plot-settings",
        
        layout_columns(
          colourpicker::colourInput(
            inputId = "color",
            label = "Line color",
            value = "blue",
            showColour = "background",
            palette = "limited",
            width = "30%"
          ),
          sliderInput("linewidth", "Line width", 1, 5, 2, ticks = TRUE)
        )
      )
    )
  )
)
