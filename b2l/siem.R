# todo: city_safe not unique, nor is city, city+country
# rounding errors screw up city + lat + lon


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

siem = merge(siem, comm[, grep("city|country|\\d+y", names(comm)), with = F], by = c('city', 'country'), suffixes = c("", "_comment"))
siem = merge(siem, lbls[, grep("city|country|\\d+y", names(lbls)), with = F], by = c('city', 'country'), suffixes = c("", "_quality"))
siem = siem[, -5]

siem_long = data.table::melt(siem, 
    id.vars = c("city", "uncountrycode", "country", "latitude", "longitude", "elevation", "transportloc"),
    variable.name = 'year', value.name = c("inhab", "comment", "quality"),
    measure.vars = data.table:::patterns("\\d+y$", "comment$", "quality$", cols = names(siem)))

siem_long[, .N, by = list(city, country)][, unique(N)]

siem_long[, year := names(siem)[grep("\\d+y$", names(siem))][year]]
siem_long[, year := as.integer(stringi::stri_extract_first_regex(year, "\\d+"))]

siem_long[country == 'france', country := "France"]
siem_long[country == 'italy', country := "Italy"]
siem_long[country == 'spain', country := "Spain"]

siem_long[city == "Itri", latitude := 41.29044]
siem_long[city == "Itri", longitude := 13.53216]
siem_long[city == "Lokeren", latitude := 51.10234]
siem_long[city == "Lokeren", longitude := 3.994066]
siem_long[city == "Sighisoara", latitude := 46.2197]
siem_long[city == "Sighisoara", longitude := 24.79639]

plot(latitude ~ longitude, data = siem_long[year == 1500])

siem_long[, inhab := as.integer(inhab)]
siem_long[is.na(as.numeric(quality)), ]
siem_long[!is.na(as.numeric(quality)), quality := NA]

siem_long[, city_alt := stringi::stri_extract_first_regex(city, "\\(.*\\)")]
siem_long[, city_short := data.table::tstrsplit(city, "(", fixed = TRUE, keep = 1L)]
siem_long[, city_safe := tolower(stringi::stri_replace_all_regex(city_short, "[^A-z]", ""))]

siem_long[, .N, by = list(city_safe, country)][, unique(N)]
siem_long[year == 1500, city_safe[duplicated(city_safe)], by = country]

siem_long[, distfromlond := round(sp::spDistsN1(cbind(longitude, latitude), c(0, 50)), -1)]
siem_long[year == 1500, paste0(city_safe, distfromlond)[duplicated(paste0(city_safe, distfromlond))], by = country]

data.table::fwrite(siem_long, "dat/siem_long.csv", na = "", quote = TRUE)
