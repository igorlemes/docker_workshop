#### 0.0 - PACOTES ####

# manipulacao de dados
library(tidyr) # manipulacao de dados
library(dplyr) # manipulacao de dados
library(magrittr) # operador pipe
library(lubridate) # manipulacao de datas
library(stringr) # manipulacao de strings
library(forcats) # manipulacao de fatores

# visualizacao de dados
library(ggplot2) # visualizacao de dados
library(plotly) # graficos interativos
library(ggtext) # texto em ggplot
library(viridis) # paleta de cores
library(ggrepel) # textos em graficos
library(RColorBrewer) # paleta de cores
library(gridExtra) # grid de graficos
library(patchwork) # grid de graficos

# Visualizacao de Tabelas
library(DT) # visualizacao de tabelas

# Visualizacao de mapas
library(leaflet) # mapas
library(leafpop) # popups em mapas
library(leaflet.extras) # mapas
library(sf) # mapas
library(mapview) # mapas
library(leaflegend) # legendas em mapas

# Temas
library(ggthemes) # temas para ggplot
library(ggdark) # tema dark para ggplot

# Shiny
library(shinydashboard) # dashboard
library(shinydashboardPlus) # dashboard
library(shiny) # shiny
library(shinyWidgets) # shiny

sf::sf_use_s2(FALSE) # Desabilitar o uso do pacote s2, pois o poligono de algumas especies de aves sao "invalidos", no sentido de terem arestas que se cruzam Exemplo abaixo.
# Um exemplo de poligono invalido seria:
# A - - - B
# |       |
# C - - - D - E
#         |   |
#         F - G

#### 1.0 - DADOS ####
#### 4.0 - INTERFACE USUARIO ####

