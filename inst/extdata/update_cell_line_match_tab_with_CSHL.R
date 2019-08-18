#--------------------------------------------------------------------------------------------------
# UPDATE ORIGINAL TABLE with CSHL  (Histone data  cell lines)
# 
#--------------------------------------------------------------------------------------------------
# There are 13 cell lines 
#
# ---------------------------------------------------------

library(rcellminerUtilsCDB)
 
currenttable=rcellminerUtilsCDB::cellLineMatchTab
dim(currenttable) # 1822 14

#currenttable = data.frame(apply(currenttable,2,as.character),stringsAsFactors = F)

currenttable$cshl = NA

## reading matching cell lines between NCI DTP and GB Sarcoma
m=read.delim("./inst/extdata/CSHL_cell_lines_matching.txt",stringsAsFactors = F)
dim(m) #13 - 2

## the first 66 cell lines have matching in NCI DTP sarcoma
vindex=match(m$cshl[1:12],currenttable$ccle); length(vindex)
stopifnot(identical(currenttable$ccle[vindex],m$cshl[1:12]))
currenttable$cshl[vindex]=currenttable$ccle[vindex]
##
vindex2=match(m$cshl[13],currenttable$gdscDec15); length(vindex2)
stopifnot(identical(currenttable$gdscDec15[vindex2],m$cshl[13]))
currenttable$cshl[vindex2]=currenttable$gdscDec15[vindex2]


##-----------
cellLineMatchTab <- currenttable

save(cellLineMatchTab, file = "data/cellLineMatchTab.RData")

#--------------------------------------------------------------------------------------------------
