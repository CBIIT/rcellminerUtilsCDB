#--------------------------------------------------------------------------------------------------
#Adding new data source: zurich 3 cell lines
#   
#--------------------------------------------------------------------------------------------------

# library(rcellminerUtilsCDB)
 
currenttable=rcellminerUtilsCDB::cellLineMatchTab
dim(currenttable) # 2097   35

## Zurich cell lines ---------------------------------
zu = c("H295R-NCI", "MUC-1", "TVBF-7") 

currenttable$zurich = NA
dim(currenttable) # 2097   36

# one existing cell line H295R-NCI
ind.h295r = match("H295R",currenttable$colorado)
currenttable$zurich[ind.h295r] = "H295R-NCI"

# 2 new cell lines: "MUC-1", "TVBF-7"

currenttable[2098:2099,] = NA
currenttable[2098:2099,"zurich"] = c("MUC-1", "TVBF-7")

currenttable[2098:2099,"cellosaurus_accession"] = c("CVCL_C4KG", "CVCL_C4KR")
currenttable[2098:2099,"cellosaurus_identifier"] = c("MUC-1", "TVBF-7")
dim(currenttable) # 2099 36
cellLineMatchTab <- currenttable

save(cellLineMatchTab, file = "data/cellLineMatchTab.RData")

## END
## stop here ----------------------





















