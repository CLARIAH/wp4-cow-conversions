rm(list = ls())

library("devtools")
library("data.table")

# devtools::install_github("rijpma/cower") # upgrade_dependencies = FALSE ?
# devtools::install_github("rijpma/cower",  upgrade_dependencies = FALSE)

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

cower(csv_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/VERNUM.csv",
    json_path = "/Users/auke/repos/wp4-cow-conversions/hsn/cower/VERNUM.csv-metadata-cower.json",
    nquad_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/VERNUM.csv.nq.gz",
    compress = TRUE,
    batch_size = 5e5)

cower(csv_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/TOESTEM.csv",
    json_path = "/Users/auke/repos/wp4-cow-conversions/hsn/cower/TOESTEM.csv-metadata-cower.json",
    nquad_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/TOESTEM.csv.nq.gz",
    compress = TRUE,
    batch_size = 5e5)

cower(csv_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/SEX_OP.csv",
    json_path = "/Users/auke/repos/wp4-cow-conversions/hsn/cower/SEX_OP.csv-metadata-cower.json",
    nquad_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/SEX_OP.csv.nq.gz",
    compress = TRUE,
    batch_size = 5e5)
# should include other sex codes

cower(csv_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/RELIGIEBRON.csv",
    json_path = "/Users/auke/repos/wp4-cow-conversions/hsn/cower/RELIGIEBRON.csv-metadata-cower.json",
    nquad_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/RELIGIEBRON.csv.nq.gz",
    compress = TRUE,
    batch_size = 5e5)

cower(csv_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/RELIGIEBRON.csv",
    json_path = "/Users/auke/repos/wp4-cow-conversions/hsn/cower/RELIGIEBRON.csv-metadata-cower.json",
    nquad_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/RELIGIEBRON.csv.nq.gz",
    compress = TRUE,
    batch_size = 5e5)

cower(csv_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/RELATOTWIE.csv",
    json_path = "/Users/auke/repos/wp4-cow-conversions/hsn/cower/RELATOTWIE.csv-metadata-cower.json",
    nquad_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/RELATOTWIE.csv.nq.gz",
    compress = TRUE,
    batch_size = 5e5)

cower(csv_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/RELACODE.csv",
    json_path = "/Users/auke/repos/wp4-cow-conversions/hsn/cower/RELACODE.csv-metadata-cower.json",
    nquad_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/RELACODE.csv.nq.gz",
    compress = TRUE,
    batch_size = 5e5)

cower(csv_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/PKSTATP.DBF.csv",
    json_path = "/Users/auke/repos/wp4-cow-conversions/hsn/cower/PKSTATP.DBF.csv-metadata-cower.json",
    nquad_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/PKSTATP.DBF.csv.nq.gz",
    compress = TRUE,
    batch_size = 5e5)

cower(csv_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/PKDYNAP.DBF.csv",
    json_path = "/Users/auke/repos/wp4-cow-conversions/hsn/cower/PKDYNAP.DBF.csv-metadata-cower.json",
    nquad_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/PKDYNAP.DBF.csv.nq.gz",
    compress = TRUE,
    batch_size = 5e5)
# NA introduction warning due to as.integer on non-numeric  characters

cower(csv_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/PKBRON.DBF.csv",
    json_path = "/Users/auke/repos/wp4-cow-conversions/hsn/cower/PKBRON.DBF.csv-metadata-cower.json",
    nquad_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/PKBRON.DBF.csv.nq.gz",
    compress = TRUE, 
    batch_size = 1e6)

# graph names lack /hsn/
cower(csv_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/PKFAMVB.DBF.csv",
    json_path = "/Users/auke/repos/wp4-cow-conversions/hsn/cower/PKFAMVB.DBF.csv-metadata-cower.json",
    nquad_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/PKFAMVB.DBF.csv.nq.gz",
    compress = TRUE, 
    batch_size = 1e6)

cower(csv_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/PKADR.DBF.csv",
    json_path = "/Users/auke/repos/wp4-cow-conversions/hsn/cower/PKADR.DBF.csv-metadata-cower.json",
    nquad_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/PKADR.DBF.csv.nq.gz",
    compress = TRUE, 
    batch_size = 1e6)

