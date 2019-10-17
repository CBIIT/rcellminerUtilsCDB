#--------------------------------------------------------------------------------------------------
# UPDATE ORIGINAL TABLE with NCATS cell lines
# 
#--------------------------------------------------------------------------------------------------
# There are 90 cell lines 
#
# ---------------------------------------------------------

library(rcellminerUtilsCDB)
 
currenttable=rcellminerUtilsCDB::cellLineMatchTab
dim(currenttable) # 1825 - 17

#currenttable = data.frame(apply(currenttable,2,as.character),stringsAsFactors = F)

currenttable$ncats = NA

## reading matching cell lines between ncats and ccle, gdsc, mdamills
m=read.delim("./inst/extdata/ncats_cells_annotated.txt",stringsAsFactors = F)
dim(m) # 90 - 14 

## now ccle
i=which(!is.na(m$ccle))
vindex=match(m$ccle[i],currenttable$ccle); length(vindex) # 84
stopifnot(identical(currenttable$ccle[vindex],m$ccle[i]))
currenttable$ncats[vindex]=m$ID[i]
## now gdsc
i2=which(trimws(m$GDSC)!="")
vindex2=match(m$GDSC[i2],currenttable$gdscDec15); length(vindex2) # 4
stopifnot(identical(currenttable$gdscDec15[vindex2],m$GDSC[i2]))
currenttable$ncats[vindex2]=m$ID[i2]
# now mdamills

i3=which(trimws(m$mdamills)!="")
vindex3=match(m$mdamills[i3],currenttable$mdaMills); length(vindex3) # 1
stopifnot(identical(currenttable$mdaMills[vindex3],m$mdamills[i3]))
currenttable$ncats[vindex3]=m$ID[i3]

# new cell line
i4=which(trimws(m$new)!=""); length(i4)
currenttable[nrow(currenttable)+1,] = NA
currenttable$ncats[nrow(currenttable)] = m$new[i4]
dim(currenttable)  # 1826   18
##-----------
cellLineMatchTab <- currenttable

save(cellLineMatchTab, file = "data/cellLineMatchTab.RData")

#--------------------------------------------------------------------------------------------------
