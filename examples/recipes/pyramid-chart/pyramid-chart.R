# This is an example of how to make a pyramid chart using the clcharts package.
#
# This script is self-contained: running it will create a PNG and an SVG of the
# example chart in the same directory. To run the script will need to ensure:
#
# 1. You have installed all of the packages that the script imports
# 2. You have the theme fonts set up on your computer
# 3. You have the dataset "pyramid-chart.csv" in the same directory
#
# See the readme on GitHub to find out how to install the package and setup
# the fonts.
#
# To run the script, type the following code in your R console:
#
# source("pyramid-chart.R")

# Imports ---------------------------------------------------------------------

library(tidyverse)
library(clcharts)

# Read in and prepare the data ------------------------------------------------

# Load the data from the csv as a dataframe
df <- read_csv("pyramid-chart.csv")

# Create age range groups and cut age variable to groups
age_breaks <- c(seq(from = -1, to = 90, by = 5), 90)
age_labels <- c("0-4", "5-9", "10-14", "15-19", "20-24",
  "25-29", "30-34", "35-39", "40-44", "45-49", "50-54",
  "55-59", "60-64", "65-69", "70-74", "75-79", "80-84", "85-89", "90+")
df$age_group <- cut(df$age, breaks = age_breaks, labels = age_labels)

# Multiply female by -1 so that columns will split left and right
df$female <- df$female * -1 

# Privot dataframe from wide to long and sum population for each age group
df <- df %>% 
  pivot_longer(-c(age, age_group), names_to = "sex", values_to = "count") %>% 
  group_by(sex, age_group) %>% 
  summarise(count = sum(count))

# Divide count by one thound to get values in thousands
df$count <- df$count / 1000

# Create plot -----------------------------------------------------------------

# Use ggplot to create a plot with data and mappings
plot <- ggplot(
  data = df,
  mapping = aes(x = age_group, y = count, fill = sex)) +
  # Add a col geometry for columns: use width = 0.8 to match house style;
  # geom_col will plot the values for each category
  geom_col(width = 0.8) +
  # Configure the x and y axes: we set the y axis breaks and limits, and
  # we turn off the y-axis expansion
  scale_x_discrete() +
  scale_y_continuous(
    limits = c(-2500, 2500),
    breaks = seq(-2500, 2500, 500),
    labels = comma(c(
      seq(from = 2500, to = 500, by = -500), seq(from = 0, to = 2500, by = 500)),
    expand = c(0,0))) +
  # Use the coord_flip function to flip the axes: this will turn a vertical
  # column chart into a horizontal bar chart
  coord_flip() +
  # Set labels for the axes, legend, and caption: DON'T set titles here
  labs(
    x = NULL,
    y = NULL,
    fill = NULL,
    caption = "Source: ONS, Mid-year population 2016") +
  # Use annotate_commonslib to add annotations to a plot: this function does
  # the same thing as annotate but it automatically sets the fonts to match
  # the house style; position each annotation using values on the axis scales
  annotate_commonslib(
    x = 19,
    y = 1750,
    label = "Male",
    size = 3.5) +
  annotate_commonslib(
    x = 19,
    y = -1750,
    label = "Female",
    size = 3.5) +
  # Add the Commons Library theme: we don't specify settings for the axes and
  # grid which means we are using the defaults; we set the legend and caption
  # positions
  theme_commonslib(
    legend_position = "none",
    caption_position = "right",
    axes = "h",
    grid = "v") +
  scale_fill_manual(values = c(
    commonslib_color("commons_green"),
    commonslib_color("ocean_green")))

# After creating the plot, add a title and subtitle with add_commonslib_titles
plot <- add_commonslib_titles(
  plot, 
  title = "Women outnumber men over the age of 80",
  subtitle = "UK mid-year 2016 population by gender and age, Millions")

# Save the plot in different formats ------------------------------------------

# Save a high resolution export of the plot as a png
save_png(
  "pyramid-chart.png",
  plot = plot,
  width = 8,
  height = 8)

# Save an editable verson of the plot as an svg
save_svg(
  "pyramid-chart.svg",
  plot = plot,
  width = 8,
  height = 8)
