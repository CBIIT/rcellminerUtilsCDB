#--------------------------------------------------------------------------------------------------
#Adding new data source: acc
# 
#--------------------------------------------------------------------------------------------------
# There are 4 cell lines
#
# ---------------------------------------------------------

library(rcellminerUtilsCDB)
 
currenttable=rcellminerUtilsCDB::cellLineMatchTab
dim(currenttable) # 2049 - 24


# add 3 new cell lines "CUACC1" "CUACC2" "H295R"
# match existent cell lines: "SW13"  

# new column and new cell lines
currenttable$acc = NA
dim(currenttable) # 2049 - 25

## SW13 should already exist in GDSC
ind.gdsc  = match("SW13",currenttable$gdscDec15)
length(which(!is.na(ind.gdsc))) # 1
#currenttable$gdscDec15[ind.gdsc]
currenttable$acc[ind.gdsc] = "SW13"

## add 3 cell lines
currenttable[2050:2052,] = NA
currenttable[2050:2052,"acc"] = c("CUACC1","CUACC2","H295R")

## END ======================

dim(currenttable) # 2052 - 25
cellLineMatchTab <- currenttable

save(cellLineMatchTab, file = "data/cellLineMatchTab.RData")

## END

















