#--------------------------------------------------------------------------------------------------
# Correcting ORIGINAL TABLE with new data source: Unified Sarcoma cell lines
# 
#--------------------------------------------------------------------------------------------------
# There are 89 cell lines, distinguish between ES-2 ovarian carcinoma and ES2 sarcoma cell lines
#
# ---------------------------------------------------------

library(rcellminerUtilsCDB)
 
currenttable=rcellminerUtilsCDB::cellLineMatchTab
dim(currenttable) # 1830 - 19

# pre-processed cell line matching with new source uniSarcoma
m=read.delim("./inst/extdata/cellminercdb_matching_cell_lines_Nov1_new.txt",stringsAsFactors = F)
dim(m) # 1831 - 19


##-----------
cellLineMatchTab <- m

save(cellLineMatchTab, file = "data/cellLineMatchTab.RData")

#--------------------------------------------------------------------------------------------------
