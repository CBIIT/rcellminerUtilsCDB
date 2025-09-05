#--------------------------------------------------------------------------------------------------
#Adding Tumor similary score provided by A Luna using TumorComparer tool
#   
#--------------------------------------------------------------------------------------------------

# library(rcellminerUtilsCDB)
 
currenttable=rcellminerUtilsCDB::cellLineMatchTab
dim(currenttable) # 2098   39

mtc  = read.csv("inst/extdata/mtc_results_20200331_cellminercdb_manual_curated_v2.csv")
dim(mtc) # 1910 6
# 
length(which(!is.na(currenttable$cellosaurus_accession))) # 1953
length(unique(currenttable$cellosaurus_accession)) # 1954


length(intersect(currenttable$cellosaurus_accession, mtc$cellosaurus_accession)) # 1910

##

currenttable$mean_similarity_to_tumors_avg = NA
idx = match(mtc$cellosaurus_accession, currenttable$cellosaurus_accession)
# which(is.na(idx)) ## zero
currenttable$mean_similarity_to_tumors_avg[idx] = mtc$mean_similarity_to_tumors_avg

dim(currenttable) # 2098 40
cellLineMatchTab <- currenttable

save(cellLineMatchTab, file = "data/cellLineMatchTab.RData")
