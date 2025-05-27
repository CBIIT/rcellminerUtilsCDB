#--------------------------------------------------------------------------------------------------
# clean cell line matching table 
#   1/ keep Rh30 with cellosaurus Id but not SJRh30
#   2/ remove duplicates for C-4-11, D458, Mo, NCIADRRES, Gp2D and NBTU1
#--------------------------------------------------------------------------------------------------

# library(rcellminerUtilsCDB)
 
currenttable=rcellminerUtilsCDB::cellLineMatchTab
dim(currenttable) # 2104   39

## updates  -----------------------------------------------------------------

# sjrh30 cell
currenttable[183,]
currenttable[183,c("cellosaurus_accession", "cellosaurus_identifier")] = c(NA,NA)


# delete 6 line
idx = sort(c(1073,1100,1392,1221,1137,1371))
# View(currenttable[idx,])
currenttable = currenttable[-idx,]
### saving ------------------------------------------------------------------
dim(currenttable) # 2098   39
rownames(currenttable) = 1:nrow(currenttable)

cellLineMatchTab <- currenttable
save(cellLineMatchTab, file = "data/cellLineMatchTab.RData")

