#--------------------------------------------------------------------------------------------------
# LOAD DATA
#--------------------------------------------------------------------------------------------------
## library(rcellminerUtilsCDB)
load("./data/drugSynonymTab.RData")
temptable=drugSynonymTab
dim(temptable)
# 738   7

temptable[[145,1]]
## [1] "LMP744"             "LMP-744"            "MJ-III-65"          "INDENOISOQUINOLINE"
temptable[[145,4]] <- "MJ-III-65"

drugSynonymTab=temptable

# save new drug synonyms
save(drugSynonymTab, file = "data/drugSynonymTab.RData")
## end