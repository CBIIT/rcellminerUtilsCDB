#--------------------------------------------------------------------------------------------------
#Adding new data source: Ukhyun
# 
#--------------------------------------------------------------------------------------------------
# There are 13 cell lines
#
# ---------------------------------------------------------

library(rcellminerUtilsCDB)
 
currenttable=rcellminerUtilsCDB::cellLineMatchTab
dim(currenttable) # 2048 - 22

# read curated info

# info available for 579 matching ccle
m=read.delim("inst/extdata/IC50-13cells.txt",stringsAsFactors = F)
dim(m) # 13 - 3


# new column and new cell lines
currenttable$ukhyun = NA
dim(currenttable) # 2048 - 23

## cell lines should already exist in GDSC
ind.gdsc  = match(m$Cellline,currenttable$gdscDec15)
length(which(!is.na(ind.gdsc))) # 13
currenttable$ukhyun[ind.gdsc] = m$Cellline

## END ======================

dim(currenttable) # 2048 - 23
cellLineMatchTab <- currenttable

save(cellLineMatchTab, file = "data/cellLineMatchTab.RData")

## END

















