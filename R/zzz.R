# Package setup

.onLoad <- function(libname, pkgname) {

  options(clcharts.national_semibold = file.path(
    Sys.getenv("HOME"), ".clcharts", "National-LFSN-Semibold.otf"))

  options(clcharts.national_book = file.path(
    Sys.getenv("HOME"), ".clcharts", "National-LFSN-Book.otf"))

  options(clcharts.open_sans_regular = file.path(
    Sys.getenv("HOME"), ".clcharts", "OpenSans-Regular.ttf"))

  options(clcharts.open_sans_bold = file.path(
    Sys.getenv("HOME"), ".clcharts", "OpenSans-Bold.ttf"))

  load_fonts()
}
