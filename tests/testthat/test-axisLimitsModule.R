source(here::here("R/axisLimitsModule.R"))


testServer(axisLimitsServer, {
  session$setInputs(`min-value` = -10, `max-value` = 10)
  result <- session$returned
  expect_true(is.reactive(result))
  expect_equal(result()[['min']], -10)  # `[[` strips the names
  expect_equal(result()[['max']], 10)
})
