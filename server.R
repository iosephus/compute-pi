
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
require(plotrix)

shinyServer(function(input, output) {
  
  # Generate random points using pars from ui.R
  rng_seed <- reactive({input$setseed_button;isolate(input$rng_seed)})
  
  x <- reactive({input$recalc_button;if (input$set_seed) set.seed(rng_seed());runif(input$num_points, -1.0, 1.0)})
  y <- reactive({input$recalc_button;runif(input$num_points, -1.0, 1.0)})

  in_circle <- reactive({sqrt(x()^2 + y()^2) < 1.0})
  num_in_circle <- reactive({sum(in_circle())})
  
  pi_est <- reactive({4.0 * num_in_circle() / input$num_points})
  
  result_table <- reactive({data.frame(estimation=pi_est(), 
                                       reference=pi,
                                       percent.error=100*(pi_est() - pi)/pi)})
  
  output$num_points <- renderText({num_points})
  
  output$num_in_circle <- renderText({num_in_circle()})
  
  output$pi_est <- renderText({paste("Estimation of PI:", round(pi_est(), 6))})
  output$pi_exact <- renderText({paste("Reference value:", round(pi, 6))})
  
  output$pi_error <- renderText({paste("Error:", round(100*(pi - pi_est()) / pi, 3), "%")})
  
  output$circle_plot <- renderPlot({

    input$recalc_button
    input$set_seed
    par(pty="s")
    plot(NULL, xlim=c(-1, 1), ylim=c(-1, 1), asp=1, main="Random points", xlab='Square side 2r', ylab='Square side 2r')
    points(x()[in_circle()], y()[in_circle()], col=rgb(0, 0, 1, alpha=0.4), pch=16)
    points(x()[!in_circle()], y()[!in_circle()], col=rgb(1, 0, 0, alpha=0.4), pch=16)
    #rect(-1, -1, 1, 1)
    #draw.circle(0, 0, 1, 100, border=rgb(0, 0, 0, alpha=0.1), col=rgb(0, 0, 0, alpha=0.1))
  })

})
