# 🌍 Global Fertility Rate Animated Bar Chart Race

# RESULT IS HOSTED AT:- https://babafreevisuals.shinyapps.io/TEXT/

## Overview
This Shiny application visualizes **fertility rate trends across countries** from **1960 to 2023** using a dynamic, movie-like animated bar chart. The app emphasizes **accessibility** with color-blind friendly palettes and allows users to interactively explore fertility rate changes over time.

---

## Features
1. **Dynamic Bar Chart Race**
   - Countries move up or down in the ranking as their fertility rates change.
   - Highest fertility rates appear on top each year.
   - Smooth, rank-based transitions give a cinematic effect.

2. **Accessibility**
   - Uses the [`viridis`](https://cran.r-project.org/web/packages/viridis/index.html) palette for color-blind friendly and perceptually uniform colors.
   - Clear hover labels and large font sizes for readability.

3. **User Controls**
   - **Select Countries**: Choose which countries to display.
   - **Top N Countries**: Show only the top N countries per year.
   - **Animation Speed**: Slow, Normal, Fast options.
   - **Play/Pause/Step Controls**: Navigate through years manually or play continuously.

4. **Smooth Interpolation**
   - Fertility values are interpolated annually to ensure a continuous animation.
   - Missing or incomplete data is safely handled to prevent errors.

5. **Efficient Rendering**
   - Optimized to minimize system resource usage.
   - Only top N countries are displayed per frame.
   - Uses `group_modify()` for efficient data processing.

---

## Data
- The fertility rate data is **illustrative**, inspired by World Bank and World Development Indicators.
- Values represent **total fertility rate (births per woman)**.
- Countries included:
  - 🌍 World Average
  - 🇺🇸 United States
  - 🇷🇺 Russia
  - 🇵🇰 Pakistan
  - 🇳🇬 Nigeria
  - 🇮🇳 India
  - 🇮🇩 Indonesia
  - 🇪🇹 Ethiopia
  - 🇨🇳 China
  - 🇧🇷 Brazil
  - 🇧🇩 Bangladesh

---

## Dependencies
The app requires the following R packages:
- `shiny` – for the interactive web application
- `tidyverse` – for data manipulation
- `plotly` – for interactive and animated plots
- `viridis` – for color-blind friendly palettes

Install them using:

```r
install.packages(c("shiny", "tidyverse", "plotly", "viridis"))
