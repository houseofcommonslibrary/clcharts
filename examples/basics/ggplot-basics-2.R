# Load the packages: tidyverse includes ggplot2
library(tidyverse)
library(clcharts)

# Set the random seed to make the output reproducible
set.seed(2001)

# Create some random data to plot
df <- tibble(
    time = 1:10,
    value = time + 5 + rnorm(10))

# Use the ggplot function to set up the plot with the data
plot <- ggplot(
        # Specify that df contains the data
        data = df,
        # Use aes to map time to the x axis and value to the y axis
        mapping = aes(x = time, y = value)) +

    # Use the geom_line function to indicate the data should be drawn as a line
    geom_line(color = commonslib_color("commons_green"), size = 1.1) +

   # Don't set the title and subtitle in the labs function
    labs(
        x = "Time",
        y = "Value") +

    # Use the scale_x and scale_y functions to control each axis
    scale_x_continuous(breaks = seq(0, 10, 2)) +
    scale_y_continuous(limits = c(0, 20)) +

    # Use the theme_commonslib function to set the plot style
    theme_commonslib()

# After creating the plot, add a title and subtitle with add_commonslib_titles
plot <- add_commonslib_titles(
    plot,
    title = "Something has increased",
    subtitle = "The value of something over time")

# Save the plot
save_png(plot, "ggplot-basics-2.png", width = 8, height = 5)
