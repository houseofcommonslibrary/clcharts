### Functions to create a gallery of examples using the theme and scales

# Imports ---------------------------------------------------------------------

library(tidyverse)
library(scales)
devtools::load_all(".")

# Constants -------------------------------------------------------------------

DATASET_DIR <- "datasets"
DATASET_CON_FILE <- file.path(DATASET_DIR, "constituencies.csv")
DATASET_MIGRATION_FILE <- file.path(DATASET_DIR, "migration.csv")
DATASET_MIGRATION_NATIONALITY_FILE <- file.path(DATASET_DIR, "migration-nationality.csv")
DATASET_NURSES_FILE <- file.path(DATASET_DIR, "nurses.csv")

GALLERY_DIR <- "."
GALLERY_FILE <- "gallery.html"

GALLERY_BAR_CONS_REGION_NAME <- file.path("bar-cons-region")
GALLERY_LINE_MIGRATION_NAME <- file.path("line-migration")
GALLERY_BAR_MIGRATION_NAME <- file.path("bar-migration")
GALLERY_AREA_NURSES_NAME <- file.path("area-nurses")
GALLERY_SCATTER_CONS_TYPE_NAME <- file.path("scatter-cons-type")
GALLERY_SCATTER_CONS_FACET_NAME <- file.path("scatter-cons-facet")

SVG_WIDTH <- 8
SVG_HEIGHT <- 5

# Font setup: Change these paths for your local setup -------------------------

sysfonts::font_add(
    family = "National-LFSN Semibd",
    regular = "/Users/oli/Library/Fonts/National-LFSN-Semibold.ttf")

sysfonts::font_add(
    family = "National-LFSN Book",
    regular = "/Users/oli/Library/Fonts/National-LFSN-Book.ttf")

sysfonts::font_add(
    family = "Open Sans",
    regular = "/Users/oli/Library/Fonts/OpenSans-Regular.ttf",
    bold = "/Users/oli/Library/Fonts/OpenSans-Bold.ttf")

showtext::showtext_auto()

# Build gallery ---------------------------------------------------------------

build_example <- function(example_name, example_func) {

    plot <- example_func()

    svgfile <- file.path(GALLERY_DIR, str_glue("{example_name}.svg"))
    save_svg(plot, svgfile, SVG_WIDTH, SVG_HEIGHT)

    pngfile <- file.path(GALLERY_DIR, str_glue("{example_name}.png"))
    save_png(plot, pngfile, SVG_WIDTH, SVG_HEIGHT)
}

