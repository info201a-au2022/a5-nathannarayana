library("shiny")
library("ggplot2")
library("plotly")
library("dplyr")
library("tidyverse")

data <- read.csv("https://raw.githubusercontent.com/owid/co2-data/master/owid-co2-data.csv")

# Highest GDP country
max_gdp_country <- data %>%
  filter(country != "World") %>%
  filter(gdp == max(gdp, na.rm = TRUE)) %>%
  pull(country)
print(max_gdp_country)

# What is that GDP value?
max_gdp <- data %>%
  filter(country != "World") %>%
  filter(gdp == max(gdp, na.rm = TRUE)) %>%
  pull(gdp)
print(max_gdp)

# When did China have the highest GDP?
max_year <- data %>%
  filter(country != "World") %>%
  filter(gdp == max(gdp, na.rm = TRUE)) %>%
  pull(year)
print(max_year)

# Relation between GDP and co2 emissions
gdp_co2 <- data %>%
  filter(country != "World") %>%
  group_by(country) %>%
  filter(gdp == max(gdp, na.rm = TRUE)) %>%
  summarise(country, gdp, co2_per_gdp)

# Server Logic
shinyServer(function(input, output) {
  
  input_data <- reactive({
    gdp_co2 %>%
      filter(country %in% input$country)
  })
  
  output$dot <- renderPlotly({
    ggplotly(ggplot(gdp_co2) +
      geom_point(mapping = aes(
        x = gdp,
        y = co2_per_gdp,
        fill = country)) +
          labs(
            title = "GDP vs co2 per capita",
            x = "GDP in USD",
            y = "co2 Per Capita (Tonnes)"))
  })
})

