# todo: add color and cursive coding
# todo: check city names with original baghdad2london

rm(list = ls())
setwd("~/repos/wp4-cow-conversions/b2l/")

library("readxl")
library("data.table")
library("stringi")

siem = readxl::read_excel("dat/urb pop 700 to 2000.xlsx", sheet = "Sheet2", skip = 2)
data.table::setDT(siem)
comm = data.table::fread("dat/urb pop 700 to 2000 comments only.csv", skip = 2)
comm = comm[1:nrow(siem)]

comm = comm[, lapply(.SD, stringi::stri_replace_all_fixed, '\n', ' - ')]

all.equal(siem$city, comm$city)

siem = merge(siem, comm[, grep("city|\\d+y", names(comm)), with = F], by = 'city', suffixes = c("", "_comment"))
siem = siem[, -5]

str(siem)
siem_long = data.table::melt(siem, 
    id.vars = c("city", "UN country code", "country", "latitude", "longtitude", "elevation", "transport location"),
    variable.name = 'year', value.name = c("inhab", "comment"),
    measure.vars = data.table:::patterns("\\d+y$", "comment$", cols = names(siem)))

siem_long[, inhab := as.numeric(inhab)]

data.table::fwrite(siem_long, "dat/siem_long.csv", na = "")