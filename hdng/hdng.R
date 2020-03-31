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
hdng[, information := gsub("<", " minder dan ", information)]
hdng[, information := gsub("/", "of", information)]
hdng[, information := gsub(">", " meer dan ", information)]
hdng[, variable_name := stringi::stri_trans_general(variable_name, "latin-ascii")]
hdng[, information := stringi::stri_trans_general(information, "latin-ascii")]
hdng[, NAAM := stringi::stri_trans_general(NAAM, "latin-ascii")]
hdng[, NAAM := gsub("'", "", NAAM)]
hdng[, NAAM := gsub(" ", "_", NAAM)]
hdng[, NAAM := gsub(",", "_", NAAM)]

# rename variables that are not unique (VEZ1 DOO3 CHA1 & WAA1)
doubles <- hdng[, .N, list(suffix, topic)][duplicated(suffix, fromLast = FALSE)| duplicated(suffix, fromLast = TRUE ),][order(suffix)]

hdng[suffix == "CHA1" & topic == "A", suffix := "CHA1A"]
hdng[suffix == "CHA1" & topic == "C", suffix := "CHA1C"]

hdng[suffix == "DOO3" & topic == "E", suffix := "DOO3E"]
hdng[suffix == "DOO3" & topic == "C", suffix := "DOO3C"]

hdng[suffix == "VEZ1" & topic == "A", suffix := "VEZ1A"]
hdng[suffix == "VEZ1" & topic == "E", suffix := "VEZ1E"]

hdng[suffix == "WAA1" & topic == "A", suffix := "WAA1A"]
hdng[suffix == "WAA1" & topic == "C", suffix := "WAA1C"]

### also rename var name?## vermoedelijk niet:
hdng[grepl("VEZ1", suffix), list(suffix, topic, variable_name, description, information)][!duplicated(suffix, fromLast = FALSE),]
hdng[grepl("CHA1", suffix), list(suffix, topic, variable_name, description, information)][!duplicated(suffix, fromLast = FALSE),]
hdng[grepl("DOO3", suffix), list(suffix, topic, variable_name, description, information)][!duplicated(suffix, fromLast = FALSE),]
hdng[grepl("WAA1", suffix), list(suffix, topic, variable_name, description, information)][!duplicated(suffix, fromLast = FALSE),]

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


### check unicode issues by converting specific columns (solved)

hdng_vname <- hdng_gemeenten[,c(13, 14, 15, 16)]
hdng_vname <- hdng_vname[, .N, list(remark_1, remark_2, remark_3, remark_4)]

fwrite(hdng_vname, 
              "C:\\Users\\Ruben\\Documents\\02. Werk\\Clariah\\HDNG\\hdng_vname.csv", 
               sep=";", row.names = FALSE, na = "", quote = TRUE)


### post-COW-conversion steps to remove empty triples like "https://iisg.amsterdam/hdng/observation/AAGTEKERKE_" ###

# (since the abouturl is {NAAM}_{YEAR} some rows with empty years are converted like the example above, but don't have any content:
# the gemeente specific variables that are listed here (CBSNR etc.) are assinged to the gemeente level in the scheme)

library("devtools")

devtools::install_github("rijpma/cower",  upgrade_dependencies = FALSE)

library("cower")
hdng_nq <- read_rdf("hdng_gemeenten.csv.nq", type = c("nquads"))

setDT(hdng_nq)

wrongs <- hdng_nq[grepl("_>", hdng_nq$sub) & grepl("observation", hdng_nq$sub) , ]

keeps <- hdng_nq[(!grepl("_>", hdng_nq$sub) & !grepl("category", hdng_nq$sub))  , ]


nqwrite(keeps, "hdng_gemeenten2.csv.nq.gz", append = FALSE, compress = TRUE)


