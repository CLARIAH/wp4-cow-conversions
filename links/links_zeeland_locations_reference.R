# get list to map LINKS Zeeland locations to HSN/LINKS Standardized locations


####

locs <- fread("C:\\Users\\Ruben\\Documents\\02. Werk\\Clariah\\LINKS\\REF_LOCATION_Locatie_Werkbestand_2019_02_12.txt")

locs[grepl("\\'s-$", Municipality), Municipality_2 := paste0("'s-", Municipality), ]

locs[grepl("\\'s-$", Municipality), Municipality_2 := gsub('.{4}$', '', Municipality_2),]

locs <- locs[!is.na(Municipality) & Municipality != "",]

locs2 <- locs[,c("Location_no","Location", "Municipality", "Municipality_2", "Province", "Region", "Country")]

locs2 <- locs2[!duplicated(locs2),][order(Location_no)]

locs2[!is.na(Municipality_2), Municipality := Municipality_2, ]

locs2$Municipality_2 <- NULL

fwrite(locs2, "C:\\Users\\Ruben\\Documents\\02. Werk\\Clariah\\LINKS\\REF_LOCATION_2019_02_12_v2.csv" )

