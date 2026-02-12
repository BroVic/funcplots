source(here::here('R/axisValueModule.R'))

testServer(axisValueServer, {
  session$setInputs(value = 10)
  expect_equal(input$value, 10)
  
  result <- session$returned
  expect_true(is.reactive(result))
})
