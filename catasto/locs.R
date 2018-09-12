library("readxl")
library("data.table")
library("stringi")

locs = data.table::as.data.table(read_excel("~/repos/sdh-private-catasto/locations.xlsx"))
names(locs) = c('NUMSER', 'numser_loc',
             'QUART', 'quart_loc',
             'PIVIE', 'pivie_loc',
             'POPOL', 'popol_loc')

# locs[!is.na(popol_loc), list(NUMSER, QUART, PIVIE, POPOL)]

locs = locs[, lapply(.SD, stringi::stri_trim_both)]


locs[locs == c('"')] = NA
locs[locs == c('“')] = NA
locs[locs == c('”')] = NA
locs[locs == c('„')] = NA
locs[locs == c('“”')] = NA
locs[locs == c('““')] = NA
    
locs[, numser_loc := zoo::na.locf(numser_loc), by = NUMSER]
locs[, quart_loc := zoo::na.locf(quart_loc), by = list(NUMSER, QUART)]
locs[, zoo::na.locf(pivie_loc), by = list(NUMSER, QUART, PIVIE)]
locs[, pivie_loc := zoo::na.locf(pivie_loc), by = list(NUMSER, QUART, PIVIE)]
locs[!is.na(PIVIE), pivie_loc := zoo::na.locf(pivie_loc), by = list(NUMSER, QUART, PIVIE)]

locs[shift(quart_loc) != quart_loc]
length(unique(locs$quart_loc))

locs[shift(pivie_loc) != pivie_loc, pivie_loc][duplicated(locs[shift(pivie_loc) != pivie_loc, pivie_loc])]
length(unique(locs$pivie_loc))
# remainder are actually doubles

data.table::fwrite(locs, "~/repos/sdh-private-catasto/locations.csv", quote = TRUE)

# data.table::fwrite(locs[, list(NUMSER, numser_loc)], "~/repos/sdh-private-catasto/numser.csv", quote = TRUE)
# data.table::fwrite(locs[, list(QUART, quart_loc)], "~/repos/sdh-private-catasto/quart.csv", quote = TRUE)
# data.table::fwrite(locs[, list(PIVIE, pivie_loc)], "~/repos/sdh-private-catasto/pivie.csv", quote = TRUE)
# data.table::fwrite(locs[, list(POPOL, popol_loc)], "~/repos/sdh-private-catasto/popol.csv", quote = TRUE)
