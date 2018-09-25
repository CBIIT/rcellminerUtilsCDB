#--------------------------------------------------------------------------------------------------
# LOAD INPUT DATA AND CONSTRUCT STARTING CELL LINE MATCH TABLE.
#--------------------------------------------------------------------------------------------------
library(rcellminerUtils)

newCellMatchTab <- rcellminerUtils::cellLineMatchTab

load("~/REPOS/rcellminerData/inst/extdata/CellMinerNci60LineTab.Rdata")

stopifnot(identical(newCellMatchTab[1:60, "nci60"],
                    CellMinerNci60LineTab$CellMiner_1_6))

newCellMatchTab[1:60, "nci60"] <- CellMinerNci60LineTab$CellMiner_2_0

cellLineMatchTab <- newCellMatchTab
save(cellLineMatchTab, file = "data/cellLineMatchTab.RData")
#--------------------------------------------------------------------------------------------------
