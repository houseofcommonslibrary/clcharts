# This is an example of how to make a scatter chart using the clcharts package.
#
# This script is self-contained: running it will create a PNG and an SVG of the
# example chart in the same directory. To run the script will need to ensure:
#
# 1. You have installed all of the packages that the script imports
# 2. You have the theme fonts set up on your computer
# 3. You have the dataset "scatter-chart.csv" in the same directory
#
# See the readme on GitHub to find out how to install the package and setup
# the fonts.
#
# To run the script, type the following code in your R console:
#
# source("scatter-chart.R")

# Imports ---------------------------------------------------------------------

library(tidyverse)
library(scales)
library(clcharts)

# Read in and prepare the data ------------------------------------------------

# Load the data from the csv as a dataframe
df <- read_csv("scatter-chart.csv")

# Turn the classification column into a factor: setting the order of the levels
# controls the order of the categories in the legend from top to bottom
settlement_classes <- c(
  "London",
  "Other city",
  "Large town",
  "Medium town",
  "Small town",
  "Village")

df$classification <- factor(df$classification, levels = settlement_classes)

# Create the plot -------------------------------------------------------------

# Use ggplot to create a plot with data and mappings
plot <- ggplot(
    data = df,
    mapping = aes(x = median_age, y = turnout, color = classification)) +
  # Add a point geometry to add points: set shape = 16 to match house style
  geom_point(
    shape = 16,
    size = 2) +
  # Set labels for the axes, colors and caption: DON'T set titles here
  labs(
    x = "Median age",
    y = "Turnout",
    color = "Settlement class",
    caption = "Source: House of Commons Library") +
  # Configure the the x and y axes: set the x axis limits; set the y axis
  # limits and the y axis labels to show percentages to the nearest percent,
  # turn off the expansion on both axes
  scale_x_continuous(
    limits = c(25, 55),
    expand = c(0, 0)) +
  scale_y_continuous(
    limits = c(0.5, 0.8),
    label = percent_format(accuracy = 1),
    expand = c(0, 0)) +
  # Add the Commons Library theme: we use the default axes settings and set
  # the gridlines to both horizontal and vertical
  theme_commonslib(grid = "hv") +
  # Use scale_color_manual and commonslib_color to set category colors
  scale_color_manual(values = c(
    "London" = commonslib_color("commons_green"),
    "Other city" = commonslib_color("ocean_green"),
    "Large town" = commonslib_color("grape"),
    "Medium town" = commonslib_color("lilac"),
    "Small town" = commonslib_color("tangerine"),
    "Village" = commonslib_color("burnt_orange")))

# After creating the plot, add a title and subtitle with add_commonslib_titles
plot <- add_commonslib_titles(
  plot,
  title = "Turnout was higher in older, less urban constituencies",
  subtitle = "Constituencies by age, turnout and settlement class, 2017")

# Save the plot in different formats ------------------------------------------

# Save a high resolution export of the plot as a png
save_png(
  "scatter-chart.png",
  plot = plot,
  width = 8,
  height = 5)

# Save an editable verson of the plot as an svg
save_svg(
  "scatter-chart.svg",
  plot = plot,
  width = 8,
  height = 5)
