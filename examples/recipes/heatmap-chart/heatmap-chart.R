# This is an example of how to make a heatmap chart using the clcharts package.
#
# This script is self-contained: running it will create a PNG and an SVG of the
# example chart in the same directory. To run the script will need to ensure:
#
# 1. You have installed all of the packages that the script imports
# 2. You have the theme fonts set up on your computer
# 3. You have the dataset "heatmap-chart.csv" in the same directory
#
# See the readme on GitHub to find out how to install the package and setup
# the fonts.
#
# To run the script, type the following code in your R console:
#
# source("heatmap-chart.R")

# Imports ---------------------------------------------------------------------

library(tidyverse)
library(clcharts)

# Read in and prepare the data ------------------------------------------------

# Load the data from the csv as a dataframe
df <- read_csv("heatmap-chart.csv")

# Pivot dataframe from wide to long
df <- df %>%
  pivot_longer(-authority, names_to = "year", values_to = "control")

# Create plot -----------------------------------------------------------------

# Use ggplot to create a plot with data and mappings
plot <- ggplot(
    data = df,
    mapping = aes(x = year, y = authority)) +
  # Add a tile geometry for map: geom_tile will plot the values
  # for each category, and colour "#dad5d1" to match plot background
  geom_tile(
    mapping = aes(fill = control),
    colour = "#dad5d1") +
  # Add a text geometry for labels: geom_text_commonslib uses the right fonts
  geom_text_commonslib(
    mapping = aes(label = control),
    size = 2) +
  # Set labels for the axes, legend, and caption: DON'T set titles here
  labs(
    x = NULL,
    y = NULL,
    caption = str_c("Source: Rallings and Thrasher, Local Elections in ",
    "Britain; House of Commons Library")) +
  # Configure the x and y axes: we set the x axis to be at the top of the
  # chart and y axis limits so that authority names appear in alphabetical
  # order top to bottom
  scale_x_discrete(position = "top") +
  scale_y_discrete(limits = rev(levels(as.factor(df$authority)))) +
  # Use scale_fill_manual and commonslib_party_color to set category colors
  scale_fill_manual(values = c(
    "CON" = commonslib_party_color("conservative"),
    "LAB" = commonslib_party_color("labour"),
    "LD" = commonslib_party_color("lib_dem"),
    "NOC" = commonslib_party_color("other"))) +
  # Add the Commons Library theme: we don't specify settings for the grid
  # which means we are using the defaults; we set the legend, caption
  # positions, and axes
  theme_commonslib(
    legend_position = "none",
    caption_position = "right",
    axes = "")

# After creating the plot, add a title and subtitle with add_commonslib_titles
plot <- add_commonslib_titles(
  plot,
  title = "Labour controlled the most London councils in 2018",
  subtitle = "London council control immediately after local elections")

# Save the plot in different formats ------------------------------------------

# Save a high resolution export of the plot as a png
save_png(
  "heatmap-chart.png",
  plot = plot,
  width = 8,
  height = 8)

# Save an editable verson of the plot as an svg
save_svg(
  "heatmap-chart.svg",
  plot = plot,
  width = 8,
  height = 8)