# don't have csv
cower(csv_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/PERSNRMX.csv",
    json_path = "/Users/auke/repos/wp4-cow-conversions/hsn/cower/PERSNRMX.csv-metadata-cower.json",
    nquad_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/PERSNRMX.csv.nq.gz",
    compress = TRUE, 
    batch_size = 1e6)

cower(csv_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/OVLDATBR.csv",
    json_path = "/Users/auke/repos/wp4-cow-conversions/hsn/cower/OVLDATBR.csv-metadata-cower.json",
    nquad_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/OVLDATBR.csv.nq.gz",
    compress = TRUE, 
    batch_size = 1e6)

cower(csv_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/LEVOUDER.csv",
    json_path = "/Users/auke/repos/wp4-cow-conversions/hsn/cower/LEVOUDER.csv-metadata-cower.json",
    nquad_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/LEVOUDER.csv.nq.gz",
    compress = TRUE, 
    batch_size = 1e6)

cower(csv_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/Kerkgenootschap.csv",
    json_path = "/Users/auke/repos/wp4-cow-conversions/hsn/cower/Kerkgenootschap.csv-metadata-cower.json",
    nquad_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/Kerkgenootschap.csv.nq.gz",
    compress = TRUE, 
    batch_size = 1e6)

# maybe relatype needs to be worked out
cower(csv_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/HUWPERS.DBF.csv",
    json_path = "/Users/auke/repos/wp4-cow-conversions/hsn/cower/HUWPERS.DBF.csv-metadata-cower.json",
    nquad_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/HUWPERS.DBF.csv.nq.gz",
    compress = TRUE, 
    batch_size = 1e6)

cower(csv_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/HUWAKTE.DBF.csv",
    json_path = "/Users/auke/repos/wp4-cow-conversions/hsn/cower/HUWAKTE.DBF.csv-metadata-cower.json",
    nquad_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/HUWAKTE.DBF.csv.nq.gz",
    compress = TRUE, 
    batch_size = 1e6)

cower(csv_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/HUWAFKON.DBF.csv",
    json_path = "/Users/auke/repos/wp4-cow-conversions/hsn/cower/HUWAFKON.DBF.csv-metadata-cower.json",
    nquad_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/HUWAFKON.DBF.csv.nq.gz",
    compress = TRUE, 
    batch_size = 1e6)
# hsndim wrong
# basically hasn't been done yet, might hold for other 

cower(csv_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/HANDTEK.csv",
    json_path = "/Users/auke/repos/wp4-cow-conversions/hsn/cower/HANDTEK.csv-metadata-cower.json",
    nquad_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/HANDTEK.csv.nq.gz",
    compress = TRUE, 
    batch_size = 1e6)

cower(csv_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/GESLACHT.csv",
    json_path = "/Users/auke/repos/wp4-cow-conversions/hsn/cower/GESLACHT.csv-metadata-cower.json",
    nquad_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/GESLACHT.csv.nq.gz",
    compress = TRUE, 
    batch_size = 1e6)

cower(csv_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/gemeenten.csv",
    json_path = "/Users/auke/repos/wp4-cow-conversions/hsn/cower/gemeenten.csv-metadata-cower.json",
    nquad_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/gemeenten.csv.nq.gz",
    compress = TRUE, 
    batch_size = 1e6)

cower(csv_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/GEEN_OP.csv",
    json_path = "/Users/auke/repos/wp4-cow-conversions/hsn/cower/GEEN_OP.csv-metadata-cower.json",
    nquad_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/GEEN_OP.csv.nq.gz",
    compress = TRUE, 
    batch_size = 1e6)

cower(csv_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/FUNCTIE.csv",
    json_path = "/Users/auke/repos/wp4-cow-conversions/hsn/cower/FUNCTIE.csv-metadata-cower.json",
    nquad_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/FUNCTIE.csv.nq.gz",
    compress = TRUE, 
    batch_size = 1e6)

cower(csv_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/FAMNAAM.csv",
    json_path = "/Users/auke/repos/wp4-cow-conversions/hsn/cower/FAMNAAM.csv-metadata-cower.json",
    nquad_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/FAMNAAM.csv.nq.gz",
    compress = TRUE, 
    batch_size = 1e6)

