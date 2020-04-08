library(shiny)
library(tidyverse)
library(maps)
library(shinythemes)
library(mapproj)

theme_custom <- function() {
  theme_light() +
  theme(plot.title = element_text(color = "white", size = 24, face = "bold", hjust = .5),
        plot.subtitle = element_text(color = "white", size = 15, hjust = .5),
          axis.title.x = element_text(color = "white", size = 15, face = "bold"),
          axis.title.y = element_text(color = "white", size = 15, face = "bold"),
          axis.text.x = element_text(color = "white", size = 15, face = "bold"),
          axis.text.y = element_text(color = "white"),
          axis.ticks = element_blank(),
          legend.title = element_text(color = "white", size = 11, face = "bold"),
          panel.background = element_rect(fill = "#4A5D6D", color = "#4A5D6D"),
          panel.border=element_blank(),
          panel.grid.major=element_blank(),
          panel.grid.minor=element_blank(),
          plot.background=element_rect(fill = "#4A5D6D", color = "#4A5D6D"),
          legend.background = element_rect(fill="#4A5D6D",size=0.5, linetype="solid"),
          legend.text = element_text(color = "white"))
}

vets <- read_csv("data/rural_vets_complete_clean.csv")
cols <- c("Rural" = "#F4200B", "Urban" = "#2C0A90", "Total" = "#F4D03F",
          "West" = "#E67E22", "Midwest" = "#F1C40F", "Northeast" = "#C0392B", 
          "South" = "#2980B9")
cols2 <- c("Rural" = "white", "Urban" = "black")
us_map <- map_data("state")

