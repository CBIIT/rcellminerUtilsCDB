#--------------------------------------------------------------------------------------------------
#Adding 4 new cell lines for GDSC Dec15 from rnaseq
#--------------------------------------------------------------------------------------------------
# library(rcellminerUtilsCDB)
 
currenttable=rcellminerUtilsCDB::cellLineMatchTab
dim(currenttable) # 2068 30

newcells = c("SNU-283","BONNA-12", "NCI-H740", "U-CH2" )

idx  = match(newcells, currenttable$gdsc2) ## already exist in gdsc2

currenttable$gdscDec15[idx] = newcells

# View(currenttable[idx,])


## END ======================

dim(currenttable) # 2068 - 30
cellLineMatchTab <- currenttable

save(cellLineMatchTab, file = "data/cellLineMatchTab.RData")

## END
















