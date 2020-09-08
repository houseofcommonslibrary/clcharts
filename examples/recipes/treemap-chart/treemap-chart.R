# This is an example of how to make a treemap chart using the clcharts package.
#
# This script is self-contained: running it will create a PNG and an SVG of the
# example chart in the same directory. To run the script will need to ensure:
#
# 1. You have installed all of the packages that the script imports
# 2. You have the theme fonts set up on your computer
# 3. You have the dataset "treemap-chart.csv" in the same directory
#
# See the readme on GitHub to find out how to install the package and setup
# the fonts.
#
# To run the script, type the following code in your R console:
#
# source("treemap-chart.R")

# Imports ---------------------------------------------------------------------

library(tidyverse)
library(treemapify)
library(clcharts)

# Read in and prepare the data ------------------------------------------------

# Load the data from the csv as a dataframe
df <- read_csv("treemap-chart.csv")

# Divide value by one million to get the value in millions
df$value <- df$value / 1000000

# Create plot -----------------------------------------------------------------

plot <- ggplot(
        data = df,
        mapping = aes(
            area = value,
            fill = region,
            subgroup = region,
            label = country)) +
    # Add a treemap tile geometry: geom_treemap will generate tile area by
    # value for each observation, specify seperating lines to be the same
    # colour as plot background and line thickness
    geom_treemap(
        colour = "#dad5d1",
        size = 0.1) +
    # Add treemap text geometry for labels: set font family as "Open Sans" and
    # text color as white ("#ffffff") - geom_text_commonslib DOESN'T work here
    geom_treemap_text(
        color = "#ffffff",
        family = "Open Sans") +
    geom_treemap_subgroup_text(
        color = "#ffffff",
        family = "Open Sans",
        fontface = "bold",
        alpha = 0.5) +
    # Set labels for the caption: DON'T set titles here
    labs(
        caption = "Source: World Bank, Military Expenditure") +
    # Use scale_fill_manual and commonslib_color to set region colors
    scale_fill_manual(values = c(
        "North America" = commonslib_color("commons_green"),
        "Europe & Central Asia" =    commonslib_color("tangerine"),
        "East Asia & Pacific" = commonslib_color("grape"),
        "Middle East & North Africa" = commonslib_color("cerulean_blue"),
        "South Asia" = commonslib_color("ocean_green"),
        "Latin America & Caribbean" = commonslib_color("lilac"),
        "Sub-Saharan Africa" = commonslib_color("pacific_blue"))) +
    # Add the Commons Library theme: we set the legend, caption positions,
    # and axes
    theme_commonslib(
        axes = "",
        caption_position = "right",
        legend_position = "none")

# After creating the plot, add a title and subtitle with add_commonslib_titles
plot <- add_commonslib_titles(
    plot,
    title = "The United States has the largest military expenditure in the world",
    subtitle = "Military expenditure by region and country in 2018")

# Save the plot in different formats ------------------------------------------

# Save a high resolution export of the plot as a png
save_png(
    "treemap-chart.png",
    plot = plot,
    width = 8,
    height = 8)

# Save an editable verson of the plot as an svg
save_svg(
    "treemap-chart.svg",
    plot = plot,
    width = 8,
    height = 8)
