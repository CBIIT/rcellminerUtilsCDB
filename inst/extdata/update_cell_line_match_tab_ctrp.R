#--------------------------------------------------------------------------------------------------
# UPDATE ORIGINAL TABLE AND SAVE
#--------------------------------------------------------------------------------------------------
library(rcellminerUtils)
library(ctrpData)

ctrpLineAnnot <- rcellminer::getSampleData(ctrpData::drugData)
rownames(ctrpLineAnnot) <- ctrpLineAnnot$Name

newCellMatchTab <- rcellminerUtils::cellLineMatchTab
newCellMatchTab$ctrp <- NA

for (i in seq_len(nrow(newCellMatchTab))){
  ccleLine <- newCellMatchTab[i, "ccle"]
  if (!is.na(ccleLine)){
    if (ccleLine %in% rownames(ctrpLineAnnot)){
      newCellMatchTab[i, "ctrp"] <- ccleLine
    }
  }
}

stopifnot(identical(sort(na.exclude(newCellMatchTab$ctrp)),
                    sort(rownames(ctrpLineAnnot))))

cellLineMatchTab <- newCellMatchTab
save(cellLineMatchTab, file = "data/cellLineMatchTab.RData")

#--------------------------------------------------------------------------------------------------
