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
cols <- c("Rural" = "#F4200B", "Urban" = "#2C0A90", "Total" = "#F4D03F",
          "West" = "#E67E22", "Midwest" = "#F1C40F", "Northeast" = "#C0392B", 
          "South" = "#2980B9")
us_map <- map_data("state")

ui <- fluidPage(theme = shinytheme("superhero"),
                navbarPage(title = "Get to Know America's Rural Veterans",
                           tabPanel("US Map",
                                    sidebarLayout(
                                      sidebarPanel(
                                        checkboxGroupInput(inputId = "checkbox_tru",
                                                  label   = "Select which veterans to display",
                                                  choices = list("Rural", "Urban", "Total"),
                                                  selected = c("Rural", "Urban"),
                                                  inline = TRUE),
                                        h3("Explore state data"),
                                        selectInput(inputId = "select_state",
                                                    label = "Choose a state to explore",
                                                    choices = state.name),
                                        radioButtons(inputId = "select_charac",
                                                    label = "Select characteristic of interest",
                                                    choices = list("Poverty" = "in_poverty", 
                                                                   "Unemployment" = "unemployed",
                                                                   "Insurance" = "uninsured",
                                                                   "Disability" = "va_disability"
                                                                   )),
                                        h4("Notes"),
                                        textOutput(outputId = "text"),
                                        tags$head(tags$style("#text{color: white;
                                                              font-size: 12px;
                                                              font-style: italic;
                                                              }")
                                        )
                                      ),
                                     mainPanel(
                                       plotOutput(outputId = "usvets_map"),
                                       plotOutput(outputId = "poverty_plot"))
                                    )
                                    ),
                           tabPanel("Background Information",
                                    column(width = 2),
                                    column(width = 8,
                                           h1("Title 1"),
                                           h3("subheading 1"),
                                           p("Some text about vets!"),
                                           h3("subheading 2"),
                                           p("more text and helpful info")
                                    )
                                    )))


server <- function(input, output) {
  output$usvets_map <- renderPlot({
    
    x_map <- vets_map %>%
      filter(rural_urban %in% input$checkbox_tru, state != "Alaska", state != "Hawaii") %>%
      mutate(rural_urban = fct_relevel(rural_urban, c("Total", "Urban", "Rural")))
    
    # create visualization
  
    ggplot() + 
      geom_polygon(data = us_map, aes(x=long, y=lat, group=group),
                   color="#85C1E9", fill = "#EBF5FB") +
      geom_point(data = x_map, aes(x = x, y = y, size = total, color = rural_urban, alpha = .7)) +
      scale_size_continuous(range=c(1,15)) +
      scale_color_manual(values = cols) +
      coord_map() +
      theme(legend.position = "none")
    
    
  })
  output$poverty_plot <- renderPlot({
    vets %>%
    filter(rural_urban == "Rural") %>%
    ggplot(aes_string(x = paste0("reorder(state, -", input$select_charac, ")"), y = input$select_charac, fill = "region")) +
    geom_bar(stat = "identity") +
    scale_fill_manual(values = cols, name = "Region") +
    theme_light() +
    theme(plot.title = element_text(color = "#1A5276", size = 18, face = "bold"),
          axis.title.x = element_text(color = "#1A5276", size = 11, face = "bold"),
          axis.title.y = element_text(color = "#1A5276", size = 11, face = "bold"),
          axis.text.x = element_text(color = "gray45", size = 7, angle = 70, hjust = 1),
          axis.ticks = element_blank(),
          legend.title = element_text(color = "#1A5276", size = 11, face = "bold"))+
    labs(title = "Rural Veterans Living in Poverty", y = "Percent in poverty", x = "State")
  })
  
  output$text <- renderText({
    if ("Poverty" %in% input$select_charac){
      paste("For some persons, such as unrelated individuals under age 15, poverty status is not 
            defined. Since Census Bureau surveys typically ask income questions to persons age 
            15 or older, if a child under age 15 is not related by birth, marriage, or adoption 
            to a reference person within the household, we do not know the child's income and 
            therefore cannot determine his or her poverty status. For the American Community 
            Survey, poverty status is also undefined for people living in college dormitories 
            and in institutional group quarters.")
    }
  })

}


shinyApp(ui = ui, server = server)
