#--------------------------------------------------------------------------------------------------
#Adding 1 new cell lines for NOB: CA2
#--------------------------------------------------------------------------------------------------

# ---------------------------------------------------------

library(rcellminerUtilsCDB)
 
currenttable=rcellminerUtilsCDB::cellLineMatchTab
dim(currenttable) # 2052 - 25
nbcells = nrow(currenttable)

t = which(!is.na(currenttable$nob))
length(which(!is.na(currenttable$nob))) # 5

#View(currenttable[t,])
tlist = currenttable$nob[t]

allnob = nobData::molData@sampleData@samples$Name
nobmissing = setdiff(allnob, tlist)
nb=length(nobmissing)

## add 48 cell lines
currenttable[(nbcells+1):(nbcells+nb),] = NA

currenttable[(nbcells+1):(nbcells+nb),"nob"] = nobmissing
length(which(!is.na(currenttable$nob))) # 53
## END ======================

dim(currenttable) # 2100 - 25
cellLineMatchTab <- currenttable

save(cellLineMatchTab, file = "data/cellLineMatchTab.RData")

## END
















