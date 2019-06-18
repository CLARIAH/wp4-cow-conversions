# LINKSLINKSLINKS

library("devtools")
library("data.table")
library("stringi")
library("cower")

setwd("~/downloads/links_zeeland_ids")

base = "https://iisg.amsterdam/links_zeeland/"
ind_base = "https://iisg.amsterdam/links_zeeland/individualObservation/" # individualObservatino?
grp_base = "https://iisg.amsterdam/links_zeeland/observationGroup/"
dim_base = "https://iisg.amsterdam/links_zeeland/dimension/"
pers_base = "https://iisg.amsterdam/links_zeeland/person/"

ind = data.table::fread("gunzip -c INDIVIDUAL.txt.gz")
ind_graph_names = cower:::graph_names(cower:::hash_file("INDIVIDUAL.txt.gz")["short"], 
    base = base)

ind[, start_date := stri_join(Start_year, 
    stri_pad_left(Start_month, 2, "0"), 
    stri_pad_left(Start_day, 2, "0"),
    sep = '-')]
ind[, end_date := stri_join(End_year, 
    stri_pad_left(End_month, 2, "0"), 
    stri_pad_left(End_day, 2, "0"),
    sep = '-')]
ind[, Date := stri_join(Year, 
    stri_pad_left(Month, 2, "0"), 
    stri_pad_left(Day, 2, "0"),
    sep = '-')]

# Start/end year/month/day used, possible specify a proper range?
# try it and see if sparql supports it in a nice way
# alternatively

ind[is.na(start_date), start_date := Date]
ind[is.na(end_date), end_date := Date]
# names start_date/end_date not very good because it's not a duration, it's an uncertain event

# ID numbers have ,00 values
# access was sent from hell to make us miserable
ind[, group := uriref(stri_join(Id_I, "_", start_date), base = ..grp_base)]
ind[, Id_I := stri_replace_all_fixed(Id_I, ",00", "")]
ind[, Value_Id_C := stri_replace_all_fixed(Value_Id_C, ",00", "")]

# Id_D, source, missing: always empty variables so ignore


ind[, .N, by = .(Value, Type)]
ind[Type == "SEX", Value := uriref(Value, stri_join(..ind_base, "sex/"))]
# also sdmxdim:sex sdmxcode:sex-M sex-V

ind[Type == "CIVIL_STATUS", Value := uriref(Value, stri_join(..ind_base, "civilStatus/"))]
ind[Type %in% c("BIRTH_LOCATION", "STILLBIRTH_LOCATION", "DEATH_LOCATION", "MARRIAGE_LOCATION"),
    Value := uriref(Value_Id_C, stri_join(..base, "location/"))]
# todo: these locations should also be used in the other ids stuff

ind[, ID := uriref(ID, ..ind_base)]
ind[, Id_I := uriref(Id_I, ..pers_base)]

# that many bnodes wouuld take about a minute
# ind[Type %in% c("BIRTH_DATE", "STILLBIRTH_DATE", "MARRIAGE_DATE", "DEATH_DATE"), 
    # Value := .(bnode(.N))]
#     literal(Value_Id_C, datatype = xsd$date)]
# think of some way to accomodate ranges?
# reason to use bnodes was that it is now unclear to what a date now belongs
# e.g. indobs Birthlocation birthloc; indobs date date
# whereas it might be clearer to have indobs birth birthobs; birhtobs birthloc; birthobs birhdate

# ind to indObs
out = ind[, .(
    sub = Id_I,
    pred = uriref("individualObservation", base = ..dim_base),
    obj = ID, # or maybe this should be constructed out of date + indiv + group count
    graph = ind_graph_names['assertion']
)]
nqwrite(dat = out, 
    nquadpath = "individual.txt.nq.gz",
    append = FALSE)

# indObs to uriref value
out = ind[, .(
    sub = ID,
    pred = uriref(Type, ..dim_base),
    obj = Value,
    graph = ind_graph_names['assertion']
)]
nqwrite(dat = out[obj != ""], 
    nquadpath = "individual.txt.nq.gz",
    append = TRUE)

# indObs to date, always make sure there is lower/upper date
    # date if date
    # startdate if startdate|date
    # enddate if enddate|date
out = ind[, .(
    sub = ID,
    pred = uriref("date", ..dim_base),
    obj = literal(Date, datatype = uriref("date", namespaces("xsd"))),
    graph = ind_graph_names['assertion']
)]
nqwrite(dat = out[!is.na(obj)], 
    nquadpath = "individual.txt.nq.gz",
    append = TRUE)

out = ind[, .(
    sub = ID,
    pred = uriref("dateLower", ..dim_base),
    obj = literal(start_date, datatype = uriref("date", namespaces("xsd"))),
    graph = ind_graph_names['assertion']
)]
nqwrite(dat = out[!is.na(obj)], 
    nquadpath = "individual.txt.nq.gz",
    append = TRUE)

out = ind[, .(
    sub = ID,
    pred = uriref("dateUpper", ..dim_base),
    obj = literal(end_date, datatype = uriref("date", namespaces("xsd"))),
    graph = ind_graph_names['assertion']
)]
nqwrite(dat = out[!is.na(obj)], 
    nquadpath = "individual.txt.nq.gz",
    append = TRUE)

# done except the group stuff!
# id inObservationGroup group
# group groupedObservations id
# where group is person + date / person + start/end date


out = ind[!is.na(start_date), .(
    sub = Id_I,
    pred = uriref("hasObservationGroup", ..dim_base),
    obj = group,
    graph = ind_graph_names['assertion']
    )]
nqwrite(dat = out[!is.na(obj)], 
    nquadpath = "individual.txt.nq.gz",
    append = TRUE)

out = ind[!is.na(start_date), .(
    sub = group,
    pred = uriref("groupedObservations", ..dim_base),
    obj = ID,
    graph = ind_graph_names['assertion']
    )]
nqwrite(dat = out[!is.na(obj)], 
    nquadpath = "individual.txt.nq.gz",
    append = TRUE)

# time invariant observations direct to person?
# would have to have separate predicate
