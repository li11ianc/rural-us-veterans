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
cols2 <- c("Rural" = "white", "Urban" = "black")
us_map <- map_data("state")

ui <- fluidPage(theme = shinytheme("superhero"),
                navbarPage(title = "America's Rural Veterans",
                           tabPanel("National",
                                    sidebarLayout(
                                      sidebarPanel(
                                        h2("Where are America's rural veterans?"),
                                        br(),
                                        h4("Title text whoop"),
                                        br(),
                                        checkboxGroupInput(inputId = "checkbox_tru",
                                                  label   = "Select which veterans to display:",
                                                  choices = list("Rural", "Urban"),
                                                  selected = c("Rural"),
                                                  inline = TRUE),
                                        br(),
                                        br(),
                                        radioButtons(inputId = "select_charac",
                                                    label = "Select characteristic of interest:",
                                                    choices = list("Poverty" = "in_poverty", 
                                                                   "Unemployment" = "unemployed",
                                                                   "Insurance" = "uninsured",
                                                                   "Disability" = "with_disability"
                                                                   )),
                                        br(),
                                        h4("Notes"),
                                        textOutput(outputId = "note_text"),
                                        tags$head(tags$style("#note_text{color: white;
                                                              font-size: 12px;
                                                              font-style: italic;
                                                              }")
                                        )
                                      ),
                                     mainPanel(
                                       fluidRow(
                                         plotOutput(outputId = "usvets_map", width = "925px", 
                                                  height = "550px")),
                                       br(),
                                       fluidRow(
                                       plotOutput(outputId = "poverty_plot", width = "800px",
                                                  height = "400px"), align = "center"),
                                       br()
                                    )
                                    )),
                           tabPanel("Regional",
                                    sidebarLayout(
                                      sidebarPanel(
                                        h3("Explore state data"),
                                        selectInput(inputId = "select_state",
                                                    label = "Choose a state to explore",
                                                    choices = state.name),
                                      ),
                                      mainPanel()
                                    )
                           ),
                           tabPanel("State",
                                    sidebarLayout(
                                      sidebarPanel(
                                        h3("Explore state data"),
                                        selectInput(inputId = "select_state",
                                                    label = "Choose a state to explore",
                                                    choices = state.name),
                                      ),
                                      mainPanel()
                                    )
                           ),
                           tabPanel("Background",
                                    column(width = 2),
                                    column(width = 8,
                                           h1("Title 1"),
                                           h3("subheading 1"),
                                           p("Some text about vets!", 
                                             style = "font-family: 'times'; font-si16pt"),
                                           h3("subheading 2"),
                                           p("more text and helpful info")
                                    ))
                           
                           ))


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
      scale_size_continuous(range=c(1,30)) +
      scale_color_manual(values = cols) +
      coord_map() +
      labs(title = paste0(paste0(input$checkbox_tru, collapse = " and "), 
                          " Veterans in the US, by State"), subtitle = "2011-2015") +
      theme(plot.title = element_text(color = "white", size = 22, face = "bold", hjust = .5),
            plot.subtitle = element_text(color = "white", size = 15, hjust = .5),
            axis.line=element_blank(),
            axis.text.x=element_blank(),
            axis.text.y=element_blank(),
            axis.ticks=element_blank(),
            axis.title.x=element_blank(),
            axis.title.y=element_blank(),
            legend.position="none",
            panel.background=element_rect(fill = "#4A5D6D", color = "#4A5D6D"),
            panel.border=element_blank(),
            panel.grid.major=element_blank(),
            panel.grid.minor=element_blank(),
            plot.background=element_rect(fill = "#4A5D6D", color = "#4A5D6D"))
    
    
  })
  output$poverty_plot <- renderPlot({
    vets %>%
    filter(rural_urban %in% input$checkbox_tru) %>%
    ggplot(aes_string(x = paste0("reorder(state, -", input$select_charac, ")"), 
                      y = input$select_charac, fill = "region", color = "rural_urban")) +
    geom_bar(stat = "identity") +
    scale_fill_manual(values = cols, name = "Region") +
    scale_color_manual(values = cols2, name = "Rural vs. Urban") +
    theme_light() +
    theme(plot.title = element_text(color = "white", size = 24, face = "bold", hjust = .5),
          axis.title.x = element_text(color = "white", size = 15, face = "bold"),
          axis.title.y = element_text(color = "white", size = 15, face = "bold"),
          axis.text.x = element_text(color = "white", size = 9, angle = 70, hjust = 1),
          axis.text.y = element_text(color = "white"),
          axis.ticks = element_blank(),
          legend.title = element_text(color = "white", size = 11, face = "bold"),
          panel.background = element_rect(fill = "#4A5D6D", color = "#EBF5FB"),
          panel.border=element_blank(),
          panel.grid.major=element_blank(),
          panel.grid.minor=element_blank(),
          plot.background=element_rect(fill = "#4A5D6D", color = "#4A5D6D"),
          legend.background = element_rect(fill="#4A5D6D", 
                                           size=0.5, linetype="solid"),
          legend.text = element_text(color = "white")) +
    labs(title = paste0(paste0(input$checkbox_tru, collapse = " and "), " Veterans Living ", 
      str_to_title(str_replace_all(input$select_charac, "_", " "))),
      y = paste0("Percent ", str_replace_all(input$select_charac, "_", " ")), x = "State")
  })
  
  output$note_text <- renderText({
    if (input$select_charac == "in_poverty"){
      paste("For some persons, such as unrelated individuals under age 15, poverty status is not 
            defined. Since Census Bureau surveys typically ask income questions to persons age 
            15 or older, if a child under age 15 is not related by birth, marriage, or adoption 
            to a reference person within the household, we do not know the child's income and 
            therefore cannot determine his or her poverty status. For the American Community 
            Survey, poverty status is also undefined for people living in college dormitories 
            and in institutional group quarters.")
    }
    else if (input$select_charac == "unemployed"){
      paste("This dataset includes employment information for working age veterans. Working 
            age is defined here as the population 18 to 64 years old.")
    }
    else if (input$select_charac == "uninsured"){
      paste("This dataset includes information on veterans with and without health insurance. 
            According to Veterans in Rural America: 2011–2015 American Community Survey Reports, 
            Not all veterans can use the VA healthcare system.
            Eligibility for using the VA healthcare system is based on veteran status, 
            service-connected disability status, income level, and other factors.")
    }
    else if (input$select_charac == "with_disability") {
      paste("This dataset considers veterans which have a VA service-connected disability
      rating, meaning that the VA detemined the veteran's injury or illness was incurred 
      or aggravated during active military service. When making a determination, the VA 
            considers the places, types, and circumstances of military service as 
            documented in veteran service records."
      )
    }
  })
}


shinyApp(ui = ui, server = server)
