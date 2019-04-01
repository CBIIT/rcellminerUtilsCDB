f#--------------------------------------------------------------------------------------------------
# UPDATE ORIGINAL TABLE
# adding DMS-79, H1284 AND H289
#--------------------------------------------------------------------------------------------------
library(rcellminerUtilsCDB)
 
currenttable=rcellminerUtilsCDB::cellLineMatchTab
dim(currenttable) # 1819 11

rownames(currenttable)=1:1819

#currenttable = data.frame(apply(currenttable,2,as.character),stringsAsFactors = F)

# starting with DMS-79
currenttable[371,]
currenttable[371,10]="DMS-79"
# adding now 2 cell lines at the bottom
n=dim(currenttable)[1] 
 # now new ones
currenttable[n+1,] <- replicate(11,NA)
currenttable[n+2,] <- replicate(11,NA)
currenttable[n+1,10]="H1284"
currenttable[n+2,10]="H289"
dim(currenttable) # 1821 11

cellLineMatchTab <- currenttable
save(cellLineMatchTab, file = "data/cellLineMatchTab.RData")

#--------------------------------------------------------------------------------------------------
