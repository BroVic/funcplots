axisValueUI <- function(id, label, initValue, width, ...) {
  ns <- NS(id)
  numericInput(ns("value"), label, value = initValue, width = width, ...)
}



axisValueServer <- function(id) {
  moduleServer(
    id,
    
    function(input, output, session) {
      reactive(input$value)
    }
  )
}
