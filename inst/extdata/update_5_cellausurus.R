#--------------------------------------------------------------------------------------------------
# update cellausurus info for 4 NCI60 cell lines
#   SR already updated
#--------------------------------------------------------------------------------------------------

# library(rcellminerUtilsCDB)
 
currenttable=rcellminerUtilsCDB::cellLineMatchTab
dim(currenttable) # 2100 38

## ---------------------------------
cells = c("ME:M14", "ME:MDA-N", "OV:NCI/ADR-RES", "PR:PC-3" )
access = c("CVCL_1395", "CVCL_1910", "CVCL_1452", "CVCL_0035")
idname = c("M14", "MDA-N", "NCI-ADR-RES ", "PC-3")

idx  = match(cells , currenttable$nci60)

currenttable$cellosaurus_accession[idx] = access
currenttable$cellosaurus_identifier[idx] = idname

currenttable$ccle[25] ## SR-786
currenttable$cellosaurus_accession[25] = NA
currenttable$cellosaurus_identifier[25] = NA
# saving

dim(currenttable) # 2100 38
cellLineMatchTab <- currenttable

save(cellLineMatchTab, file = "data/cellLineMatchTab.RData")

## END
## stop here ----------------------





















