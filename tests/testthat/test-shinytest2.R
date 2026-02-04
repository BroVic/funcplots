library(shinytest2)



test_that("{shinytest2} recording: latex-input", {
  app <- AppDriver$new(test_path("../.."), name = "latex-input", height = 558, width = 735)
  app$set_inputs(expr = "x^3")
  app$set_inputs(expr = "x^3 ")
  app$set_inputs(expr = "x^3 +")
  app$set_inputs(expr = "x^3 + 2")
  app$set_inputs(expr = "x^3 + 2x")
  app$set_inputs(expr = "x^3 + 2x^")
  app$set_inputs(expr = "x^3 + 2x^2")
  app$set_inputs(expr = "x^3 + 2x^2 ")
  app$set_inputs(expr = "x^3 + 2x^2 +")
  app$set_inputs(expr = "x^3 + 2x^2 + ")
  app$set_inputs(expr = "x^3 + 2x^2 + 5")
  app$set_inputs(expr = "x^3 + 2x^2 + 5x")
  app$set_inputs(expr = "x^3 + 2x^2 + 5x ")
  app$set_inputs(expr = "x^3 + 2x^2 + 5x - ")
  app$set_inputs(expr = "x^3 + 2x^2 + 5x - 21")
  app$expect_values()
})
