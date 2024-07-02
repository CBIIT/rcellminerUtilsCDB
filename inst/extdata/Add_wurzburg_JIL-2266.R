#--------------------------------------------------------------------------------------------------
#Adding new data source: zurich 3 cell lines
#   
#--------------------------------------------------------------------------------------------------

# library(rcellminerUtilsCDB)
 
currenttable=rcellminerUtilsCDB::cellLineMatchTab
dim(currenttable) # 2099   36

## wurzburg  cell line JIL-2266 ---------------------------------


currenttable$wurzburg = NA
dim(currenttable) # 2099   37

# 1 new cell line: "JIL-2266"

currenttable[2100,] = NA
currenttable[2100,"wurzburg"] = "JIL-2266"

currenttable[2100,"cellosaurus_accession"] =  "CVCL_A1TT"
currenttable[2100,"cellosaurus_identifier"] = "JIL-2266"
dim(currenttable) # 2100 37
cellLineMatchTab <- currenttable

save(cellLineMatchTab, file = "data/cellLineMatchTab.RData")

## END
## stop here ----------------------





















