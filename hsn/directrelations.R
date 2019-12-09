rm(list = ls())

library("data.table")
library("cower")

# bevolkingsregisters

bevdynap = data.table::fread("gunzip -c /Users/auke/repos/sdh-private-hsn/hsndbf/BEVDYNAP.DBF.csv.gz")
setnames(bevdynap, names(bevdynap), tolower(names(bevdynap)))

# consistent cross-household identifier
bevdynap[, person := paste0(idnr, '_', persnr)]

rel2head = bevdynap[dynatype == 1]
rel2op = bevdynap[dynatype == 4]

# using first() because there are 22 cases where there's a second head in the hh
# this seems unrelated to the first household
rel2head[, 
    household_head := first(person[relacode %in% c(1, 105:107, 111:120)]), 
    by = list(idnr, huishnr)]

rel2op[, 
    op := first(person[relacode %in% 997:999]),
    by = list(idnr, huishnr)]

bevlist_head = list(
    rel2head[relacode %in% c(3:4), # zoon/dochter
        list(child = person, "childOf", parent = household_head)],
    rel2head[relacode %in% c(3:4), # contains missing values because head not always present
        list(parent = household_head, "parentOf", child = person)],
    rel2head[relacode %in% c(11, 21), # vader/moder
        list(child = household_head, "childOf", parent = person)],
    rel2head[relacode %in% c(11, 21),
        list(parent = person, "parentOf", child = household_head)],
    rel2head[relacode %in% c(30, 40), # kleinzoon/dochter
        list(grandchild = person, "grandChildOf", grandparent = household_head)],
    rel2head[relacode %in% c(30, 40),
        list(grandparent = household_head, "grandParentOf", grandchild = person)],
    rel2head[relacode %in% c(10, 20), # grootvader/grootmoeder
        list(grandchild = household_head, "grandChildOf", grandparent = person)],
    rel2head[relacode %in% c(10, 20),
        list(parent = person, "grandParentOf", child = household_head)],
    rel2head[relacode %in% c(12, 22), # broer/zus
        list(sibling1 = household_head, "siblingOf", sibling2 = person)],
    rel2head[relacode %in% c(12, 22), # broer/zus
        list(sibling1 = person, "siblingOf", sibling2 = household_head)])


bevlist_op = list(
    rel2op[relacode %in% c(3, 4),
        list(child = person, "childOf", parent = op)],
    rel2op[relacode %in% c(3, 4),
        list(parent = op, "parentOf", child = person)],
    rel2op[relacode %in% c(30, 40),
        list(child = person, "grandChildOf", parent = op)],
    rel2op[relacode %in% c(30, 40),
        list(parent = op, "grandParentOf", child = person)],
    rel2op[relacode %in% c(11, 21),
        list(parent = op, "childOf", child = person)],
    rel2op[relacode %in% c(11, 21),
        list(child = person, "parentOf", parent = op)],
    rel2op[relacode %in% c(10, 20),
        list(parent = op, "grandChildOf", child = person)],
    rel2op[relacode %in% c(10, 20),
        list(child = person, "grandParentOf", parent = op)],
    rel2op[relacode %in% c(12, 22),
        list(sibling1 = op, "siblingOf", sibling2 = person)],
    rel2op[relacode %in% c(12, 22),
        list(sibling1 = person, "siblingOf", sibling2 = op)])

# add spouseOf (but is actually time limited)
# livesWith (so everyone x everyone in hh?)

# persoonskaarten

pkdyn = fread("~/repos/sdh-private-hsn/hsndbf/PKDYNAP.DBF.csv")
setnames(pkdyn, names(pkdyn), tolower(names(pkdyn)))

# consistent cross-household identifier
pkdyn[, person := paste0(idnr, '_', persnr)]

# pk does not have relacode, fix
pkdyn[, relacode := stringi::stri_extract_first_regex(dynainhd, "-?\\d+")]
pkdyn[, relacode := as.numeric(relacode)]

