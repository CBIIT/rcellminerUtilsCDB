#--------------------------------------------------------------------------------------------------
# Correcting ORIGINAL TABLE with new data source: Global Sarcoma cell lines
# 
#--------------------------------------------------------------------------------------------------
# There are 114 cell lines
#
# ---------------------------------------------------------

library(rcellminerUtilsCDB)
 
currenttable=rcellminerUtilsCDB::cellLineMatchTab
dim(currenttable) # 1831 - 19

# pre-processed cell line matching with new source uniSarcoma
m=read.delim("./inst/extdata/cellmatchs_new_genSarcoma_nov4.txt",stringsAsFactors = F)
dim(m) # 1831 - 20


##-----------
cellLineMatchTab <- m

save(cellLineMatchTab, file = "data/cellLineMatchTab.RData")

#--------------------------------------------------------------------------------------------------
