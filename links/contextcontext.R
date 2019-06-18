# LINKSLINKSLINKS
# context(location) code to names

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

con = data.table::fread("gunzip -c CONTEXT_CONTEXT.txt.gz")
con_graph_names = cower:::graph_names(
    cower:::hash_file("CONTEXT_CONTEXT.txt.gz")["short"], 
    base = base
)

con[, .N, by = Type]
con[, .N, by = Value][order(N)]
con[!is.na(Year)] # no dates, ever
                  # which makes sense

con[, Id_C := stri_replace_all_fixed(Id_C, ",00", "")]
con[, Id_C := uriref(Id_C, stri_join(..base, "location/"))]
# should this be "context"? At least be consistent with 

out = con[Type == "LEVEL", .(
    sub = Id_C,
    pred = uriref("type", namespaces("rdf")),
    obj = uriref(Value, ..base),
    graph = con_graph_names['assertion']
    )]
nqwrite(dat = out[complete.cases(out)], 
    nquadpath = "CONTEXT_CONTEXT.txt.nq.gz",
    append = FALSE)

out = con[Type == "NAME", .(
    sub = Id_C,
    pred = uriref("prefLabel", namespaces("skos")),
    obj = literal(Value, data = uriref("string", namespaces("xsd"))),
    graph = con_graph_names['assertion']
    )]
nqwrite(dat = out[complete.cases(out)], 
    nquadpath = "CONTEXT_CONTEXT.txt.nq.gz",
    append = TRUE)

# though municipality names are not unique
out = con[Type == "NAME", .(
    sub = Id_C,
    pred = uriref("exactMatch", namespaces("skos")),
    obj = uriref(Value, base = "http://www.gemeentegeschiedenis.nl/gemeentenaam/"),
    graph = con_graph_names['assertion']
)]
nqwrite(dat = out[complete.cases(out)], 
    nquadpath = "CONTEXT_CONTEXT.txt.nq.gz",
    append = TRUE)