rel2head = pkdyn[dynatype == 1]
rel2op = pkdyn[dynatype == 4]

rel2head[, 
    household_head := first(person[relacode %in% c(1)]), 
    by = list(idnr, famvbnr)]

rel2op[, 
    op := first(person[relacode %in% 997:999]),
    by = list(idnr, famvbnr)]

pklist_head = list(
    rel2head[relacode %in% c(3:4),
        list(child = person, "childOf", parent = household_head)],
    rel2head[relacode %in% c(3:4),
        list(parent = household_head, "parentOf", child = person)],
    rel2head[relacode %in% c(30, 40),
        list(child = person, "grandChildOf", parent = household_head)],
    rel2head[relacode %in% c(30, 40),
        list(parent = household_head, "grandParentOf", child = person)],
    rel2head[relacode %in% c(11, 21),
        list(child = household_head, "childOf", parent = person)],
    rel2head[relacode %in% c(11, 21),
        list(parent = person, "parentOf", child = household_head)],
    rel2head[relacode %in% c(10, 20),
        list(child = household_head, "grandChildOf", parent = person)],
    rel2head[relacode %in% c(10, 20),
        list(parent = person, "grandParentOf", child = household_head)],
    rel2head[relacode %in% c(12, 22),
        list(sibling1 = household_head, "siblingOf", sibling2 = person)],
    rel2head[relacode %in% c(12, 22),
        list(sibling1 = person, "siblingOf", sibling2 = household_head)])

pklist_op = list(
    rel2op[relacode %in% c(3, 4),
        list(child = person, "childOf", parent = op)],
    rel2op[relacode %in% c(3, 4),
        list(parent = op, "parentOf", child = person)],
    rel2op[relacode %in% c(30, 40),
        list(child = person, "grandChildOf", parent = op)],
    rel2op[relacode %in% c(30, 40),
        list(parent = op, "grandParentOf", child = person)],
    rel2op[relacode %in% c(11, 21),
        list(parent = op, "childOf", child = person)],
    rel2op[relacode %in% c(11, 21),
        list(child = person, "parentOf", parent = op)],
    rel2op[relacode %in% c(10, 20),
        list(parent = op, "grandChildOf", child = person)],
    rel2op[relacode %in% c(10, 20),
        list(child = person, "grandParentOf", parent = op)],
    rel2op[relacode %in% c(12, 22),
        list(sibling1 = op, "siblingOf", sibling2 = person)],
    rel2op[relacode %in% c(12, 22),
        list(sibling1 = person, "siblingOf", sibling2 = op)])

bev_op = rbindlist(bevlist_op, use.names = FALSE)
bev_head = rbindlist(bevlist_head, use.names = FALSE)
pk_op = rbindlist(pklist_op, use.names = FALSE)
pk_head = rbindlist(pklist_head, use.names = FALSE)

bev_op[, graph := uriref("direct_relations_bev_op", "https://iisg.amsterdam/hsn/")]
bev_head[, graph := uriref("direct_relations_bev_head", "https://iisg.amsterdam/hsn/")]
pk_op[, graph := uriref("direct_relations_pk_op", "https://iisg.amsterdam/hsn/")]
pk_head[, graph := uriref("direct_relations_pk_head", "https://iisg.amsterdam/hsn/")]

out = rbindlist(list(bev_op, bev_head, pk_op, pk_head))
setnames(out, names(out), c("sub", "pred", "obj", "graph"))

out[, sub := uriref(sub, "https://iisg.amsterdam/hsn/code/HSNperson/")]
out[, obj := uriref(obj, "https://iisg.amsterdam/hsn/code/HSNperson/")]
out[, pred := uriref(pred, "https://vocab.org/relationship/")]

# some missing value due to missing household heads
nqwrite(na.omit(unique(out)), 
    nquadpath = "~/repos/sdh-private-hsn/hsndbf/hsnrelations.nq.gz")
