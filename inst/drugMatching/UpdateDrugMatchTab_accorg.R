#--------------------------------------------------------------------------------------------------
# Match accorg to acc drug data
#--------------------------------------------------------------------------------------------------

dtable = rcellminerUtilsCDB::drugSynonymTab 
dim(dtable) # 2880   20

length(which(!is.na(dtable$acc))) # 42
dtable$accorg = dtable$acc
dim(dtable) # 2880   21
#length(which(!is.na(dtable$accorg))) # 42

# v= which(!is.na(dtable$acc)); length(v) # 42
# View(dtable[v,])


drugSynonymTab = dtable

save(drugSynonymTab, file = "data/drugSynonymTab.RData")

