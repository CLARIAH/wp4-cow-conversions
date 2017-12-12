# todo: check city names with original baghdad2london

rm(list = ls())
setwd("~/repos/wp4-cow-conversions/b2l/")

library("readxl")
library("data.table")
library("stringi")

siem = readxl::read_excel("dat/urb pop 700 to 2000.xlsx", sheet = "Sheet2", skip = 2)
data.table::setDT(siem)
setnames(siem, c("UN country code", "transport location", "longtitude"), 
    c("uncountrycode", "transportloc", "longitude"))

comm = data.table::fread("dat/urb pop 700 to 2000 comments only.csv", skip = 2)
lbls = data.table::fread("dat/urb pop 700 to 2000 getal_labels.csv")
comm = comm[1:nrow(siem)]
lbls = lbls[1:nrow(siem)]

comm = comm[, lapply(.SD, stringi::stri_replace_all_fixed, '\n', ' - ')]

all.equal(siem$city, comm$city)
all.equal(siem$city, lbls$city)

siem = merge(siem, comm[, grep("city|\\d+y", names(comm)), with = F], by = 'city', suffixes = c("", "_comment"))
siem = merge(siem, lbls[, grep("city|\\d+y", names(lbls)), with = F], by = 'city', suffixes = c("", "_quality"))
siem = siem[, -5]

siem_long = data.table::melt(siem, 
    id.vars = c("city", "uncountrycode", "country", "latitude", "longitude", "elevation", "transportloc"),
    variable.name = 'year', value.name = c("inhab", "comment", "quality"),
    measure.vars = data.table:::patterns("\\d+y$", "comment$", "quality$", cols = names(siem)))

siem_long[, year := names(siem)[grep("\\d+y$", names(siem))][year]]
siem_long[, year := as.integer(stringi::stri_extract_first_regex(year, "\\d+"))]

siem_long[, inhab := as.integer(inhab)]
siem_long[is.na(as.numeric(quality)), ]
siem_long[!is.na(as.numeric(quality)), quality := NA]

siem_long[, city_alt := stringi::stri_extract_first_regex(city, "\\(.*\\)")]
siem_long[, city_short := data.table::tstrsplit(city, "(", fixed = TRUE, keep = 1L)]
siem_long[, city_safe := tolower(stringi::stri_replace_all_regex(city_short, "[^A-z]", ""))]

data.table::fwrite(siem_long, "dat/siem_long.csv", na = "", quote = TRUE)
