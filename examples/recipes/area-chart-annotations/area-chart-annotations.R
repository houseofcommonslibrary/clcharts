# This is an example of how to make an area chart with annotations using the
# clcharts package.
#
# This script is self-contained: running it will create a PNG and an SVG of the
# example chart in the same directory. To run the script will need to ensure:
#
# 1. You have installed all of the packages that the script imports
# 2. You have the theme fonts set up on your computer
# 3. You have the dataset "area-chart-annotations.csv" in the same directory
#
# See the readme on GitHub to find out how to install the package and setup
# the fonts.
#
# To run the script, type the following code in your R console:
#
# source("area-chart-annotations.R")

# Imports ---------------------------------------------------------------------

library(tidyverse)
library(scales)
library(clcharts)

# Read in and prepare the data ------------------------------------------------

# Load the data from the csv as a dataframe and pivot it into a tidy format
df <- read_csv("area-chart-annotations.csv") %>%
    pivot_longer(
        cols = -date,
        names_to = "care_setting",
        values_to = "number")

# Turn the care_setting column into a factor: setting the order of the levels
# controls the order of the categories from top to bottom
df$care_setting <- factor(df$care_setting, levels = c("neonatal", "maternity"))

# Create the plot -------------------------------------------------------------

# Use ggplot to create a plot with data and mappings
plot <- ggplot(
        data = df,
        mapping = aes(x = date, y = number, fill = care_setting)) +
    # Add an area geometry to fill areas based on the data
    geom_area() +
    # Set labels for the axes: DON'T set titles here
    labs(
        x = NULL,
        y = NULL) +
    # Configure the the x and y axes: we set the y axis breaks and limits, and
    # we turn off the expansion on both axes
    scale_x_date(
        expand = c(0, 0)) +
    scale_y_continuous(
        label = comma,
        limits = c(0, 9000),
        breaks = seq(0, 9000, 3000),
        expand = c(0, 0)) +
    # Use annotate_commonslib to add annotations to a plot: this function does
    # the same thing as annotate but it automatically sets the fonts to match
    # the house style; position each annotation using values on the axis scales
    annotate_commonslib(
        x = as.Date("2015-01-01"),
        y = 5500,
        label = "Neonatal nurses",
        color = "#202020",
        hjust = 0) +
    annotate_commonslib(
        x = as.Date("2015-01-01"),
        y = 1500,
        label = "Maternity nurses",
        color = "#ffffff",
        hjust = 0) +
    # Add the Commons Library theme: we use the default axes settings, set
    # gridlines to horizontal, and turn off the legend
    theme_commonslib(
        grid = "h",
        legend_position = "none") +
    # Use scale_fill_manual and commonslib_color to set category colors
    scale_fill_manual(values = c(
        "neonatal" = commonslib_color("ocean_green"),
        "maternity" = commonslib_color("commons_green")))

# After creating the plot, add a title and subtitle with add_commonslib_titles
plot <- add_commonslib_titles(
    plot,
    title = "Neonatal nurses have overtaken maternity nurses",
    subtitle = "Maternity and neonatal nurses in England")

# Save the plot in different formats ------------------------------------------

# Save a high resolution export of the plot as a png
save_png(
    "area-chart-annotations.png",
    plot = plot,
    width = 8,
    height = 5)

# Save an editable verson of the plot as an svg
save_svg(
    "area-chart-annotations.svg",
    plot = plot,
    width = 8,
    height = 5)
