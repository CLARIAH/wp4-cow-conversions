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

cic = data.table::fread("gunzip -c CONTEXT_INDIV_CONTEXT.txt.gz")
cic_graph_names = cower:::graph_names(
    cower:::hash_file("CONTEXT_INDIV_CONTEXT.txt.gz")["short"], 
    base = base
)

cic[!is.na(Start_year)]
cic[!is.na(End_year)]
cic[!is.na(Missing)]

cic[, .N, by = Relation]

cic[, Id_I := stri_replace_all_fixed(Id_I, ",00", "")]
cic[, Id_C := stri_replace_all_fixed(Id_C, ",00", "")]
cic[, date := stri_join(Year, "-",
    stri_pad_left(Month, width = 2, pad = 0), "-",
    stri_pad_left(Day, width = 2, pad = 0))]


cic[, Id_I := uriref(Id_I, ..pers_base)]
cic[, Id_C := uriref(Id_C, stri_join(..base, "location/"))]
cic[, ID := uriref(ID, base = stri_join(..base, "context_indiv_context/"))]

# Id_I context ID
out = cic[, .(
    sub = Id_I,
    pred = uriref("context", stri_join(..dim_base)), # better name
    obj = ID,
    graph = cic_graph_names['assertion']
)]
nqwrite(dat = out[complete.cases(out)], 
    nquadpath = "CONTEXT_INDIV_CONTEXT.txt.nq.gz",
    append = FALSE)

# ID Value + Location Id_C
out = cic[, .(
    sub = ID,
    pred = uriref(stri_join(Relation, "Location"), ..dim_base),
    obj = Id_C,
    graph = cic_graph_names['assertion']
    )]
nqwrite(dat = out[complete.cases(out)], 
    nquadpath = "CONTEXT_INDIV_CONTEXT.txt.nq.gz",
    append = TRUE)
# which of these can be made direct individual characteristics

# ID date date
out = cic[, .(
    sub = ID,
    pred = uriref("date", ..dim_base),
    obj = literal(date, datatype = uriref("date", namespaces("xsd"))),
    graph = cic_graph_names['assertion']
)]
nqwrite(dat = out[complete.cases(out)], 
    nquadpath = "CONTEXT_INDIV_CONTEXT.txt.nq.gz",
    append = TRUE)
