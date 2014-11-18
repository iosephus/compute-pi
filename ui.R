
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Estimate PI by a geometric Monte Carlo method"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      
      sliderInput("num_points",
                  "Number of points:",
                  min = 2000,
                  max = 100000,
                  value = 10000),
      checkboxInput("set_seed", "Set RNG seed", value=FALSE),
      conditionalPanel(condition="input.set_seed",
                       numericInput("rng_seed", "Enter seed:", 623),
                       actionButton("setseed_button", "Set seed")),
      conditionalPanel(condition="!input.set_seed",
                       actionButton("recalc_button", "Recalculate")),
      h3("Use"),
      p(paste0("Each time the *Recalculate* button is pressed a new set of points ",
               "randomly positioned inside the square is generated. The slider ",
               "allows to change the number of generated points. The Random ",
               "Number Generator (RNG) is seeded with a random value every time. ",
               "Activating the *Set RNG seed* checkbox allows to seed the ",
               "RNG with an integer provided by the user.")),
      h3("PI Estimation"),
      p(paste0("PI is computed using the formula for the area of the circle. ",
               "The area of the square is known to be 4*r*r, where r is the ",
               "radius of the inscribed circle and half the side of the square.",
               "The area of the circle respect to the square is estimated by ", 
               "Monte Carlo, generating random positions inside the square and",
               " counting what portion of them fall inside the inscribed circle. ",
               "PI can be estimated as 4 * NI / N, where N is the total number of ",
               "randomly positioned points and NI os the amount falling inside the circle."))
    ),

    # Show a plot of the generated distribution
    mainPanel(
      h4(textOutput("pi_est")),
      h4(textOutput("pi_exact")),
      h4(textOutput("pi_error")),
      plotOutput("circle_plot")

    )
  )
))
