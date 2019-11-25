rm(list = ls())

library("data.table")
library("cower") # remotes::install_github("rijpma/cower")

base = "https://iisg.amsterdam/links_zeeland/"

persons = fread("~/Downloads/Zeeland_Challenge/LINKS_Zeeland_cleaned_2016_01_csv_files/LINKS_Zeeland_cleaned_2016_01_Persons.csv")

parent_child_from_births = merge(
    persons[registration_maintype == 1 & role %in% c(1), 
        list(newborn = id_person, id_registration)],
    persons[registration_maintype == 1 & role %in% c(2, 3), 
        list(parent = id_person, id_registration)],
    all = TRUE,
    by = "id_registration")

parent_child_from_brides = merge(
    persons[registration_maintype == 2 & role %in% c(4), 
        list(bride_or_groom = id_person, id_registration)],
    persons[registration_maintype == 2 & role %in% c(5:6), 
        list(parent = id_person, id_registration)],
    all = TRUE, allow.cartesian = TRUE,
    by = "id_registration")

parent_child_from_grooms = merge(
    persons[registration_maintype == 2 & role %in% c(7), 
        list(bride_or_groom = id_person, id_registration)],
    persons[registration_maintype == 2 & role %in% c(8:9), 
        list(parent = id_person, id_registration)],
    all = TRUE, allow.cartesian = TRUE,
    by = "id_registration")

# maybe fix this in all = ?
parent_child_from_births = na.omit(parent_child_from_births)
parent_child_from_brides = na.omit(parent_child_from_brides)
parent_child_from_grooms = na.omit(parent_child_from_grooms)

parent_child_from_brides = parent_child_from_brides[, list(
    sub = cower::uriref(bride_or_groom, base, "person/"),
    pred = cower::uriref("", "http://purl.org/vocab/relationship/childOf"),
    obj = cower::uriref(parent, base, "person/"))]
parent_child_from_grooms = parent_child_from_grooms[, list(
    sub = cower::uriref(bride_or_groom, base, "person/"),
    pred = cower::uriref("", "http://purl.org/vocab/relationship/childOf"),
    obj = cower::uriref(parent, base, "person/"))]
parent_child_from_births = parent_child_from_births[, list(
    sub = cower::uriref(newborn, base, "person/"),
    pred = cower::uriref("", "http://purl.org/vocab/relationship/childOf"),
    obj = cower::uriref(parent, base, "person/"))]

parent_child_from_brides[, graph := uriref("parent_child_from_brides", base)]
parent_child_from_grooms[, graph := uriref("parent_child_from_grooms", base)]
parent_child_from_births[, graph := uriref("parent_child_from_births", base)]

if (uniqueN(parent_child_from_brides) != nrow(parent_child_from_brides)
    | uniqueN(parent_child_from_grooms) != nrow(parent_child_from_grooms)
    | uniqueN(parent_child_from_births) != nrow(parent_child_from_births)){
    warning("duplicates")
}
if (parent_child_from_brides[, .N, by = sub][, any(N > 2)]
    | parent_child_from_grooms[, .N, by = sub][, any(N > 2)]
    | parent_child_from_births[, .N, by = sub][, any(N > 2)]){
    warning("more than two parents")
}

cower::nqwrite(
    dat = rbindlist(list(
        parent_child_from_brides,
        parent_child_from_grooms,
        parent_child_from_births)),
    nquadpath = "~/downloads/Zeeland_Challenge/persons.nq.gz",
    append = FALSE,
    compress = TRUE)