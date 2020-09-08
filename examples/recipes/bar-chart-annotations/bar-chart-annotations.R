# This is an example of how to make a bar chart using the clcharts package.
#
# This script is self-contained: running it will create a PNG and an SVG of the
# example chart in the same directory. To run the script will need to ensure:
#
# 1. You have installed all of the packages that the script imports
# 2. You have the theme fonts set up on your computer
# 3. You have the dataset "bar-chart-annotations.csv" in the same directory
#
# See the readme on GitHub to find out how to install the package and setup
# the fonts.
#
# To run the script, type the following code in your R console:
#
# source("bar-chart-annotations.R")

# Imports ---------------------------------------------------------------------

library(tidyverse)
library(clcharts)

# Read in and prepare the data ------------------------------------------------

# Load the data from the csv as a dataframe
df <- read_csv("bar-chart-annotations.csv")

# Turn the region column into a factor and order it by the number of premises
# in each region: this sorts the bars in the chart from largest to smallest
df$region <- factor(df$region)
df$region <- reorder(df$region, df$premises)

# Divide premises by one million to get the value in millions
df$premises = df$premises / 1000000

# Create the plot -------------------------------------------------------------

# Use ggplot to create a plot with data and mappings
plot <- ggplot(
    data = df,
    mapping = aes(x = region, y = premises)) +
  # Add a col geometry for columns: use width = 0.8 to match house style;
  # geom_col will plot the values for each region;
  # we set the fill color in geom_bar as color does not represent data
  geom_col(
    width = 0.8,
    fill = commonslib_color("commons_green")) +
  # Set labels for the axes, legend, and caption: DON'T set titles here
  labs(
    x = NULL,
    y = NULL) +
  # Configure the the x and y axes: we set the y axis breaks and limits, and
  # we turn off the y-axis expansion
  scale_x_discrete() +
  scale_y_continuous(
    limits = c(0, 4.5),
    breaks = seq(0, 4, 1),
    expand = c(0,0)) +
  # Use the coord_flip function to flip the axes: this will turn a vertical
  # column chart into a horizontal bar chart
  coord_flip() +
  # Use annotate_commonslib to add annotations to a plot: this function does
  # the same thing as annotate but it automatically sets the fonts to match
  # the house style; position each annotation using values on the axis scales
  annotate_commonslib(
    x = 0.58,
    y = 3.5,
    label = "Millions",
    size = 4.5) +
  # Add the Commons Library theme: we turn off the axes and set gridlines to
  # vertical
  theme_commonslib(
    axes = "",
    grid = "v")

# After creating the plot, add a title and subtitle with add_commonslib_titles
plot <- add_commonslib_titles(
  plot,
  title = "There were fewer premises in the North East",
  subtitle = "Number of premises by English region")

# Save the plot in different formats ------------------------------------------

# Save a high resolution export of the plot as a png
save_png(
  "bar-chart-annotations.png",
  plot = plot,
  width = 6,
  height = 5)

# Save an editable verson of the plot as an svg
save_svg(
  "bar-chart-annotations.svg",
  plot = plot,
  width = 6,
  height = 5)
