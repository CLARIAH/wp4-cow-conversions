## HDNG file from Rick into version that works with COW and seperates municipalities from provinces.
# pad CBSNR
# seperate SANR from variables (not possible in json schema)


setwd("C:\\Users\\Ruben\\Documents\\02. Werk\\Clariah\\HDNG")
library(data.table)
library(readr)

hdng <- read.csv("HDNG+prov+missing.txt", header=T, sep="\t", stringsAsFactors=F)
setDT(hdng)


# remove potentially COW-breaking characters from variable_name 

hdng[suffix == "LAND", variable_name := "Oppervlakte in km2"]

hdng[, variable_name := gsub("%", " percentage", variable_name)]
hdng[, variable_name := gsub(">", " meer dan ", variable_name)]
hdng[, variable_name := gsub("<", " minder dan ", variable_name)]
hdng[, variable_name := gsub("/", " en ", variable_name)]
hdng[, variable_name := gsub("\\(|)","", variable_name)]
hdng[, variable_name := stringi::stri_trans_general(variable_name, "latin-ascii")]
hdng[, NAAM := stringi::stri_trans_general(NAAM, "latin-ascii")]
hdng[, NAAM := gsub("'", "", NAAM)]
hdng[, NAAM := gsub(" ", "_", NAAM)]
hdng[, NAAM := gsub(",", "_", NAAM)]

# seperate gemeenten and provinces

hdng_gemeenten <- hdng[!is.na(ACODE),]

hdng_provincies <- hdng[is.na(ACODE),]

# add zeroes to CBSNR (padding does not work in Python 3 yet)

hdng_gemeenten[, CBSNR := stringr::str_pad(CBSNR, 4, side = c("left"), pad = "0")]

# get working short version 

hdng_gemeenten_short <- hdng_gemeenten[,dplyr::sample_n(hdng_gemeenten, 10000)]

# write csv

fwrite(hdng_gemeenten_short, 
       "C:\\Users\\Ruben\\Documents\\02. Werk\\Clariah\\HDNG\\hdng_gemeenten_short.csv", 
       sep=";", row.names = FALSE, na = "", quote = TRUE)

fwrite(hdng_gemeenten, 
       "C:\\Users\\Ruben\\Documents\\02. Werk\\Clariah\\HDNG\\hdng_gemeenten.csv", 
       sep=";", row.names = FALSE, na = "", quote = TRUE)

fwrite(hdng_provincies, 
       "C:\\Users\\Ruben\\Documents\\02. Werk\\Clariah\\HDNG\\hdng_provincies.csv", 
       sep=";", row.names = FALSE, na = "", quote = TRUE)


### misc. ###


# seperate variable name to check unicode issues

hdng_vname <- hdng_gemeenten[,c(13, 14, 15, 16)]
hdng_vname <- hdng_vname[, .N, list(remark_1, remark_2, remark_3, remark_4)]

fwrite(hdng_vname, 
              "C:\\Users\\Ruben\\Documents\\02. Werk\\Clariah\\HDNG\\hdng_vname.csv", 
               sep=";", row.names = FALSE, na = "", quote = TRUE)