ui <- fluidPage(theme = shinytheme("superhero"),
                navbarPage(title = "Rural U.S. Veterans",
                           tabPanel("Federal",
                                    sidebarLayout(
                                      sidebarPanel(
                                        h2("Where are America's rural veterans?"),
                                        h4("Explore geographic patterns and compare urban and rural distributions"),
                                        checkboxGroupInput(inputId = "checkbox_tru",
                                                  label   = "Select which veterans to display:",
                                                  choices = list("Rural", "Urban"),
                                                  selected = "Rural",
                                                  inline = TRUE),
                                        br(),
                                        br(),
                                        h2("What challenges do these veterans face?"),
                                        h4("Explore regional and state level differences"),
                                        radioButtons(inputId = "select_charac",
                                                    label = "Select characteristic of interest:",
                                                    choices = list("Insurance" = "uninsured",
                                                                   "Disability" = "with_disability",
                                                                   "Poverty" = "in_poverty", 
                                                                   "Unemployment" = "unemployed"
                                                                   ),
                                                    select = "uninsured"),
                                        br(),
                                        h4("Notes"),
                                        textOutput(outputId = "note_text"),
                                        tags$head(tags$style("#note_text{color: white;
                                                              font-size: 16px;
                                                              font-style: italic;
                                                              }")
                                        )
                                      ),
                                     mainPanel(
                                       fluidRow(
                                         plotOutput(outputId = "usvets_map", width = "925px", 
                                                  height = "504px")),
                                       br(),
                                       fluidRow(
                                       plotOutput(outputId = "poverty_plot", width = "800px",
                                                  height = "400px"), align = "center"),
                                       br()
                                    )
                                    )),
                           tabPanel("State",
                                    fluidRow(
                                        column(width = 3,
                                               h3("Explore veteran characteristics by state"),
                                        selectInput(inputId = "select_state",
                                                    label = "Choose a state",
                                                    choices = state.name,
                                                    selected = "Alaska"),
                                        br()),
                                        column(width = 6,
                                               br(),
                                               br(),
                                               br(),
                                               br(),
                                               br(),
                                        p(
                                          textOutput(outputId = "state_rural_text1", inline = TRUE),
                                          textOutput(outputId = "state_rural_text2", inline = TRUE)),
                                        tags$head(tags$style("#state_rural_text1{color: red;
                                                              font-size: 24px;
                                                              font-style: bold;
                                                              }")),
                                        br())
                                        ),
                                    fluidRow(
                                      column(width = 4, 
                                             plotOutput(outputId = "state_disability_plot"),
                                             br(),
                                             p(
                                               textOutput(outputId = "state_disability_text1", inline = TRUE),
                                               textOutput(outputId = "state_disability_text2", inline = TRUE)),
                                             tags$head(tags$style("#state_disability_text1{color: red;
                                                              font-size: 24px;
                                                              font-style: bold;
                                                              }"))),
                                      column(width = 4,
                                            plotOutput(outputId = "state_insurance_plot"),
                                            br(),
                                            p(
                                              textOutput(outputId = "state_insurance_text1", inline = TRUE),
                                              textOutput(outputId = "state_insurance_text2", inline = TRUE)),
                                            tags$head(tags$style("#state_insurance_text1{color: red;
                                                              font-size: 24px;
                                                              font-style: bold;
                                                              }"))),
                                      column(width = 4, 
                                        plotOutput(outputId = "state_poverty_plot"),
                                        br(),
                                        p(
                                          textOutput(outputId = "state_poverty_text1", inline = TRUE),
                                          textOutput(outputId = "state_poverty_text2", inline = TRUE)),
                                        tags$head(tags$style("#state_poverty_text1{color: red;
                                                              font-size: 24px;
                                                              font-style: bold;
                                                              }"))),
                                                       )
                                    ),
                           tabPanel("Customized Search", 
                                    fluidRow(column(width = 2, 
                                                    br(),
                                                    h4("Find states where over")),
                                             column(width = 2,
                                             textInput(inputId = "search_percent",
                                                       label = "Enter a number between 0 and 100",
                                                       value = 6)),
                                             column(width = 1,
                                                    br(),
                                             h4("% of ")),
                                             column(width = 2,
                                             selectInput(inputId = "search_ru",
                                                         label = "Choose geography",
                                                         choices = list("all" = "Total", 
                                                                        "urban" = "Urban", 
                                                                        "rural" = "Rural"))),
                                             column(width = 2,
                                                    br(),
                                             h4("veterans are")),
                                             column(width = 2,
                                             selectInput(inputId = "search_charac",
                                                         label = "Choose a characteristic",
                                                         choices = list("without health insurance" = "uninsured",
                                                                        "living with a service-connected disability" = "with_disability",
                                                                        "in poverty" = "in_poverty", 
                                                                        "unemployed" = "unemployed"))),
                                             fluidRow(
                                             DT::dataTableOutput(outputId = "search_results"),
                                             tags$head(tags$style("#search_results{color: black}")
                                             )))),
                           tabPanel("Background",
                                    column(width = 2),
                                    column(width = 8,
                                           h1("Introduction"),
                                           h4("from American Community Survey Reports"),
                                           h5("by Kelly Ann Holder"),
                                           p("Twenty million veterans live in the United States. They live in every state and in nearly every county across the nation. About 5 million veterans lived in areas designated as rural by the U.S. Census Bureau during the 2011–2015 period. Understanding who rural veterans are and what sets them apart from other veterans, as well as from their rural neighbors, provides the necessary perspective for rural communities, government agencies, veterans’ advocates, and other policymakers interested in directing programs and services to this population."),
                                           p("The U.S. Department of Veterans Affairs (VA) has identified veterans living in rural areas as a population of interest. To help address concerns of veterans’ access to care, Congress established the Office of Rural Health within the VA in 2007. One challenge in these efforts is that most of the data available to the VA come only from rural veterans enrolled in their healthcare system, and not all veterans are enrolled. However, to anticipate demand for care, as well as to understand what types of services may be requested or utilized, requires data on all rural veterans."),
                                           p("This brief aims to answer the question “Who are rural veterans?” by considering the demographic, social, and economic characteristics of rural veterans compared with both urban veterans as well as with rural nonveterans. It also examines rural veterans by the level of rurality of their county of residence to understand some of the impact of geography on their characteristics. The data used in this report are primarily from 2011–2015 American Community Survey (ACS), 5-year estimates. This report presents statistics about veterans and, where applicable, nonveterans 18 years and older living in rural and urban areas of the United States."),
                                           p("REPORT NUMBER ACS-36"),
                                           h1("Health of Rural Veterans"),
                                           p("According to the ACS brief, veterans have a unique source of public healthcare coverage available to them through the VA. Eligibility for using the VA healthcare system is based on veteran status, service-connected disability status, income level, and other factors. Not all veterans can use the VA healthcare system. Veterans with a service-connected disability are in the highest enrollment priority groups in the VA healthcare system, depending on their disability rating. Priority enrollment may make them more likely to use VA. They may also prefer the quality of specialized services that are more difficult to obtain at non-VA facilities."),
                                           p("Rural residents living  with disabilities face unique barriers and significant disadvantages when accessing healthcare, according to the Rural Health Information Hub. Some of these barriers include geographic isolation, qualified provider shortages, and the built environment characteristics of the local health clinic."),
                                           p("It is important to consider both the realities of health insurance coverage for veterans and the challenges that disabled veterans face, especially in rural areas. Poverty and employment status are also factors which can have a significant effect on insurance status. This application provides the opportunity to look at poverty, unemployment, service-connected disability, and health insurance rates for veterans across the United States. It facilitates the comparison of rural and urban veterans to enable policymakers to learn about who rural veterans are, within context."),
                                           h1("Importance of a State-Level Lens"),
                                           p("In 2014, a scandal at the Department of Veterans Affairs exposed “massive wait times for veterans at VA campuses across the country, false record keeping, and lapses in care,” according to the Intercept. As a result of what they saw as a federal failure to take care of the nation’s veterans, state lawmakers began planning to introduce a “Veterans Bill of Rights” in their legislative bodies in 2019."),
                                           p("Observing veteran characteristics on the state level will allow policymakers to notice the interactions between factors such as veterans’ rurality, health insurance coverage, disability, and poverty in order to better address the specific needs of veterans in their states."),
                                           h1("References"),
                                           p("The Intercept, Lawmakers From 11 States Have A Plan To Tackle Suicide And Other Issues Veterans Face, by Akela Lacy"),
                                           p("https://theintercept.com/2019/05/28/veterans-bill-of-rights/"),
                                           p("Rural Health Information Hub, Barriers to Accessing Care for Rural People with Disabilities"),
                                           p("https://www.ruralhealthinfo.org/toolkits/disabilities/1/barriers"),
                                           p("Data Source: U.S. Census Bureau, 2011-2015 American Community Survey, 5-year estimates."),
                                           p("For more information about ACS, see www.census.gov/programs-surveys/acs/")
                                    ))
                           
                           ))


server <- function(input, output) {
  output$usvets_map <- renderPlot({
    
    x_map <- vets %>%
      filter(rural_urban %in% input$checkbox_tru, state != "Alaska", state != "Hawaii") %>%
      mutate(rural_urban = fct_relevel(rural_urban, c("Total", "Urban", "Rural")))
    
    # create visualization
  
    ggplot() + 
      geom_polygon(data = us_map, aes(x=long, y=lat, group=group),
                   color="#85C1E9", fill = "#EBF5FB") +
      geom_point(data = x_map, aes(x = center_lat, y = center_long, size = total, 
                                   color = rural_urban, alpha = .7)) +
      scale_size_continuous(range=c(1,30), guide = FALSE) +
      scale_color_manual(values = cols, name = "Urban/Rural") +
      scale_alpha_continuous(guide = FALSE) +
      coord_map() +
      labs(title = paste0(paste0(input$checkbox_tru, collapse = " and "), 
                          " Veterans in the US, by State"), subtitle = "2011-2015") +
      theme_custom() +
      theme(plot.title = element_text(color = "white", size = 22, face = "bold", hjust = .5),
            axis.line=element_blank(),
            axis.text.x=element_blank(),
            axis.text.y=element_blank(),
            axis.ticks=element_blank(),
            axis.title.x=element_blank(),
            axis.title.y=element_blank(),
            panel.border=element_blank(),
            panel.grid.major=element_blank(),
            panel.grid.minor=element_blank())
    
    
  })
  output$poverty_plot <- renderPlot({
    vets %>%
    filter(rural_urban %in% input$checkbox_tru) %>%
    ggplot(aes_string(x = paste0("reorder(state, -", input$select_charac, ")"), 
                      y = input$select_charac, fill = "region")) +
    geom_bar(stat = "identity") +
    scale_fill_manual(values = cols, name = "Region") +
    theme_custom() +
    theme(axis.text.x = element_text(color = "white", size = 9, angle = 70, hjust = 1)) +
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
            not all veterans can use the VA healthcare system.
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
  
  # For state tab
  
  output$state_disability_plot <- renderPlot({
    
    x_state <- vets %>%
      filter(state == input$select_state)
    
    x_state %>%
      filter(rural_urban != "Total") %>%
      ggplot(aes(x = rural_urban, y = with_disability, fill = rural_urban)) +
      scale_fill_manual(values = cols) +
      geom_bar(stat = "identity") +
      theme_custom() +
      theme(axis.title.x = element_blank(),
            legend.position = "none") +
      labs(title = paste0("Disabled Vets in ", input$select_state), y = "Percent with 
           service-connected disability")
  })
  
  output$state_insurance_plot <- renderPlot({
    x_state <- vets %>%
      filter(state == input$select_state)
    
    x_state %>%
      filter(rural_urban != "Total") %>%
      ggplot(aes(x = rural_urban, y = uninsured, fill = rural_urban)) +
      scale_fill_manual(values = cols) +
      geom_bar(stat = "identity") +
      theme_custom() +
      theme(axis.title.x = element_blank(),
            legend.position = "none") +
      labs(title = paste0("Uninsured Vets in ", input$select_state), y = "Percent uninsured")
  })
  
  output$state_poverty_plot <- renderPlot({
    x_state <- vets %>%
      filter(state == input$select_state)
    
    x_state %>%
      filter(rural_urban != "Total") %>%
      ggplot(aes(x = rural_urban, y = in_poverty, fill = rural_urban)) +
      scale_fill_manual(values = cols) +
      geom_bar(stat = "identity") +
      theme_custom() +
      theme(axis.title.x = element_blank(),
            legend.position = "none") +
      labs(title = paste0("Impoverished Vets in ", input$select_state), y = "Percent in poverty")
  })
  
  output$state_disability_text1 <- renderText({
      x_state <- vets %>%
        filter(state == input$select_state)
    
      percent_disabled <- (x_state[which(x_state$rural_urban == "Rural"),]$total * 
                             x_state[which(x_state$rural_urban == "Rural"),]$with_disability / 100 / 
                             (x_state[which(x_state$rural_urban == "Total"),]$total * 
                                x_state[which(x_state$rural_urban == "Total"),]$with_disability 
                              / 100) * 100)
      
      paste0(round(percent_disabled, 2), "%")
    
  })
  
  output$state_disability_text2 <- renderText({
    paste0(" of ", input$select_state, "'s diabled veterans live in rural areas.")
    
  })
  
  output$state_insurance_text1 <- renderText({
    x_state <- vets %>%
      filter(state == input$select_state)
    
    percent_uninsured <- (x_state[which(x_state$rural_urban == "Rural"),]$total * 
                           x_state[which(x_state$rural_urban == "Rural"),]$uninsured / 100 / 
                           (x_state[which(x_state$rural_urban == "Total"),]$total * 
                              x_state[which(x_state$rural_urban == "Total"),]$uninsured 
                            / 100) * 100)
    
    paste0(round(percent_uninsured, 2), "%")
    
  })
  
  output$state_insurance_text2 <- renderText({
      paste0(" of ", input$select_state, "'s uninsured veterans live in rural areas.")
  })
  
  output$state_poverty_text1 <- renderText({
    x_state <- vets %>%
      filter(state == input$select_state)
    
    percent_poverty <- (x_state[which(x_state$rural_urban == "Rural"),]$total * 
                           x_state[which(x_state$rural_urban == "Rural"),]$in_poverty / 100 / 
                           (x_state[which(x_state$rural_urban == "Total"),]$total * 
                              x_state[which(x_state$rural_urban == "Total"),]$in_poverty 
                            / 100) * 100)
    
    paste0(round(percent_poverty, 2), "%")
    
  })
  
  output$state_poverty_text2 <- renderText({
    paste0(" of ", input$select_state, "'s impoverished veterans live in rural areas.")
  })
  
  output$state_rural_text1 <- renderText({
    x_state <- vets %>%
      filter(state == input$select_state)
    
    percent_rural <- (x_state[which(x_state$rural_urban == "Rural"),]$total / 
                          x_state[which(x_state$rural_urban == "Total"),]$total ) * 100
    
    paste0(round(percent_rural, 2), "%")
    
  })
  
  output$state_rural_text2 <- renderText({
    paste0(" of ", input$select_state, "'s veterans live in rural areas.")
  })
  
  output$search_results <- DT::renderDataTable({
    table <- vets %>%
      filter(rural_urban == input$search_ru, get(input$search_charac) > input$search_percent) %>%
      select(state, total, in_poverty, unemployed, uninsured, with_disability) %>%
      arrange(desc(get(input$search_charac)))
    
    table <- subset(table, select=c(1:2, get(input$search_charac), 3:6))
    
    table <- table %>%
      subset(select=which(!duplicated(names(.)))) 
    
    table <- table %>%
      rename("State" = state, "Veteran Population" = total, "% Uninsured" = uninsured, 
             "% in Poverty" = in_poverty, "% Unemployed" = unemployed, 
             "% With VA Disability" = with_disability)
    table
  })
  
}


shinyApp(ui = ui, server = server)
