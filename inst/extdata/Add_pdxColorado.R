#--------------------------------------------------------------------------------------------------
#  Adding new data source: acc pdx from Colorado University
#   
# ---------------------------------------------------------

# library(rcellminerUtilsCDB)
 
currenttable=rcellminerUtilsCDB::cellLineMatchTab
dim(currenttable) # 2095 33

## colorado PDX ---------------------------------
 
cells = c("CUACC1_F1","CUACC1_F2","CUACC2_F1","CUACC2_F2")
 
currenttable$pdxColorado = NA
dim(currenttable) # 2095   34

idx = match(c("CUACC1","CUACC2"), currenttable$acc)
idx
currenttable$pdxColorado[idx] = c("CUACC1_F1","CUACC2_F1")

currenttable[2096:2097,] = NA
currenttable[2096:2097,"pdxColorado"] = c("CUACC1_F2","CUACC2_F2")

dim(currenttable) # 2097   34
cellLineMatchTab <- currenttable

save(cellLineMatchTab, file = "data/cellLineMatchTab.RData")

## END
## stop here ----------------------


















