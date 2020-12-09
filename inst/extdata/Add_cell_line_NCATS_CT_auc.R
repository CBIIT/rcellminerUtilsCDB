#--------------------------------------------------------------------------------------------------
#Adding new data source: TNCATS = NCATS from Craig Thomas
# Adding new 34 cell lines for Lantern source
#--------------------------------------------------------------------------------------------------
# There are 183 cell lines
#
# ---------------------------------------------------------

library(rcellminerUtilsCDB)
 
currenttable=rcellminerUtilsCDB::cellLineMatchTab
dim(currenttable) # 2048   23

# new column and new cell lines
currenttable$ancats = currenttable$tncats
 
dim(currenttable) # 2048   24
stopifnot(identical(currenttable$tncats,currenttable$ancats))

## adding new cell lines for Lantern
lantinfo = read.delim("./inst/extdata/Lantern-info.txt",stringsAsFactors=F)

iccle=match(lantinfo$ccle.cell[1:33],currenttable$ccle)
igdsc=match(lantinfo$gdscDec15.cell[34],currenttable$gdscDec15)

currenttable$lantern[iccle] = lantinfo$ccle.cell[1:33]
currenttable$lantern[igdsc] = lantinfo$gdscDec15.cell[34]

cellLineMatchTab <- currenttable
save(cellLineMatchTab, file = "data/cellLineMatchTab.RData")


## END

















