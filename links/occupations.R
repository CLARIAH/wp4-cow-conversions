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

ind_occs = data.table::fread("gunzip -c INDIVIDUAL_Occupation.txt.gz")
occ_graph_names = cower:::graph_names(
    cower:::hash_file("INDIVIDUAL_Occupation.txt.gz")["short"], 
    base = base
)

ind_occs[!is.na(Start_year)]
ind_occs[!is.na(End_year)]
ind_occs[!is.na(Missing)]

ind_occs[, Id_I := stri_replace_all_fixed(Id_I, ",00", "")]
ind_occs[, date := stri_join(Year, "-",
    stri_pad_left(Month, width = 2, pad = 0), "-",
    stri_pad_left(Day, width = 2, pad = 0))]

ind_occs[, Id_I := uriref(Id_I, ..pers_base)]
ind_occs[, ID := uriref(ID, base = occ_base)]

out = ind_occs[, .(
    sub = Id_I,
    pred = uriref("individualObservation", base = dim_base),
    obj = ID,
    graph = occ_graph_names['assertion']
)]
nqwrite(dat = out[complete.cases(out)], 
    nquadpath = "INDIVIDUAL_Occupation.txt.nq.gz",
    append = FALSE)

# occnode to
out = ind_occs[Type == "OCCUPATION_STANDARD", .(
    sub = ID,
    pred = uriref("occupationalTitle", base = dim_base),
    obj = cower::literal(Value, datatype = uriref("string", namespaces("xsd"))),
    graph = occ_graph_names['assertion']
)]
nqwrite(dat = out[complete.cases(out)], 
    nquadpath = "INDIVIDUAL_Occupation.txt.nq.gz",
    append = TRUE)

out = ind_occs[Type == "OCCUPATION_HISCO", .(
    sub = ID,
    pred = uriref("hisco", base = dim_base),
    obj = cower::uriref(Value, base = "https://iisg.amsterdam/hisco/code/hisco/"),
    graph = occ_graph_names['assertion']
)]
nqwrite(dat = out[complete.cases(out)], 
    nquadpath = "INDIVIDUAL_Occupation.txt.nq.gz",
    append = TRUE)

out = ind_occs[Type == "OCCUPATION_HISCAM_U1", .(
    sub = ID, 
    pred = uriref("u1", base = "https://iisg.amsterdam/hiscam/v131/"),
    obj = cower::literal(Value, datatype = uriref("decimal", namespaces("xsd"))),
    graph = occ_graph_names['assertion']
)]
nqwrite(dat = out[complete.cases(out)], 
    nquadpath = "INDIVIDUAL_Occupation.txt.nq.gz",
    append = TRUE)

out = ind_occs[Type == "OCCUPATION_HISCLASS", .(
    sub = ID,
    pred = uriref("hisclass", base = dim_base),
    obj = cower::uriref(Value, base = "https://iisg.amsterdam/hisclass/code/"),
    graph = occ_graph_names['assertion']
)]
nqwrite(dat = out[complete.cases(out)], 
    nquadpath = "INDIVIDUAL_Occupation.txt.nq.gz",
    append = TRUE)

out = ind_occs[Type == "OCCUPATION_SOCPO", .(
    sub = ID,
    pred = uriref("socpo", base = dim_base),
    obj = cower::uriref(Value, base = "https://iisg.amsterdam/socpo/"),
    graph = occ_graph_names['assertion']
)]
nqwrite(dat = out[complete.cases(out)], 
    nquadpath = "INDIVIDUAL_Occupation.txt.nq.gz",
    append = TRUE)

out = ind_occs[, .(
    sub = ID,
    pred = uriref("date", base = dim_base),
    obj = cower::literal(date, datatype = uriref("date", namespaces("xsd"))),
    graph = occ_graph_names['assertion']
)]
nqwrite(dat = out[complete.cases(out)], 
    nquadpath = "INDIVIDUAL_Occupation.txt.nq.gz",
    append = TRUE)
