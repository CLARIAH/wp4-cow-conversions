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


ind_graph_names = cower:::graph_names(cower:::hash_file("INDIV_INDIV.txt.gz")["short"], 
    base = base)

indind = data.table::fread("gunzip -c INDIV_INDIV.txt.gz")

# all dates are exact

# fix commas in ID
indind[, Id_I_1 := stri_replace_all_fixed(Id_I_1, ",00", "")]
indind[, Id_I_2 := stri_replace_all_fixed(Id_I_2, ",00", "")]
indind[, Id_I_1 := uriref(Id_I_1, ..pers_base)]
indind[, Id_I_2 := uriref(Id_I_2, ..pers_base)]

# make date
indind[, date := stri_join(Year, "-",
    stri_pad_left(Month, width = 2, pad = 0), "-",
    stri_pad_left(Day, width = 2, pad = 0))]

# create direct links
out = indind[, .(
    sub = Id_I_2, # nb: 2 comes first because IDS uses reverse
    pred = uriref(Relation, base = dim_base),
    obj = Id_I_1,
    graph = ind_graph_names['assertion']
)]
nqwrite(dat = out[complete.cases(out)], 
    nquadpath = "indiv_indiv.txt.nq.gz",
    append = FALSE)
# are the reverse links also present? My feeling is yes

# create indirect links with a linknode
out = indind[, .(
    sub = Id_I_2,
    pred = uriref("relation", base = dim_base),
    obj = uriref(ID, base = stri_join(base, "relation/")),
    graph = ind_graph_names['assertion']
)]
nqwrite(dat = out[complete.cases(out)], 
    nquadpath = "indiv_indiv.txt.nq.gz",
    append = TRUE)
out = indind[, .(
    sub = Id_I_1,
    pred = uriref("relation", base = dim_base),
    obj = uriref(ID, base = stri_join(base, "relation/")),
    graph = ind_graph_names['assertion']
)]
nqwrite(dat = out[complete.cases(out)], 
    nquadpath = "indiv_indiv.txt.nq.gz",
    append = TRUE)

# and attach all extra info to that link node
out = indind[, .(
    sub = uriref(ID, base = rel_base),
    pred = uriref("Relation", dim_base),
    obj = uriref(Relation, base = code_base),
    graph = ind_graph_names['assertion']
)]
nqwrite(dat = out[complete.cases(out)], 
    nquadpath = "indiv_indiv.txt.nq.gz",
    append = TRUE)

out = indind[, .(
    sub = uriref(ID, base = rel_base),
    pred = uriref("Date_type", dim_base),
    obj = uriref(Date_type, base = code_base),
    graph = ind_graph_names['assertion']
)]
nqwrite(dat = out[complete.cases(out)], 
    nquadpath = "indiv_indiv.txt.nq.gz",
    append = TRUE)

out = indind[, .(
    sub = uriref(ID, base = rel_base),
    pred = uriref("Estimation", dim_base),
    obj = uriref(Estimation, base = code_base),
    graph = ind_graph_names['assertion']
)]
nqwrite(dat = out[complete.cases(out)], 
    nquadpath = "indiv_indiv.txt.nq.gz",
    append = TRUE)

out = indind[, .(
    sub = uriref(ID, base = rel_base),
    pred = uriref("Missing", dim_base),
    obj = uriref(Missing, base = code_base),
    graph = ind_graph_names['assertion']
)]
nqwrite(dat = out[complete.cases(out)], 
    nquadpath = "indiv_indiv.txt.nq.gz",
    append = TRUE)

out = indind[, .(
    sub = uriref(ID, base = rel_base),
    pred = uriref("date", dim_base),
    obj = literal(date,datatype = uriref("", "http://www.w3.org/2001/XMLSchema#date")),
    graph = ind_graph_names['assertion']
)]
nqwrite(dat = out[complete.cases(out)], 
    nquadpath = "indiv_indiv.txt.nq.gz",
    append = TRUE)

# done