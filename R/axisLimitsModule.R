library(shiny)
source(here::here("R/axisValueModule.R"))
axisLimitsUI <- function(id, label = c('x', 'y'), min, max, width) {
  ns <- NS(id)
  match.arg(label)
  
  bslib::layout_columns(
    helpText(label),
    axisValueUI(ns("min"), "Minimun", initValue = min, width = width),
    axisValueUI(ns("max"), "Maximum", initValue = max, width = width)
  )
}



axisLimitsServer <- function(id) {
  moduleServer(
    id, 
    
    function(input, output, session) {
      reactive(
        c(
          min = axisValueServer("min")(), 
          max = axisValueServer("max")()
        )
      )
    }
  )
}
