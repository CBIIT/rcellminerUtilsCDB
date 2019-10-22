#--------------------------------------------------------------------------------------------------
# UPDATE ORIGINAL TABLE with new data source: Unified Sarcoma cell lines
# 
#--------------------------------------------------------------------------------------------------
# There are 89 cell lines 
#
# ---------------------------------------------------------

library(rcellminerUtilsCDB)
 
currenttable=rcellminerUtilsCDB::cellLineMatchTab
dim(currenttable) # 1826 - 18

# pre-processed cell line matching with new source uniSarcoma
m=read.delim("./inst/extdata/cellminercdb_matching_cell_lines_oct_15_new.txt",stringsAsFactors = F)
dim(m) # 1830 - 19


##-----------
cellLineMatchTab <- m

save(cellLineMatchTab, file = "data/cellLineMatchTab.RData")

#--------------------------------------------------------------------------------------------------
