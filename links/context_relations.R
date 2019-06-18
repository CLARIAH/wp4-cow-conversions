# LINKSLINKSLINKS

library("devtools")
library("data.table")
library("stringi")
library("cower")

setwd("~/downloads/links_zeeland_ids")

base = "https://iisg.amsterdam/links_zeeland/"
ind_base = "https://iisg.amsterdam/links_zeeland/individualObservation/" # individualObservatino?
pers_base = "https://iisg.amsterdam/links_zeeland/person/"
dim_base = "https://iisg.amsterdam/links_zeeland/dimension/"
rel_base = "https://iisg.amsterdam/links_zeeland/relation/"
code_base = "https://iisg.amsterdam/links_zeeland/code/"
occ_base = "https://iisg.amsterdam/links_zeeland/occupation/"

ccc = data.table::fread("gunzip -c CONTEXT_CONTEXT_CONTEXT.txt.gz")
ccc_graph_names = cower:::graph_names(
    cower:::hash_file("CONTEXT_CONTEXT_CONTEXT.txt.gz")["short"], 
    base = base
)

ccc[, .N, by = Relation]

ccc[, Id_C_1 := stri_replace_all_fixed(Id_C_1, ",00", "")]
ccc[, Id_C_2 := stri_replace_all_fixed(Id_C_2, ",00", "")]
ccc[, Id_C_1 := uriref(Id_C_1, stri_join(..base, "location/"))]
ccc[, Id_C_2 := uriref(Id_C_2, stri_join(..base, "location/"))]

out = ccc[, .(
    sub = Id_C_1,
    pred = uriref("broader", namespaces("skos")),
    obj = Id_C_2,
    graph = ccc_graph_names['assertion']
    )]
nqwrite(dat = out[complete.cases(out)], 
    nquadpath = "CONTEXT_CONTEXT_CONTEXT.txt.nq.gz",
    append = FALSE)

out = ccc[, .(
    sub = Id_C_2,
    pred = uriref("narrower", namespaces("skos")),
    obj = Id_C_1,
    graph = ccc_graph_names['assertion']
    )]
nqwrite(dat = out[complete.cases(out)], 
    nquadpath = "CONTEXT_CONTEXT_CONTEXT.txt.nq.gz",
    append = TRUE)

out = ccc[, .(
    sub = Id_C_1,
    pred = uriref("inProvince", "http://www.gemeentegeschiedenis.nl/gg-schema#"),
    obj = Id_C_2,
    graph = ccc_graph_names['assertion']
    )]
nqwrite(dat = out[complete.cases(out)], 
    nquadpath = "CONTEXT_CONTEXT_CONTEXT.txt.nq.gz",
    append = TRUE)

out = ccc[, .(
    sub = Id_C_2,
    pred = uriref("municipalityIn", "http://www.gemeentegeschiedenis.nl/gg-schema#"),
    obj = Id_C_1,
    graph = ccc_graph_names['assertion']
    )]
nqwrite(dat = out[complete.cases(out)], 
    nquadpath = "CONTEXT_CONTEXT_CONTEXT.txt.nq.gz",
    append = TRUE)
