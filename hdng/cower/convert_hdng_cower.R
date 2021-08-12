rm(list = ls())

library("devtools")
library("data.table")

 #devtools::install_github("rijpma/cower") # upgrade_dependencies = FALSE ?
 devtools::install_github("rijpma/cower",  upgrade_dependencies = FALSE)

library("cower")
# issues: vectorize input?
# no %-encoding somehow? would need a full working character set of things to replace
# 
# devtools::load_all("~/repos/cower", export_all = FALSE)
# devtools::load_all("~/repos/cower")

# devtools::document("~/repos/cower")

# still uses data... for hsn:
# and for dim?
# hsn_person -> OP seems broken
# add adres


# cower does not put the filename or anything in the graph name

cower(csv_path = "C:\\Users\\Ruben\\Documents\\02. Werk\\Clariah\\HDNG\\hdng_gemeenten_short_cower.csv",
      json_path = "C:\\Users\\Ruben\\Documents\\02. Werk\\Clariah\\HDNG\\hdng_gemeenten_short_cower.csv-metadata.json",
      nquad_path = "C:\\Users\\Ruben\\Documents\\02. Werk\\Clariah\\HDNG\\hdng_gemeenten_short_cower.csv.nq.gz",
      compress = TRUE,
      batch_size = 5e5)
