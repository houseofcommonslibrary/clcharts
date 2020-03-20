# This is an example of how to make a binned ridge chart using the clcharts
# package.
#
# This script is self-contained: running it will create a PNG and an SVG of the
# example chart in the same directory. To run the script will need to ensure:
#
# 1. You have installed all of the packages that the script imports
# 2. You have the theme fonts set up on your computer
# 3. You have the dataset "ridge-chart-bins.csv" in the same directory
#
# See the readme on GitHub to find out how to install the package and setup
# the fonts.
#
# To run the script, type the following code in your R console:
#
# source("ridge-chart-bins.R")

# Imports ---------------------------------------------------------------------

library(tidyverse)
library(ggridges)
library(clcharts)

# Read in and prepare the data ------------------------------------------------

# Load the data from the csv as a dataframe
df <- read_csv("ridge-chart-bins.csv")

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
        mapping = aes(x = median_age, y = classification)) +
    # Add a density ridgeline geometry to create histograms;
    # set stat = "binline" to use binning, and bins = 10 to set number of bins
    # scale should be less than one stop bins overlapping
    # set both fill and color to the same green
    geom_density_ridges(
        fill = commonslib_color("commons_green"),
        color = commonslib_color("commons_green"),
        size = 0.2,
        scale = 0.8,
        stat = "binline",
        bins = 10) +
    # Set labels for the axes, colors and caption: DON'T set titles here
    labs(
        x = "Median age",
        y = NULL,
        color = "Settlement class",
        caption = "Source: House of Commons Library") +
    # Configure the the x axis only: turn the expansion off
    scale_x_continuous(expand = c(0, 0)) +
    # Use this to stop ggplot clipping the top of the highest ridge
    coord_cartesian(clip = "off") +
    # Add the Commons Library theme: turn off the axes and the legend, and use
    # verical gridlines
    theme_commonslib(
        axes = "",
        grid = "v",
        legend_position = "none",
        caption_position = "left")

# After creating the plot, add a title and subtitle with add_commonslib_titles
plot <- add_commonslib_titles(
    plot,
    title = "Median age was higher in less urban constituencues",
    subtitle = "Distribution of constituencies by median age and settlement class, 2017")

# Save the plot in different formats ------------------------------------------

# Save a high resolution export of the plot as a png
save_png(
    "ridge-chart-bins.png",
    plot = plot,
    width = 8,
    height = 7)

# Save an editable verson of the plot as an svg
save_svg(
    "ridge-chart-bins.svg",
    plot = plot,
    width = 8,
    height = 7)
