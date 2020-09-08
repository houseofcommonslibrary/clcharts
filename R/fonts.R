# Font handling

#' Load the font files needed for the theme
#'
#' This function is used to load the font files needed for the theme. It is
#' called automatically when the package loads. By default it looks for the
#' required files in a standard location: a folder in the user's home directory
#' called \code{.clcharts}.
#'
#' This function is needed because there are too many inconsistencies in the
#' way R handles fonts on different operating systems. Rather than trying to
#' find and load the correct system fonts in all circustances, a font bundle is
#' available to package users which contains the licensed fonts.
#'
#' @param national_semibold Path to the font file for National-Semibold
#' @param national_book Path to the font file for National-Book
#' @param open_sans_regular Path to the font file for OpenSans-Regular
#' @param open_sans_bold Path to the font file for OpenSans-Regular
#' @keywords internal

load_fonts <- function(
    national_semibold = getOption("clcharts.national_semibold"),
    national_book = getOption("clcharts.national_book"),
    open_sans_regular = getOption("clcharts.open_sans_regular"),
    open_sans_bold = getOption("clcharts.open_sans_bold")) {

    sysfonts::font_add(
        family = "National-LFSN Semibd",
        regular = national_semibold)

    sysfonts::font_add(
        family = "National-LFSN Book",
        regular = national_book)

    sysfonts::font_add(
        family = "Open Sans",
        regular = open_sans_regular,
        bold = open_sans_bold)

    showtext::showtext_auto()
}
