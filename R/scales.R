# Scales

#' Function to extract commonslib colors as hex codes
#'
#' @param ... Names of colors in \code{commonslib_colors}.
#' @keywords internal

get_commonslib_colors <- function(...) {

    colors <- c(...)
    if (is.null(colors))
        return (commonslib_colors)
    commonslib_colors[colors]
}

#' Return a function which interpolates a commonslib color palette
#'
#' @param palette Name of palette in \code{commonslib_palettes}.
#' @param reverse Boolean to indicate whether the palette should be reversed.
#' @param ... Additional arguments to pass to \code{colorRampPalette}.
#' @keywords internal

get_commonslib_palette <- function(
    palette = "main",
    reverse = FALSE, ...) {

    commonslib_palettes <- list(
        main = get_commonslib_colors(
            "commons_green",
            "ocean_green",
            "pine_green",
            "grape",
            "lilac",
            "tangerine"),
        all = get_commonslib_colors(
            "commons_green",
            "ocean_green",
            "pine_green",
            "grape",
            "lilac",
            "tangerine",
            "cerulean_blue",
            "pacific_blue",
            "cherry",
            "burnt_orange"),
        green = get_commonslib_colors(
            "commons_green",
            "ocean_green",
            "pine_green"),
        greenpurple = get_commonslib_colors(
            "green_2",
            "green_3")
    )

    p <- commonslib_palettes[[palette]]
    if (reverse) p <- rev(p)
    grDevices::colorRampPalette(p, ...)
}

#' Color scale for commonslib colors
#'
#' @param palette Name of palette in \code{commonslib_palettes}.
#' @param discrete Boolean to indicate if color aesthetic is discrete.
#' @param reverse Boolean to indicate whether palette should be reversed.
#' @param ... Additional arguments passed to \code{discrete_scale} or
#'   \code{scale_color_gradientn}, depending on the value of \code{discrete}.
#' @export

scale_color_commonslib <- function(
    palette = "main",
    discrete = TRUE,
    reverse = FALSE, ...) {

    p <- get_commonslib_palette(palette = palette, reverse = reverse)

    if (discrete) {
        ggplot2::discrete_scale(
            "color", paste0("commonslib_", palette), palette = p, ...)
    } else {
        ggplot2::scale_color_gradientn(colors = p(256), ...)
    }
}

#' Fill scale for commonslib colors
#'
#' @param palette Name of palette in \code{commonslib_palettes}.
#' @param discrete Boolean to indicate if color aesthetic is discrete.
#' @param reverse Boolean to indicate whether palette should be reversed.
#' @param ... Additional arguments passed to \code{discrete_scale} or
#'   \code{scale_color_gradientn}, depending on the value of \code{discrete}.
#' @export

scale_fill_commonslib <- function(
    palette = "main",
    discrete = TRUE,
    reverse = FALSE, ...) {

    p <- get_commonslib_palette(palette = palette, reverse = reverse)

    if (discrete) {
        ggplot2::discrete_scale(
            "fill", paste0("commonslib_", palette), palette = p, ...)
    } else {
        ggplot2::scale_fill_gradientn(colors = p(256), ...)
    }
}
