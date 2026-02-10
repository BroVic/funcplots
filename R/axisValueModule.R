axisValueUI <- function(id, label, initValue, ...) {
  ns <- NS(id)
  numericInput(ns("value"), label, initValue, ...)
}



axisValueServer <- function(id) {
  moduleServer(
    id,
    
    function(input, output, session) {
      reactive(input$value)
    }
  )
}

ui <- fluidPage(
  axisValueUI("field", "Field", 10),
  verbatimTextOutput("out")
)
server <- function(input, output, session) {
  output$out <- renderPrint({
    axisValueServer("field")()
  })
}
shinyApp(ui, server)
