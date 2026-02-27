library(shiny)
library(bslib)

ui <- page_sidebar(
  title = "Mathematical Function Visualizer",
  window_title = "Function Plotting",
  lang = "en",
  theme = bs_theme(bootswatch = 'flatly'),
  
  sidebar = sidebar(
    width = 300,
    withMathJax(),
    input_dark_mode(id = 'theme'),
    
    card(
      card_header(
        tooltip(
        span("Expression", bsicons::bs_icon("question-circle")),
        "Enter an expression based on a variable 'x' (LaTeX supported)",
        placement = "right"
        )
      ),
      textInput(
        "expr",
        NULL,
        value = "x^2",
        placeholder = r"(e.g., x^3 - 4x^2 + 5x - 6, \sin{x}, e^x)"
      ),
      
      uiOutput("equation")
    ), 
    
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
    
    card(downloadLink("download", "Save plot as...", "download-button"))
  ),
  
  card(
    fill = FALSE,
    plotOutput("plot", height = "400px")
  ),
  
  card(
    fill = FALSE,
    
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
            palette = "square",
            width = "20%"
          ),
          
          sliderInput("linewidth", "Line width", 1, 5, 2, ticks = TRUE)
        )
      )
    )
  )
)
