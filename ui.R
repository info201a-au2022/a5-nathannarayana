library("shiny")
library("ggplot2")
library("plotly")
library("dplyr")
library("tidyverse")

intro_page <- tabPanel("Introduction",
  h1("GDP vs CO2 Emissions and Energy Output"),
  p("In this report, we will be analyzing the correlation between a country's GDP
    and its co2 emissions, more specifically, how does the GDP affect the output of co2.
    The data is gathered from \"owid\" dataset available on their github repository."),
  p("The three values of interest are GDP, co2 per GDP, and energy per GDP. These values are
    used to answer the questions,"),
  p("Where and when was the GDP the highest?"),
  p("How does GDP affect co2 emissions? and,"),
  p("Why do some countries have high co2 output with low GDP?"),
  p("These questions are important as we are now able to hold countries accountable
    for the massive output of co2 and energy, and perhaps find a way to reduce those
    energy consumption.")
)


data <- read.csv("https://raw.githubusercontent.com/owid/co2-data/master/owid-co2-data.csv")

gdp_co2 <- data %>%
  filter(country != "World") %>%
  group_by(country) %>%
  filter(gdp == max(gdp, na.rm = TRUE)) %>%
  summarise(country, gdp, co2_per_gdp)

chart <- tabPanel("Dot Plot",
                  h1("GDP vs CO2 Emissions"),
        sidebarPanel(
          selectizeInput(
          inputId = "Country",
          label = "Select a Country",
          choices = c(gdp_co2$country),
          selected = "United States",
          multiple = TRUE),
        plotlyOutput('dot'),
        )
)

ui <- navbarPage(
  "Assignment 5",
  intro_page,
  chart
)