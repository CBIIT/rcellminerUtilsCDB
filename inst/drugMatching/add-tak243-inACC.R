#--------------------------------------------------------------------------------------------------
# ADD TAK-243 drug in acc NCI (nsc 785004)
#--------------------------------------------------------------------------------------------------

dtable = rcellminerUtilsCDB::drugSynonymTab 
dim(dtable) # 2880   20

idx = match("785004", dtable$nci60) # 971
dtable[[idx,2]]
dtable[[idx,"acc"]] = "785004"
## 

# n=nrow(dtable)

dim(dtable) # 2880 20
t = which(!is.na(dtable$acc )) ; length(t) # 42

## 

drugSynonymTab = dtable

save(drugSynonymTab, file = "data/drugSynonymTab.RData")

