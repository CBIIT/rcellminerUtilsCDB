#--------------------------------------------------------------------------------------------------
# UPDATE ORIGINAL TABLE with NOB cell lines
# 
#--------------------------------------------------------------------------------------------------
# There are 52 cell lines but only 5 matches NCI60, CCLE and GDSC
# For now will not add the 47 cell lines
# ---------------------------------------------------------


library(rcellminerUtilsCDB)
 
currenttable=rcellminerUtilsCDB::cellLineMatchTab
dim(currenttable) # 1820 12

#currenttable = data.frame(apply(currenttable,2,as.character),stringsAsFactors = F)

currenttable$nob = NA

u87=which(currenttable$ccle=="U-87 MG")
currenttable$nob[u87]="U87"

u251=which(currenttable$ccle=="U-251 MG")
currenttable$nob[u251]="U251"

a172=which(currenttable$ccle=="A172")
currenttable$nob[a172]="A172"

sw1088=which(currenttable$ccle=="SW 1088")
currenttable$nob[sw1088]="SW1088"

ln229=which(currenttable$ccle=="LN-229")
currenttable$nob[ln229]="LN229"

## 
cellLineMatchTab <- currenttable

save(cellLineMatchTab, file = "data/cellLineMatchTab.RData")

#--------------------------------------------------------------------------------------------------
