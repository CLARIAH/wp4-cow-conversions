rm(list = ls())

library("data.table")

bevdynap = data.table::fread("gunzip -c /Users/auke/repos/sdh-private-hsn/hsndbf/BEVDYNAP.DBF.csv.gz")
setnames(bevdynap, names(bevdynap), tolower(names(bevdynap)))

bevdynap[, person := paste0(idnr, '_', persnr)]

rel2head = bevdynap[dynatype == 1]
rel2op = bevdynap[dynatype == 4]

rel2head[, 
    households_head := unique(person[relacode %in% c(1, 105:107, 111:120)]), 
    by = list(idnr, huishnr)]
rel2head[is.na(households_head), unique(dynainhd)]

rel2head[relacode %in% c(3:4),
    list(child = person, "childOf", parent = households_head)]
rel2head[relacode %in% c(11, 21),
    list(child = households_head, "childOf", parent = person)]
rel2head[relacode %in% c(12, 22),
    list(sibling1 = households_head, "siblingOf", sibling2 = person)]

rel2op[, 
    op := first(person[relacode %in% 997:999]),
    by = list(idnr, huishnr)]

rel2op[relacode %in% c(3, 4),
    list(child = person, "childOf", parent = op)]
rel2op[relacode %in% c(11, 21),
    list(parent = op, "childOf", child = person)]
rel2op[relacode %in% c(12, 22),
    list(op, "siblingOf", sibling = person)]

# probably easiest to also do the reverse in the data itself

# also do: 
    # spouseOf (but is actually time limited)
    # parentOf
    # grandchildOf
    # grandparentOf
    # livesWith (so everyone x everyone )