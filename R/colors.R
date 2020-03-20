### Colors

# Color constants -------------------------------------------------------------

COLOR_PALETTE_COMMONS_GREEN <- "#006548"
COLOR_PALETTE_OCEAN_GREEN <- "#3f9d8a"
COLOR_PALETTE_PINE_GREEN <- "#003f2b"
COLOR_PALETTE_GRAPE <- "#682f7f"
COLOR_PALETTE_LILAC <- "#a37ec8"
COLOR_PALETTE_TANGERINE <- "#e09f00"
COLOR_PALETTE_CERULEAN_BLUE <- "#306298"
COLOR_PALETTE_PACIFIC_BLUE <- "#00a1cc"
COLOR_PALETTE_BURNT_ORANGE <- "#c23f18"
COLOR_PALETTE_CHERRY <- "#800f1b"

COLOR_PARTY_CONSERVATIVE <- "#0063ba"
COLOR_PARTY_LABOUR <- "#d50000"
COLOR_PARTY_LIB_DEM <- "#faa01a"
COLOR_PARTY_UKIP <- "#722889"
COLOR_PARTY_BREXIT <- "#12b6cf"
COLOR_PARTY_GREEN <- "#78b82a"
COLOR_PARTY_SNP <- "#fff685"
COLOR_PARTY_SNP_ALT <-  "#f7db15"
COLOR_PARTY_PLAID_CYMRU <- "#348837"
COLOR_PARTY_DUP <-  "#cc3300"
COLOR_PARTY_DUP_ALT <- "#d46a4c"
COLOR_PARTY_SINN_FEIN <- "#02665f"
COLOR_PARTY_UUP <- "#a1cdf0"
COLOR_PARTY_SDLP <- "#4ea268"
COLOR_PARTY_ALLIANCE <- "#cdaf2d"
COLOR_PARTY_OTHER <- "#909090"

# Palette color functions -----------------------------------------------------

#' Palette colors as a named vector
#'
#' @keywords internal

commonslib_colors <- c(
    "commons_green" = COLOR_PALETTE_COMMONS_GREEN,
    "ocean_green" = COLOR_PALETTE_OCEAN_GREEN,
    "pine_green" = COLOR_PALETTE_PINE_GREEN,
    "grape" = COLOR_PALETTE_GRAPE,
    "lilac" = COLOR_PALETTE_LILAC,
    "tangerine" = COLOR_PALETTE_TANGERINE,
    "cerulean_blue" = COLOR_PALETTE_CERULEAN_BLUE,
    "pacific_blue" = COLOR_PALETTE_PACIFIC_BLUE,
    "cherry" = COLOR_PALETTE_CHERRY,
    "burnt_orange" = COLOR_PALETTE_BURNT_ORANGE)

#' Get the hex code for a commons library palette color
#'
#' @param color_name The name of the color.
#' @return An RGB hex string for the given color.
#' @export

commonslib_color <- function (color_name) {
    unname(commonslib_colors[color_name])
}

# Party color functions -------------------------------------------------------

#' Party colors as a named vector
#'
#' @keywords internal

commonslib_party_colors <- c(
    "conservative" = COLOR_PARTY_CONSERVATIVE,
    "labour" = COLOR_PARTY_LABOUR,
    "lib_dem" = COLOR_PARTY_LIB_DEM,
    "ukip" = COLOR_PARTY_UKIP,
    "brexit" = COLOR_PARTY_BREXIT,
    "green" = COLOR_PARTY_GREEN,
    "snp" = COLOR_PARTY_SNP,
    "snp_alt" = COLOR_PARTY_SNP_ALT,
    "plaid_cymru" = COLOR_PARTY_PLAID_CYMRU,
    "dup" = COLOR_PARTY_DUP,
    "dup_alt" = COLOR_PARTY_DUP_ALT,
    "sinn_fein" = COLOR_PARTY_SINN_FEIN,
    "uup" = COLOR_PARTY_UUP,
    "sdlp" = COLOR_PARTY_SDLP,
    "alliance" = COLOR_PARTY_ALLIANCE,
    "other" = COLOR_PARTY_OTHER)

#' Get the hex code for a commons library party color
#'
#' @param party_name The name of the party.
#' @return An RGB hex string for the given party color.
#' @export

commonslib_party_color <- function (party_name) {
    unname(commonslib_party_colors[party_name])
}
