#--------------------------------------------------------------------------------------------------
# LOAD DATA
#--------------------------------------------------------------------------------------------------
library(rcellminerUtilsCDB)

#--------------------------------------------------------------------------------------------------
# UPDATE TO ADD DATA FOR OTHER IMPORTANT DRUGS
#--------------------------------------------------------------------------------------------------
drugSynonymTab <- rcellminerUtilsCDB::drugSynonymTab 
dim(drugSynonymTab) # 3062   15

# add new drug LP-184N
drugSynonymTab[[3063,1]]=c("LP-184N","LP184N","827761")
drugSynonymTab[[3063,9]]="LP-184N"
for (k in c(2:8,10:15)) drugSynonymTab[[3063,k]] = NA

# add new drug LP-284
drugSynonymTab[[3064,1]]=c("LP-284","LP284","827762")
drugSynonymTab[[3064,9]]="LP-284"
for (k in c(2:8,10:15)) drugSynonymTab[[3064,k]] = NA

dim(drugSynonymTab) # 3064  15

save(drugSynonymTab, file = "data/drugSynonymTab.RData")
#--------------------------------------------------------------------------------------------------


