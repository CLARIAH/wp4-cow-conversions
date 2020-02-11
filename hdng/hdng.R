## HDNG file from Rick into version that works with COW and seperates municipalities from provinces.
# pad CBSNR
# seperate SANR from variables (not possible in json schema)


setwd("C:\\Users\\Ruben\\Documents\\02. Werk\\Clariah\\HDNG")
library(data.table)


hdng <- read_delim("HDNG/HDNG+prov+missing.txt", 
                   "\t", quote = "\\\"", escape_double = FALSE, 
                   trim_ws = TRUE)

setDT(hdng)


# remove potentially COW-breaking characters from variable_name 

hdng[suffix == "LAND", variable_name := "Oppervlakte in km"]

hdng[, variable_name := gsub("/", " en ", variable_name)]
hdng[, variable_name := gsub("%", "percentage", variable_name)]
hdng[, variable_name := gsub(";", ",", variable_name)]
hdng[, variable_name := gsub(">", " meer dan ", variable_name)]
hdng[, variable_name := gsub("<", " minder dan ", variable_name)]
hdng[, variable_name := gsub("-", " ", variable_name)]
hdng_gemeenten[, NAAM := stringi::stri_trans_general(NAAM, "ascii")]

hdng_gemeenten_short[, NAAM := gsub("'", "", NAAM)]

# seperate gemeenten and provinces

hdng_gemeenten <- hdng[!is.na(ACODE),]

hdng_provincies <- hdng[is.na(ACODE),]

# add zeroes to CBSNR

hdng_gemeenten[, CBSNR := stringr::str_pad(CBSNR, 4, side = c("left"), pad = "0")]

# make SANR seperate variable to add to gemeente in json schema

hdng[suffix == "SANR", SANR := value,  ]

# get working short version

hdng_gemeenten_short <- hdng_gemeenten[1:10000,]

# write csv

fwrite(hdng_gemeenten, 
       "C:\\Users\\Ruben\\Documents\\02. Werk\\Clariah\\HDNG\\hdng_gemeenten.csv", 
       sep=";", row.names = FALSE, na = "", quote = TRUE)

fwrite(hdng_provincies, 
       "C:\\Users\\Ruben\\Documents\\02. Werk\\Clariah\\HDNG\\hdng_provincies.csv", 
       sep=";", row.names = FALSE, na = "", quote = TRUE)