ui <- dashboardPage(
  # titulo do dashboard
  dashboardHeader(title = "")
  # Sidebar do dashboard
  dashboardSidebar(
    # Menu do dashboard
    sidebarMenu(
      menuItem("Mapa", tabName = "mapa", icon = icon("map")),
      menuItem("360", tabName = "360", icon = icon("camera")),
      menuItem("Graficos", tabName = "graficos", icon = icon("chart-line"))
    )
  ),
  # Corpo do dashboard
  dashboardBody(
    tags$style(type = "text/css", "
               #mapDiv { height: 86vh; overflow: auto; }
               #camDiv { height: 36.5vh; overflow: auto; }
               #graDiv { height: 36.5vh; overflow: auto; }
               "),
    # Row para o mapa que ocupa duas colunas em altura
    box(
      div(id = "mapDiv",
          leafletOutput("mapa", width = "100%", height = "100%")
          ), 
      solidHeader = TRUE, 
      title = "Malha Amostral", 
      status = "primary"
      ),
    box(
      div(id = "camDiv"
          
          ),
      title = "360", 
      width = 6, 
      solidHeader = TRUE, 
      status = "primary",
      "Conteúdo do Painel 2"),
    box(
      div(id = "graDiv"
          
      ),
      title = "Graficos", 
      width = 6, 
      solidHeader = TRUE, 
      status = "primary",
      "Conteúdo do Painel 3"),
  )
)

#### 5.0 - SERVER ####

server <- function(input, output, session) {
  
  #### PAINEL 1 ####
  # Definicao de Mapa
  output$mapa <- renderLeaflet({
    leaflet() %>%
      # Mapa Base
      addProviderTiles(providers$Esri.WorldImagery,options = tileOptions(opacity = 0.5)) %>%
      # Rejeito
      addPolygons(data = shapes$mancha_rejeito[[1]],
                  label = ~LAYER,
                  fillColor = c("brown", "black"), 
                  fillOpacity = 0.5, 
                  color = "black", 
                  weight = 1) %>%
      # Massas d'agua
      addPolygons(data = shapes$massas_dagua[[1]],
                  label = ~NOME,
                  fillColor = "skyblue", 
                  fillOpacity = 0.5, 
                  color = "black", 
                  weight = 1) %>%
      # Sub Bacias do Paraopeba
      addPolygons(data = shapes$bacias_hidrograficas[[4]],
                  fillColor = "transparente", 
                  fillOpacity = 0.10, 
                  color = "black", 
                  weight = 1,
                  group = "Sub-bacias do Paraopeba") %>%
      # Micro Bacias do Ferro Carvao
      addPolygons(data = shapes$bacias_hidrograficas[[1]],
                  label = ~sub,
                  fillColor = rainbow(3), 
                  fillOpacity = 0.10, 
                  color = "black", 
                  weight = 1,
                  group = "Micro-bacias do Ferro Carvao") %>%
      # Malha Hidrografica
      addPolylines(data = shapes$malha_hidrografica[[1]],
                   label = ~noriocomp,
                   color = "skyblue", 
                   weight = 1.25) %>%
      # Malha Amostral M1 - Ictiofauna + Biota Aquatica
      addCircleMarkers(data = shapes$Malha_Amostral$M1[[3]],
                       label = ~Name,
                       fillColor = "#8EDE99",
                       color = "white",
                       radius = 7,
                       stroke = T, 
                       opacity = .5,
                       fillOpacity = .8,
                       group = "Malha amostral Modulo 1") %>%
      # Malha Amostral M1 - Ictioplancton
      addCircleMarkers(data = shapes$Malha_Amostral$M1[[5]],
                       label = ~Name,
                       fillColor = "#8EDE99",
                       color = "white",
                       radius = 7,
                       stroke = T, 
                       opacity = .5,
                       fillOpacity = .8,
                       group = "Malha amostral Modulo 2") %>%
      # Malha Amostral M2 - Invertebrados
      addCircleMarkers(data = shapes$Malha_Amostral$M2[[1]],
                       label = ~Name,
                       fillColor = "#8EDDF9",
                       color = "white",
                       radius = 7,
                       stroke = T, 
                       opacity = .5,
                       fillOpacity = .8,
                       group = "Malha amostral Modulo 2") %>%
      # Malha Amostral M2 - Invertebrados
      addCircleMarkers(data = shapes$Malha_Amostral$M2[[2]],
                       label = ~Name,
                       fillColor = "#8EDDF9",
                       color = "white",
                       radius = 7,
                       stroke = T, 
                       opacity = .5,
                       fillOpacity = .8,
                       group = "Malha amostral Modulo 2") %>%
      # Malha Amostral M3 - Andorinhas
      addCircleMarkers(data = shapes$Malha_Amostral$M3[[1]],
                       label = ~Transecto,
                       fillColor = "#FF9F00",
                       color = "white",
                       radius = 7,
                       stroke = T, 
                       opacity = .5,
                       fillOpacity = .8,
                       group = "Malha amostral Modulo 3") %>%
      # Malha Amostral M3 - Lontras
      addCircleMarkers(data = st_cast(shapes$Malha_Amostral$M3[[2]], "POINT"),
                       label = ~name,
                       fillColor = "#FF9F00",
                       color = "white",
                       radius = 7,
                       stroke = T, 
                       opacity = .5,
                       fillOpacity = .8,
                       group = "Malha amostral Modulo 3") %>%
      # Malha Amostral M3 - Cagados
      addCircleMarkers(data = shapes$Malha_Amostral$M3[[3]],
                       label = ~Ponto_amos,
                       fillColor = "#FF9F00",
                       color = "white",
                       radius = 7,
                       stroke = T, 
                       opacity = .5,
                       fillOpacity = .8,
                       group = "Malha amostral Modulo 3") %>%
      # Malha Amostral M4 - Areas de Estudo
      addPolygons(data = shapes$areas_estudo[[1]],
                  label = ~Name,
                  fillColor = "#FDD834", 
                  fillOpacity = 0.2, 
                  color = "black", 
                  weight = 1,
                  group = "Malha amostral Modulo 4") %>%
      # Controle de camadas visiveis
      addLayersControl(position = "topleft",
                       baseGroups = c("Esri.WorldImagery"),
                       overlayGroups = c("Malha amostral Modulo 1","Malha amostral Modulo 2","Malha amostral Modulo 3","Malha amostral Modulo 4","Micro-bacias do Ferro Carvao","Sub-bacias do Paraopeba"),
                       options = layersControlOptions(collapsed = T))
      
      
  })
  
  # Atualiza um valor reativo para armazenar o ponto clicado
  observeEvent(input$mapa_marker_click, {
    click <- input$mapa_marker_click
    shiny::updateTextInput(session, "selectedPoint", value = click$id)
  })
  
  #### PAINEL 2 ####
  # Definicao do grafico a ser plotado no painel 2
  
  
  #### PAINEL 3 ####
  
  
  
  # # Definicao do mapa de Riqueza por Campanha
  # output$S_by_Camp <- renderPlot({
  #   ggplot(data = NULL) +
  #     geom_point(data = NULL, aes(x = NULL, y = NULL)) +
  #     theme_minimal()
  # })

}

#### 6.0 - SHINYAPP ####

runApp(list(ui = ui, server = server), port = 1234, host = "0.0.0.0")