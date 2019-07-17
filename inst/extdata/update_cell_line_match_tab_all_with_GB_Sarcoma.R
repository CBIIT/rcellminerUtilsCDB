#--------------------------------------------------------------------------------------------------
# UPDATE ORIGINAL TABLE with GB Sarcoma  cell lines (Javed Khan cell lines)
# 
#--------------------------------------------------------------------------------------------------
# There are 70 cell lines but only 66 matches NCI Sarcoma, 1 GDSC and one mdaMills
#
# ---------------------------------------------------------

library(rcellminerUtilsCDB)
 
currenttable=rcellminerUtilsCDB::cellLineMatchTab
dim(currenttable) # 1820 13

#currenttable = data.frame(apply(currenttable,2,as.character),stringsAsFactors = F)

currenttable$gbSarcoma = NA

## reading matching cell lines between NCI DTP and GB Sarcoma
m=read.delim("./inst/extdata/match-cells-sarcoma-nci-GB.txt",stringsAsFactors = F)
dim(m) #70 - 9

## the first 66 cell lines have matching in NCI DTP sarcoma
vindex=match(m$nci[1:66],currenttable$sarcoma); length(vindex)
stopifnot(identical(currenttable$sarcoma[vindex],m$nci[1:66]))

currenttable$gbSarcoma[vindex]=m$gb[1:66]
##-----------
# 2 cell lines  Rh1 => RH-1 in GDSC and SMSCTR => SMSCTR in mdaMills
currenttable$gbSarcoma[which(currenttable$gdscDec15=="RH-1")] = "Rh1"
currenttable$gbSarcoma[which(currenttable$mdaMills=="SMSCTR")] = "SMSCTR"

##----------
# 2 cell lines  without matching Rh4 and RMS559
currenttable[1821,] = NA
currenttable[1822,] = NA
currenttable$gbSarcoma[1821] = "Rh4"
currenttable$gbSarcoma[1822] = "RMS559"
##----------

## 
cellLineMatchTab <- currenttable

save(cellLineMatchTab, file = "data/cellLineMatchTab.RData")

#--------------------------------------------------------------------------------------------------
