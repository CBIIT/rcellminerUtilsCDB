#--------------------------------------------------------------------------------------------------
# Upadte cell line matching table 
#   1/ redundancy for Cell Line for PL18 (GDSC) and BIRCH (MD ANDERSON): to rematch and remove
#   2/ redundancy for Cell Line MB157, Alexander and RIVA: keep but remove matching Cellosaurus ID
#.     to be able to generate their synonyms cell lines pages: MDA-MB-157, PLC/PRF/5 and Ri-1
#--------------------------------------------------------------------------------------------------

# library(rcellminerUtilsCDB)
 
currenttable=rcellminerUtilsCDB::cellLineMatchTab
dim(currenttable) # 2106   39

## updates  -----------------------------------------------------------------
currenttable[1316,]
currenttable[875,"gdscDec15"] = currenttable[1316,"gdscDec15"] #  PL18, to remove line 1316
currenttable[1693,]
currenttable[1786,"mdaMills"] = currenttable[1693,"mdaMills"] # BIRCH,to remove line 1693

# Alexander cell
currenttable[501,"ccle"]
currenttable[501,c("cellosaurus_accession", "cellosaurus_identifier")] = c(NA,NA)
# MB157
currenttable[1461,"gdscDec15"]
currenttable[1461,c("cellosaurus_accession", "cellosaurus_identifier")] = c(NA,NA)
# RIVA
currenttable[1710,"mdaMills"]
currenttable[1710,c("cellosaurus_accession", "cellosaurus_identifier")] = c(NA,NA)

# delete two line

currenttable = currenttable[-c(1316,1693),]
### saving ------------------------------------------------------------------
dim(currenttable) # 2104   39
rownames(currenttable) = 1:nrow(currenttable)

cellLineMatchTab <- currenttable
save(cellLineMatchTab, file = "data/cellLineMatchTab.RData")