build_gallery <- function() {

    examples <- list()
    examples[[GALLERY_BAR_CONS_REGION_NAME]] = example_bar_cons_region
    examples[[GALLERY_LINE_MIGRATION_NAME]] = example_line_migration
    examples[[GALLERY_BAR_MIGRATION_NAME]] = example_bar_migration
    examples[[GALLERY_AREA_NURSES_NAME]] = example_area_nurses
    examples[[GALLERY_SCATTER_CONS_TYPE_NAME]] = example_scatter_cons_type
    examples[[GALLERY_SCATTER_CONS_FACET_NAME]] = example_scatter_cons_facet

    elements <- map_chr(names(examples), function(example_name) {
        build_example(example_name, examples[[example_name]])
        element <- str_glue(
            "<p>
                <img src=\"{example_name}.svg\" height=\"500\" width=\"800\" />
            </p>")
    })

    elements <- str_c(elements, collapse = "")

    html <- str_glue(
        "<html><head></head><body>{elements}</body></html>")

    htmlfile <- file.path(GALLERY_DIR, GALLERY_FILE)
    write_file(html, htmlfile)
}

# Examples --------------------------------------------------------------------

example_bar_cons_region <- function() {

    df <- read_csv(DATASET_CON_FILE)
    df$region <- factor(df$region)
    df$region <- fct_rev(reorder(df$region, df$region, length))

    plot <- ggplot(data = df) +
        geom_bar(
            mapping = aes(x = region),
            fill = commonslib_color("commons_green"),
            width = 0.8) +
        geom_text_commonslib(
            stat = "count",
            mapping = aes(x = region, label = ..count..),
            vjust = "top",
            nudge_y = -3) +
        labs(
            x = "Country or region",
            y = "Number of constituencies",
            caption = "Source: House of Commons Library") +
        scale_x_discrete(
            expand = expansion(add = c(0.5, 0.5))) +
        scale_y_continuous(expand = c(0,0)) +
        theme_commonslib(axes = "b", grid = "h", caption_position = "left") +
        theme(legend.position = "none")

    plot <- add_commonslib_titles(
        plot,
        title = "Countries and regions vary in representation",
        subtitle = "Constituencies by country or region, United Kingdom")

    plot
}

example_line_migration <- function() {

    df <- read_csv(DATASET_MIGRATION_FILE)

    plot <- ggplot(
            data = df,
            mapping = aes(x = quarter, y = estimate, color = flow)) +
        geom_line(size = 1.1) +
        labs(
            color = NULL,
            x = NULL,
            y = "Thousands of people",
            caption = "Source: ONS, Provisional LTIM estimates") +
        scale_y_continuous(
            breaks = seq(0, 800, 200),
            limits = c(0, 800)) +
        coord_cartesian(expand = FALSE) +
        theme_commonslib(axes = "b", grid = "h") +
        scale_color_manual(values = c(
            "Immigration" = commonslib_color("commons_green"),
            "Net migration" = commonslib_color("ocean_green"))) +
        #theme(legend.position = "top", legend.direction = "horizontal")
        theme(
            legend.position = c(1, 0.99),
            legend.justification = c(1, 1),
            legend.direction = "horizontal")

    plot <- add_commonslib_titles(
        plot,
        title = "Net migration has fallen since the EU referendum",
        subtitle = "International migration in the year ending each quarter")
}

example_bar_migration <- function() {

    df <- read_csv(DATASET_MIGRATION_NATIONALITY_FILE)
    df$year <- as.character(df$year)
    df$nationality <- factor(df$nationality, levels = c("Non-EU", "EU", "British"))

    plot <- ggplot(
            data = df,
            mapping = aes(x = year, y = estimate, fill = nationality)) +
        geom_col(width = 0.8) +
        labs(
            x = NULL,
            y = NULL,
            fill = NULL,
            caption = "Source: ONS, Provisional LTIM estimates") +
        scale_x_discrete() +
        scale_y_continuous(
            limits = c(0, 700),
            breaks = seq(0, 700, 100),
            expand = c(0,0)) +
        theme_commonslib(
            legend_position = "top-right",
            caption_position = "left") +
        scale_fill_manual(values = c(
            "British" = commonslib_color("tangerine"),
            "EU" = commonslib_color("commons_green"),
            "Non-EU" = commonslib_color("ocean_green")))

    plot <- add_commonslib_titles(
        plot,
        title = "Immigration is stable but the composition has changed",
        subtitle = "Immigration by nationality in each year ending September, Thousands")
}

example_area_nurses <- function() {

    df <- read_csv(DATASET_NURSES_FILE) %>%
        pivot_longer(
            cols = -date,
            names_to = "care_setting",
            values_to = "number")

    df$care_setting <- factor(
        df$care_setting,
        levels = c("neonatal", "maternity"))

    plot <- ggplot(
            data = df,
            mapping = aes(x = date, y = number, fill = care_setting)) +
        geom_area() +
        labs(
            x = NULL,
            y = NULL) +
        scale_y_continuous(
            label = comma,
            limits = c(0, 9000),
            breaks = seq(0, 9000, 3000)) +
        scale_x_date() +
        coord_cartesian(expand = FALSE) +
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
        theme_commonslib(grid = "h") +
        scale_fill_manual(values = c(
            "neonatal" = commonslib_color("ocean_green"),
            "maternity" = commonslib_color("commons_green"))) +
        theme(legend.position = "none")

    plot <- add_commonslib_titles(
        plot,
        title = "Neonatal nurses have overtaken maternity nurses",
        subtitle = "Maternity and neonatal nurses in England")
}

example_scatter_cons_type <- function() {

    types <- c("London", "Other city", "Large town",
               "Medium town", "Small town", "Village")
    df <- read_csv(DATASET_CON_FILE)
    df <- df %>% filter(! is.na(classification))
    df$type <- factor(df$classification, levels = types)

    plot <- ggplot(
            data = df,
            mapping = aes(x = median_age, y = turnout, color = type)) +
        geom_point(
            shape = 16,
            size = 2) +
        labs(
            x = "Median age",
            y = "Turnout",
            color = "Settlement class",
            caption = "Source: House of Commons Library") +
        scale_x_continuous(
            limits = c(25, 55)) +
        scale_y_continuous(
            limits = c(0.5, 0.8),
            label = percent_format(accuracy = 1)) +
        coord_cartesian(expand = FALSE) +
        theme_commonslib(grid = "hv") +
        scale_color_manual(values = c(
            "London" = commonslib_color("commons_green"),
            "Other city" = commonslib_color("ocean_green"),
            "Large town" = commonslib_color("grape"),
            "Medium town" = commonslib_color("lilac"),
            "Small town" = commonslib_color("tangerine"),
            "Village" = commonslib_color("burnt_orange")))

    plot <- add_commonslib_titles(
        plot,
        title = "Turnout was higher in older, less urban constituencies",
        subtitle = "Constituencies by age, turnout and settlement class, 2017")
}

example_scatter_cons_facet <- function() {

    types <- c("London", "Other city", "Large town",
               "Medium town", "Small town", "Village")
    df <- read_csv(DATASET_CON_FILE)
    df <- df %>% filter(! is.na(classification))
    df$type <- factor(df$classification, levels = types)

    plot <- ggplot(
            data = df,
            mapping = aes(x = median_age, y = turnout, color = type)) +
        geom_point(
            shape = 16,
            size = 2,
            alpha = 0.6) +
        facet_wrap(~ type) +
        labs(
            x = "Median age",
            y = "Turnout",
            color = "Settlement class",
            caption = "Source: House of Commons Library") +
        scale_x_continuous(
            limits = c(25, 55)) +
        scale_y_continuous(
            limits = c(0.5, 0.85),
            label = percent_format(accuracy = 1)) +
        coord_cartesian(expand = FALSE) +
        theme_commonslib(axes = "", grid = "hv") +
        scale_color_manual(values = c(
            "London" = commonslib_color("commons_green"),
            "Other city" = commonslib_color("ocean_green"),
            "Large town" = commonslib_color("grape"),
            "Medium town" = commonslib_color("lilac"),
            "Small town" = commonslib_color("tangerine"),
            "Village" = commonslib_color("burnt_orange"))) +
        theme(legend.position ="None")

    plot <- add_commonslib_titles(
        plot,
        title = "Turnout was higher in older, less urban constituencies",
        subtitle = "Constituencies by age, turnout and settlement class, 2017")
}
