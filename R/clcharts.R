#' clcharts: Tools for making charts in the House of Commons Library style
#'
#' The clcharts package provides themes, colors, and tools for making charts in
#' the House of Commons Library style.
#'
#' @docType package
#' @name clcharts
#' @importFrom ggplot2 %+replace%
#' @importFrom magrittr %>%
#' @importFrom rlang .data
NULL

# Tell R CMD check about new operators
if(getRversion() >= "2.15.1") {
  utils::globalVariables(c(".", ":="))
}
