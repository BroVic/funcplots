library(shinytest2)



test_that("{shinytest2} recording: latex-input", {
  app <- AppDriver$new(
    test_path("../.."), 
    name = "latex-input", 
    height = 558, 
    width = 735
  )
  
  app$set_inputs(expr = "x^3")
  app$expect_values(output = c("download", "equation"))
  app$set_inputs(expr = "x^3 ")
  app$set_inputs(expr = "x^3 +")
  app$set_inputs(expr = "x^3 + 2")
  app$expect_values(output = c("download", "equation"))
  app$set_inputs(expr = "x^3 + 2x")
  app$expect_values(output = c("download", "equation"))
  app$set_inputs(expr = "x^3 + 2x^")
  app$set_inputs(expr = "x^3 + 2x^2")
  app$expect_values(output = c("download", "equation"))
  app$set_inputs(expr = "x^3 + 2x^2 ")
  app$set_inputs(expr = "x^3 + 2x^2 +")
  app$set_inputs(expr = "x^3 + 2x^2 + ")
  app$set_inputs(expr = "x^3 + 2x^2 + 5")
  app$expect_values(output = c("download", "equation"))
  app$set_inputs(expr = "x^3 + 2x^2 + 5x")
  app$expect_values(output = c("download", "equation"))
  app$set_inputs(expr = "x^3 + 2x^2 + 5x ")
  app$set_inputs(expr = "x^3 + 2x^2 + 5x - ")
  app$set_inputs(expr = "x^3 + 2x^2 + 5x - 21")
  app$expect_values(output = c("download", "equation"))
})


test_that("{shinytest2} recording: plot-settings", {
  app <- AppDriver$new(test_path("../.."), name = "plot-settings", height = 558, 
      width = 735)
  app$expect_values(output = c("download", "equation"))
  app$set_inputs(color = "#FF0000")
  app$expect_values(output = c("download", "equation"))
  app$set_inputs(linewidth = 3)
  app$expect_values(output = c("download", "equation"))
  app$set_inputs(linewidth = 5)
  app$expect_values(output = c("download", "equation"))
})


test_that("{shinytest2} recording: invalid_expr", {
  app <- AppDriver$new(test_path("../.."), name = "invalid_expr", height = 558, width = 735)
  app$set_inputs(expr = "x2")
  app$set_window_size(width = 735, height = 558)
  app$set_inputs(expr = "x+*2")
  app$set_window_size(width = 735, height = 558)
  app$click("go")
  app$expect_values()
})


test_that("{shinytest2} recording: reverse_x_order", {
  app <- AppDriver$new(test_path("../.."), name = "reverse_x_order", height = 558, 
      width = 735)
  app$set_inputs(min = character(0))
  app$set_inputs(min = 5)
  app$set_inputs(max = character(0))
  app$set_inputs(max = -5)
  app$expect_values()
})
