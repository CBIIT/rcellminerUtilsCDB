#--------------------------------------------------------------------------------------------------
# UPDATE ORIGINAL TABLE AND SAVE
#--------------------------------------------------------------------------------------------------
library(rcellminerUtils)


newCellMatchTab <- rcellminerUtils::cellLineMatchTab
indice=which(newCellMatchTab$ccle=="COR-L279")
newCellMatchTab[indice,7]="COR-L279"

cellLineMatchTab <- newCellMatchTab
save(cellLineMatchTab, file = "data/cellLineMatchTab.RData")

#--------------------------------------------------------------------------------------------------
