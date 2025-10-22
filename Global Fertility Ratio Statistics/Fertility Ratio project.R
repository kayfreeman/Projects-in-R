# ==============================================================
# 🌍 Accessible Fertility Rate Movie-Like Bar Race Visualization
# --------------------------------------------------------------
# Author: Adeyinka Freeman (Modified)
# Description:
#   This Shiny app visualizes fertility rate trends across countries
#   from 1960–2023 using a movie-like animated bar chart.
#   Countries and fertility values are shown directly on bars.
# ==============================================================

# -----------------------------
# 1. Load Required Libraries
# -----------------------------
library(shiny)
library(tidyverse)
library(plotly)
library(viridis)

# -----------------------------
# 2. Prepare Fertility Data
# -----------------------------
data <- tribble(
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

data_long <- data %>%
  pivot_longer(-Country, names_to = "Year", values_to = "Fertility") %>%
  mutate(Year = as.numeric(Year))

# -----------------------------
# 3. UI Definition
# -----------------------------
ui <- fluidPage(
  titlePanel("🌍 Accessible Fertility Rate Movie-Like Bar Race"),
  
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput(
        inputId = "countries",
        label = "Select Countries:",
        choices = unique(data_long$Country),
        selected = unique(data_long$Country)
      ),
      sliderInput(
        inputId = "topN",
        label = "Show Top N Countries by Fertility:",
        min = 1, max = nrow(data), value = nrow(data), step = 1
      )
    ),
    
    mainPanel(
      plotlyOutput("barMovie", height = "600px")
    )
  )
)

# -----------------------------
# 4. Server Logic
# -----------------------------
server <- function(input, output, session) {
  
  filteredData <- reactive({
    sel <- input$countries
    if (is.null(sel) || length(sel) == 0) sel <- unique(data_long$Country)
    data_long %>% filter(Country %in% sel)
  })
  
  output$barMovie <- renderPlotly({
    df <- filteredData()
    if (nrow(df) == 0) return(NULL)
    
    # Smooth interpolation between years
    smooth_df <- df %>%
      group_by(Country) %>%
      arrange(Year) %>%
      summarise(
        Year_smooth = seq(min(Year), max(Year), by = 0.5),
        Fertility_smooth = approx(Year, Fertility, xout = seq(min(Year), max(Year), by = 0.5))$y,
        .groups = "drop"
      )
    
    # Add Country back for correct bar labeling
    smooth_df <- smooth_df %>%
      group_by(Year_smooth) %>%
      mutate(rank = rank(-Fertility_smooth)) %>%
      ungroup()
    
    topN <- input$topN
    smooth_df <- smooth_df %>%
      group_by(Year_smooth) %>%
      arrange(desc(Fertility_smooth)) %>%
      slice_head(n = topN) %>%
      ungroup()
    
    # Color palette
    countries_unique <- unique(smooth_df$Country)
    color_palette <- viridis(length(countries_unique))
    names(color_palette) <- countries_unique
    
    # Final plot
    plot_ly(
      smooth_df,
      x = ~Fertility_smooth,
      y = ~reorder(Country, Fertility_smooth),
      type = 'bar',
      orientation = 'h',
      frame = ~Year_smooth,
      color = ~Country,
      colors = color_palette,
      text = ~paste0(Country, ": ", round(Fertility_smooth, 2)),
      textposition = "inside",
      hoverinfo = 'text',
      hovertext = ~paste0(
        "<b>", Country, "</b>",
        "<br><b>Year:</b> ", round(Year_smooth, 1),
        "<br><b>Fertility Rate:</b> ", round(Fertility_smooth, 2)
      )
    ) %>%
      layout(
        title = "Accessible Global Fertility Rate Animation (1960–2023)",
        xaxis = list(title = "Fertility Rate (births per woman)", range = c(0, 8)),
        yaxis = list(title = "", showticklabels = FALSE),  # Hide y-axis labels
        margin = list(l = 80, r = 50, t = 80, b = 60)
      ) %>%
      animation_opts(
        frame = 50,
        transition = 0,
        redraw = TRUE
      ) %>%
      animation_slider(
        currentvalue = list(prefix = "Year: ")
      )
  })
}

# -----------------------------
# 5. Launch Shiny App
# -----------------------------
shinyApp(ui, server)
