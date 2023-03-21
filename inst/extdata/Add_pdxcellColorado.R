#--------------------------------------------------------------------------------------------------
#  Adding new data source: acc and pdx from Colorado University
#   
# ---------------------------------------------------------

# library(rcellminerUtilsCDB)
 
currenttable=rcellminerUtilsCDB::cellLineMatchTab
dim(currenttable) # 2097 34

## correct pdxColorado , remove matching of the pdx F1(s) with Colorado
idx = match(c("CUACC1_F1","CUACC2_F1"), currenttable$pdxColorado)
currenttable$pdxColorado[idx] = NA
currenttable[2098:2099,] = NA
currenttable[2098:2099,"pdxColorado"] = c("CUACC1_F1","CUACC2_F1")

## colorado PDX ---------------------------------
 
# cells = c("CUACC1","CUACC2","H295R", "CUACC1_F1","CUACC1_F2","CUACC2_F1","CUACC2_F2")
 
currenttable$pdxcellColorado = NA
dim(currenttable) # 2099   35

idx1 = match(c("CUACC1","CUACC2","H295R"), currenttable$colorado)
idx2 = match(c("CUACC1_F1","CUACC1_F2","CUACC2_F1","CUACC2_F2"), currenttable$pdxColorado)

currenttable$pdxcellColorado[idx1] = c("CUACC1","CUACC2","H295R")
currenttable$pdxcellColorado[idx2] = c("CUACC1_F1","CUACC1_F2","CUACC2_F1","CUACC2_F2")


dim(currenttable) # 2099   35
cellLineMatchTab <- currenttable

save(cellLineMatchTab, file = "data/cellLineMatchTab.RData")

## END
## stop here ----------------------


















