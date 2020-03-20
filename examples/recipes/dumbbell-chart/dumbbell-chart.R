# This is an example of how to make a dumbbell chart using the clcharts package.
#
# This script is self-contained: running it will create a PNG and an SVG of the
# example chart in the same directory. To run the script will need to ensure:
#
# 1. You have installed all of the packages that the script imports
# 2. You have the theme fonts set up on your computer
# 3. You have the dataset "dumbbell-chart.csv" in the same directory
#
# See the readme on GitHub to find out how to install the package and setup
# the fonts.
#
# To run the script, type the following code in your R console:
#
# source("dumbbell-chart.R")

# Imports ---------------------------------------------------------------------

library(tidyverse)
library(ggalt)
library(scales)
library(clcharts)

# Read in and prepare the data ------------------------------------------------

# Load the data from the csv as a dataframe
df <- read_csv("dumbbell-chart.csv")

# Turn the region column into a factor and order it by the number of premises
#in each region: this sorts the bars in the chart from largest to smallest
df$region <- factor(df$region)
df$region <- reorder(df$region, df$old_age_2008)

# Create the plot -------------------------------------------------------------

# Use ggplot to create a plot with data and mappings
plot <- ggplot(
        data = df,
        mapping = aes(x = old_age_2008, xend = old_age_2018, y = region)) +
     # Add a dumbell geometry to create the dumbells
    geom_dumbbell(
        colour = "#d0d0d0",
        colour_x = commonslib_color("commons_green"),
        colour_xend = commonslib_color("ocean_green"),
        size = 1.5,
        size_x = 2.5,
        size_xend = 2.5) +
    # Set labels for the axes, legend, and caption: DON'T set titles here
    labs(
        x = NULL,
        y = NULL,
        caption = "Source: ONS, Annual Population Estimates") +
    # Configure the the x and y axes: we set the x axis breaks and limits, turn
    # off expansion for the x axis, and format the percetages
    scale_x_continuous(
        limits = c(0.10, 0.24),
        breaks = seq(0.10, 0.24, 0.02),
        expand = c(0,0),
        label = percent_format(accuracy = 1)) +
    scale_y_discrete() +
    # Use annotate_commonslib to add labels to the plot: this function does
    # the same thing as annotate but it automatically sets the fonts to match
    # the house style; position each annotation using values on the axis scales;
    annotate_commonslib(
        x = 0.18,
        y = "South West",
        label = "2008",
        color = commonslib_color("commons_green"),
        size = 4) +
    annotate_commonslib(
        x = 0.2284,
        y = "South West",
        label = "2018",
        color = commonslib_color("ocean_green"),
        size = 4) +
    # Add the Commons Library theme: use just the bottom axis, turn off
    # gridlines and legend, set the caption position to left
    theme_commonslib(
        axes = "b",
        grid = "",
        caption_position = "left")

# After creating the plot, add a title and subtitle with add_commonslib_titles
plot <- add_commonslib_titles(
    plot,
    title = "The share of the population in older age groups has increased",
    subtitle = "Percentage aged 65 and older by country and region in 2008 and 2018")

# Save the plot in different formats ------------------------------------------

# Save a high resolution export of the plot as a png
save_png(
    "dumbbell-chart.png",
    plot = plot,
    width = 7,
    height = 7)

# Save an editable verson of the plot as an svg
save_svg(
    "dumbbell-chart.svg",
    plot = plot,
    width = 7,
    height = 7)
