library(shiny)


ui <- fluidPage(
      tags$head(
    tags$link(rel = "stylesheet", href = "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css")
  ),
  titlePanel("Mapa de Amostragem"),
  sidebarPanel(
    numericInput("num_points", "Numero de Pontos:", min = 1, max = 100, value = 10),
    sliderInput("dist", "Espacamento entre Pontos (graus):", min = 0.01, max = 20, value = 0.03, step = 0.01),
    sliderInput("variance", "Variancia na Riqueza:", min = 0, max = 100, value = 50), 
  )
)


server <- function(input, output) {

}

runApp(list(ui = ui, server = server), port = 4242, host = "0.0.0.0")