cower(csv_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/EINDEHUW.csv",
    json_path = "/Users/auke/repos/wp4-cow-conversions/hsn/cower/EINDEHUW.csv-metadata-cower.json",
    nquad_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/EINDEHUW.csv.nq.gz",
    compress = TRUE, 
    batch_size = 1e6)

cower(csv_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/DYNATYPE.csv",
    json_path = "/Users/auke/repos/wp4-cow-conversions/hsn/cower/DYNATYPE.csv-metadata-cower.json",
    nquad_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/DYNATYPE.csv.nq.gz",
    compress = TRUE, 
    batch_size = 1e6)

cower(csv_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/BURGSTAAT.csv",
    json_path = "/Users/auke/repos/wp4-cow-conversions/hsn/cower/BURGSTAAT.csv-metadata-cower.json",
    nquad_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/BURGSTAAT.csv.nq.gz",
    compress = TRUE, 
    batch_size = 1e6)

cower(csv_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/BRONTYPE.csv",
    json_path = "/Users/auke/repos/wp4-cow-conversions/hsn/cower/BRONTYPE.csv-metadata-cower.json",
    nquad_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/BRONTYPE.csv.nq.gz",
    compress = TRUE, 
    batch_size = 1e6)

# data.table::fread("/Users/auke/repos/sdh-private-hsn/hsndbf/BEVOP.DBF.csv")

cower(csv_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/BEVOP.DBF.csv",
    json_path = "/Users/auke/repos/wp4-cow-conversions/hsn/cower/BEVOP.DBF.csv-metadata-cower.json",
    nquad_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/BEVOP.DBF.csv.nq.gz",
    compress = TRUE, 
    batch_size = 1e6)

cower(csv_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/BEVOBS.DBF.csv",
    json_path = "/Users/auke/repos/wp4-cow-conversions/hsn/cower/BEVOBS.DBF.csv-metadata-cower.json",
    nquad_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/BEVOBS.DBF.csv.nq.gz",
    compress = TRUE, 
    batch_size = 1e6)

cower(csv_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/BEVHUISH.DBF.csv",
    json_path = "/Users/auke/repos/wp4-cow-conversions/hsn/cower/BEVHUISH.DBF.csv-metadata-cower.json",
    nquad_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/BEVHUISH.DBF.csv.nq.gz",
    compress = TRUE, 
    batch_size = 1e6)

cower(csv_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/BEVBRON.DBF.csv",
    json_path = "/Users/auke/repos/wp4-cow-conversions/hsn/cower/BEVBRON.DBF.csv-metadata-cower.json",
    nquad_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/BEVBRON.DBF.csv.nq.gz",
    compress = TRUE, 
    batch_size = 1e6)

cower(csv_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/BEVSTATP.DBF.csv",
    json_path = "/Users/auke/repos/wp4-cow-conversions/hsn/cower/BEVSTATP.DBF.csv-metadata-cower.json",
    nquad_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/BEVSTATP.DBF.csv.nq.gz",
    compress = TRUE, 
    batch_size = 1e6)
# here hsn:OP refers to idnrhsp, elsewhere hsnperson

cower(csv_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/BEVADRES.DBF.csv",
    json_path = "/Users/auke/repos/wp4-cow-conversions/hsn/cower/BEVADRES.DBF.csv-metadata-cower.json",
    nquad_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/BEVADRES.DBF.csv.nq.gz",
    compress = TRUE, 
    batch_size = 1e6)
# bevadres/row hsndim:HSNperson hsnperson does not really make sense here

cower(csv_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/BEVDYNAP.DBF.csv",
    json_path = "/Users/auke/repos/wp4-cow-conversions/hsn/cower/BEVDYNAP.DBF.csv-metadata-cower.json",
    nquad_path = "/Users/auke/repos/sdh-private-hsn/hsndbf/BEVDYNAP.DBF.csv.nq.gz",
    compress = TRUE,
    batch_size = 1e6)

# bd = read_rdf("/Users/auke/repos/sdh-private-hsn/hsndbf/BEVDYNAP.DBF.csv.nq.gz", type = 'nquads')
# bd[obj == "<https://iisg.amsterdam/hsn/OP>", unique(sub)]

# makes some 400k unique OPs, very weird
# could be that relacode NAs are taken on board or something?
# try to put @id in the metadata
# check if bases are done correctly
# shared date-observation nodes somehow
