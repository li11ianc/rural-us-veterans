library(shiny)
library(tidyverse)
library(maps)
library(shinythemes)

theme_custom <- function() {
  theme_bw() +
    theme(
      axis.title = element_text(size = 16), 
      title = element_text(size = 20),
      legend.title = element_text(size = 10),
      legend.text = element_text(size = 10),
      axis.text.x = element_text(size = 12),
      axis.text.y = element_text(size = 12),
      plot.caption = element_text(size = 10))
}

vets <- read_csv("data/rural_vets_complete_clean.csv")

center_coords <- lapply(state.center, unlist) %>%
  bind_rows()

center_coords$state <- sapply(state.name, paste0)

vets_map <- inner_join(vets, center_coords, by = "state")


ui <- fluidPage(theme = shinytheme("yeti"),
                textInput(inputId = "demo",
                              label   = "Rural/Urban/Total",
                              value   = "Rural"),
                plotOutput(outputId = "plot"))


server <- function(input, output) {
  output$plot <- renderPlot({
    
    x_map <- vets_map %>%
      filter(rural_urban == input$demo, state != "Alaska", state != "Hawaii")

    us_map <- map_data("state")
    
    # create visualization
    cols <- c("Rural" = "#F4200B", "Urban" = "#F4D03F", "Total" = "#8E44AD")
    
    ggplot() + 
      geom_polygon(data = us_map, aes(x=long, y=lat, group=group),
                   color="#85C1E9", fill = "#EBF5FB") +
      geom_point(data = x_map, aes(x = x, y = y, size = total, color = rural_urban, alpha = .7))  +
      scale_size_continuous(range=c(1,15)) +
      scale_color_manual(values = cols) +
      coord_map()
  })

}


shinyApp(ui = ui, server = server)
