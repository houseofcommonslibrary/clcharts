# This is an example of how to make a stacked bar chart using the clcharts
# package.
#
# This script is self-contained: running it will create a PNG and an SVG of the
# example chart in the same directory. To run the script will need to ensure:
#
# 1. You have installed all of the packages that the script imports
# 2. You have the theme fonts set up on your computer
# 3. You have the dataset "stacked-column-chart.csv" in the same directory
#
# See the readme on GitHub to find out how to install the package and setup
# the fonts.
#
# To run the script, type the following code in your R console:
#
# source("stacked-column-chart.R")

# Imports ---------------------------------------------------------------------

library(tidyverse)
library(clcharts)

# Read in and prepare the data ------------------------------------------------

# Load the data from the csv as a dataframe
df <- read_csv("stacked-column-chart.csv")

# Convert the year to character data: we don't want to treat this as a date or
# a number in this case, it is just a label for each bar
df$year <- as.character(df$year)

# Turn the nationality column into a factor: setting the order of the levels
# controls the order of the categories in each bar from top to bottom
df$nationality <- factor(df$nationality, levels = c("Non-EU", "EU", "British"))

# Create the plot -------------------------------------------------------------

# Use ggplot to create a plot with data and mappings
plot <- ggplot(
    data = df,
    mapping = aes(x = year, y = estimate, fill = nationality)) +
  # Add a col geometry for columns: use width = 0.8 to match house style;
  # geom_col will plot the values for each category
  geom_col(width = 0.8) +
  # Set labels for the axes, legend, and caption: DON'T set titles here
  labs(
    x = NULL,
    y = NULL,
    fill = NULL,
    caption = "Source: ONS, Provisional LTIM estimates") +
  # Configure the the x and y axes: we set the y axis breaks and limits, and
  # we turn off the y-axis expansion
  scale_x_discrete() +
  scale_y_continuous(
    limits = c(0, 700),
    breaks = seq(0, 700, 100),
    expand = c(0,0)) +
  # Add the Commons Library theme: we don't specify settings for the axes and
  # grid which means we are using the defaults; we set the legend and caption
  # positions
  theme_commonslib(
    legend_position = "top-right",
    caption_position = "left") +
  # Use scale_fill_manual and commonslib_color to set category colors
  scale_fill_manual(values = c(
    "British" = commonslib_color("tangerine"),
    "EU" = commonslib_color("commons_green"),
    "Non-EU" = commonslib_color("ocean_green")))

# After creating the plot, add a title and subtitle with add_commonslib_titles
plot <- add_commonslib_titles(
  plot,
  title = "Immigration is stable but the composition has changed",
  subtitle = "Immigration by nationality in each year ending September, Thousands")

# Save the plot in different formats ------------------------------------------

# Save a high resolution export of the plot as a png
save_png(
  "stacked-column-chart.png",
  plot = plot,
  width = 8,
  height = 5)

# Save an editable verson of the plot as an svg
save_svg(
  "stacked-column-chart.svg",
  plot = plot,
  width = 8,
  height = 5)
