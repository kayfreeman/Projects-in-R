library(shiny)
library(dplyr)
library(tidyr)
library(plotly)
library(viridis)

# --------------------------
# Data preparation
# --------------------------
fertility_data <- tribble(
  ~Country, ~`1960`, ~`1970`, ~`1980`, ~`1990`, ~`2000`, ~`2010`, ~`2020`, ~`2023`,
  "🌍 World Avg", 4.7, 4.8, 3.7, 3.3, 2.7, 2.6, 2.3, 2.2,
  "🇺🇸 U.S.", 3.7, 2.5, 1.8, 2.1, 2.1, 1.9, 1.6, 1.6,
  "🇷🇺 Russia", 2.5, 2.0, 1.9, 1.9, 1.2, 1.6, 1.5, 1.4,
  "🇵🇰 Pakistan", 6.8, 6.8, 6.7, 6.4, 5.4, 4.4, 3.8, 3.6,
  "🇳🇬 Nigeria", 6.4, 6.5, 6.8, 6.5, 6.1, 5.9, 4.7, 4.5,
  "🇮🇳 India", 5.9, 5.6, 4.8, 4.0, 3.4, 2.6, 2.0, 2.0,
  "🇮🇩 Indonesia", 5.5, 5.5, 4.5, 3.1, 2.5, 2.5, 2.2, 2.1,
  "🇪🇹 Ethiopia", 6.5, 6.8, 7.3, 7.2, 6.7, 5.3, 4.3, 4.0,
  "🇨🇳 China", 4.5, 6.1, 2.7, 2.5, 1.6, 1.7, 1.2, 1.0,
  "🇧🇷 Brazil", 6.1, 4.9, 4.0, 2.9, 2.2, 1.8, 1.7, 1.6,
  "🇧🇩 Bangladesh", 6.7, 6.8, 6.3, 4.5, 3.3, 2.4, 2.2, 2.2
)

fertility_long <- fertility_data %>%
  pivot_longer(cols = -Country, names_to = "Year", values_to = "Fertility") %>%
  mutate(Year = as.integer(Year))

# Compute ranks
ranked_data <- fertility_long %>%
  group_by(Year) %>%
  arrange(desc(Fertility)) %>%
  mutate(rank = row_number()) %>%
  ungroup()

# Assign viridis colors
country_colors <- viridis(n = nrow(fertility_data), option = "viridis")
names(country_colors) <- fertility_data$Country

# --------------------------
# Shiny UI
# --------------------------
ui <- fluidPage(
  titlePanel("🌍 Global Fertility Rate Dynamic Bar Race"),
  mainPanel(
    plotlyOutput("bar_race_plot", height = "700px")
  )
)

# --------------------------
# Shiny Server
# --------------------------
server <- function(input, output, session) {
  
  output$bar_race_plot <- renderPlotly({
    
    plot_ly(
      data = ranked_data,
      x = ~Fertility,
      y = ~rank,
      type = "bar",
      orientation = "h",
      color = ~Country,
      colors = country_colors,
      text = ~paste(Country, ":", Fertility),
      textposition = "outside",
      hoverinfo = "text",
      frame = ~Year
    ) %>%
      layout(
        yaxis = list(
          title = "",
          tickvals = NULL,
          autorange = "reversed"
        ),
        xaxis = list(title = "Fertility Rate", range = c(0, 8)),
        showlegend = FALSE,
        title = "🌍 Global Fertility Rate Dynamic Bar Race"
      ) %>%
      animation_opts(
        frame = 1500,
        transition = 1200,
        redraw = FALSE
      ) %>%
      animation_slider(currentvalue = list(prefix = "Year: "))
  })
}

# --------------------------
# Run the app
# --------------------------
shinyApp(ui, server)
