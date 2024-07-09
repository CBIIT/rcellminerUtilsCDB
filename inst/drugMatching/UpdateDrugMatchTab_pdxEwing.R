#--------------------------------------------------------------------------------------------------
# Add pdxEwing to drug sysnonym table for LMP400 and Irinotecan
#--------------------------------------------------------------------------------------------------

dtable = rcellminerUtilsCDB::drugSynonymTab 
dim(dtable) # 2880   21

dtable$pdxEwing = vector(mode = "list", length =nrow(dtable) )
for (k in 1:nrow(dtable)) dtable$pdxEwing[[k]]=NA
dim(dtable) # 2880 22

# add LMP400 and Irinotecan
dtable[[413,1]] # LMP400
dtable[[357,1]] # Irinotecan

dtable[[413, "pdxEwing"]] = "LMP400"
dtable[[357, "pdxEwing"]] = "Irinotecan"
## 

t = which(!is.na(dtable$pdxEwing)) ; length(t) # 2
View(dtable[t,])
## 

drugSynonymTab = dtable

save(drugSynonymTab, file = "data/drugSynonymTab.RData")

