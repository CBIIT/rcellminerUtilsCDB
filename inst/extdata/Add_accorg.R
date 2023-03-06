#--------------------------------------------------------------------------------------------------
#  Adding new data source: acc cell lines and acc organoid cell lines
#   
#--------------------------------------------------------------------------------------------------
# There are 4 cell lines + 6 organoids
#
# ---------------------------------------------------------

# library(rcellminerUtilsCDB)
 
currenttable=rcellminerUtilsCDB::cellLineMatchTab
dim(currenttable) # 2089 32 

## colorado cell lines ---------------------------------
org = c("30_SC","31_SC","33_SC","34_SC","37_SC","38_SC" )
# accs = c("CUACC1","CUACC2","H295R","SW13")
 
currenttable$accorg = currenttable$acc
dim(currenttable) # 2089   33

currenttable[2090:2095,] = NA
currenttable[2090:2095,"accorg"] = org
dim(currenttable) # 2095   33
cellLineMatchTab <- currenttable

save(cellLineMatchTab, file = "data/cellLineMatchTab.RData")

## END
## stop here ----------------------


















