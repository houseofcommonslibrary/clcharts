# This is an example of how to make a column chart with labels using the
# clcharts package.
#
# This script is self-contained: running it will create a PNG and an SVG of the
# example chart in the same directory. To run the script will need to ensure:
#
# 1. You have installed all of the packages that the script imports
# 2. You have the theme fonts set up on your computer
# 3. You have the dataset "column-chart-labels.csv" in the same directory
#
# See the readme on GitHub to find out how to install the package and setup
# the fonts.
#
# To run the script, type the following code in your R console:
#
# source("column-chart-labels.R")

# Imports ---------------------------------------------------------------------

library(tidyverse)
library(clcharts)

# Read in and prepare the data ------------------------------------------------

# Load the data from the csv as a dataframe
df <- read_csv("column-chart-labels.csv")

# Turn the region column into a factor and order it by the number of items in
# each region: this sorts the columns in the chart from largest to smallest
df$region <- factor(df$region)
df$region <- fct_rev(reorder(df$region, df$region, length))

# Create the plot -------------------------------------------------------------

# Use ggplot to create a plot with data
plot <- ggplot(data = df) +
  # Add a bar geometry for columns: use width = 0.8 to match house style;
  # geom_bar will plot the number of items in each category;
  # we set the fill color in geom_bar as color does not represent data
  geom_bar(
    mapping = aes(x = region),
    width = 0.8,
    fill = commonslib_color("commons_green")) +
  # Add a text geometry for labels: geom_text_commonslib uses the right fonts
  geom_text_commonslib(
    mapping = aes(x = region, label = ..count..),
    stat = "count",
    vjust = "top",
    nudge_y = -3) +
  # Set labels for the axes and caption: DON'T set titles here
  labs(
    x = "Country or region",
    y = "Number of constituencies",
    caption = "Source: House of Commons Library") +
  # Configure the the x and y axes: we remove the expansion for the y axis
  scale_x_discrete() +
  scale_y_continuous(expand = c(0,0)) +
  # Add the Commons Library theme: we set a bottom axis, horizontal
  # gridlines, and set the caption on the left
  theme_commonslib(
    axes = "b",
    grid = "h",
    caption_position = "left")

# After creating the plot, add a title and subtitle with add_commonslib_titles
plot <- add_commonslib_titles(
  plot,
  title = "Countries and regions vary in representation",
  subtitle = "Constituencies by country or region, United Kingdom")

# Save the plot in different formats ------------------------------------------

# Save a high resolution export of the plot as a png
save_png(
  "column-chart-labels.png",
  plot = plot,
  width = 8,
  height = 5)

# Save an editable verson of the plot as an svg
save_svg(
  "column-chart-labels.svg",
  plot = plot,
  width = 8,
  height = 5)
