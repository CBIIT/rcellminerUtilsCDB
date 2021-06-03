#--------------------------------------------------------------------------------------------------
# Add MDMBA468  Cell Line for Lantern
#--------------------------------------------------------------------------------------------------
library(rcellminerUtilsCDB)
 
currenttable=rcellminerUtilsCDB::cellLineMatchTab
dim(currenttable) # 2049 - 24



currenttable[371,"ccle"] # "MDA-MB-468"
currenttable[371,"lantern"] = "BR:MDA-MB-468"

# now saving


cellLineMatchTab <- currenttable
save(cellLineMatchTab, file = "data/cellLineMatchTab.RData")

#--------------------------------------------------------------------------------------------------
