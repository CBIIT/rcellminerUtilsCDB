#--------------------------------------------------------------------------------------------------
#Adding 35 cellausorus ID in the cell line matching table 
#   
#--------------------------------------------------------------------------------------------------

# library(rcellminerUtilsCDB)
 
currenttable=rcellminerUtilsCDB::cellLineMatchTab
dim(currenttable) # 2106   39

## read new info ---------------------------------

new_cello = read.csv("inst/extdata/New_35_Cellausorus.csv", stringsAsFactors = F)
dim(new_cello) # 35 17

currenttable[new_cello$index,"cellosaurus_accession"] = new_cello$cellosaurus_accession
currenttable[new_cello$index,"cellosaurus_identifier"] = new_cello$cellosaurus_identifier

View(currenttable[new_cello$index,])

dim(currenttable) # 2106   39

cellLineMatchTab <- currenttable
save(cellLineMatchTab, file = "data/cellLineMatchTab.RData")

