#--------------------------------------------------------------------------------------------------
# UPDATE TABLE with GB Sarcoma  cell lines (adding RNASEQ Javed Khan cell lines)
# 
#--------------------------------------------------------------------------------------------------
# There are now 77 cell lines with 3 new ones 
#
# ---------------------------------------------------------

library(rcellminerUtilsCDB)
 
currenttable=rcellminerUtilsCDB::cellLineMatchTab
dim(currenttable) # 1822 - 16

## update gbSarcoma with hMSC, Hs819T, NHACkn and NHOst
## 
vindex=match("hMSC",currenttable$sarcoma)
currenttable$gbSarcoma[vindex]="hMSC"

vindex=match("NHAC-kn",currenttable$sarcoma)
currenttable$gbSarcoma[vindex]="NHACkn"

vindex=match("NHOst",currenttable$sarcoma)
currenttable$gbSarcoma[vindex]="NHOst"

vindex=match("Hs 819.T",currenttable$ccle)
currenttable$gbSarcoma[vindex]="Hs819T"


##----------
# Add 3 new cell lines: Hs312T, Hs414T and Hs93T
n=nrow(currenttable)

currenttable[n+1,] = NA
currenttable[n+2,] = NA
currenttable[n+3,] = NA

currenttable$gbSarcoma[n+1] = "Hs312T"
currenttable$gbSarcoma[n+2] = "Hs414T"
currenttable$gbSarcoma[n+3] = "Hs93T"
dim(currenttable)
# 1825   16
##----------

## 
cellLineMatchTab <- currenttable

save(cellLineMatchTab, file = "data/cellLineMatchTab.RData")

#--------------------------------------------------------------------------------------------------
