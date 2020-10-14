#--------------------------------------------------------------------------------------------------
# LOAD DATA
#--------------------------------------------------------------------------------------------------
library(rcellminerUtilsCDB)

#--------------------------------------------------------------------------------------------------
# UPDATE TO ADD DATA FOR OTHER IMPORTANT DRUGS
#--------------------------------------------------------------------------------------------------
drugSynonymTab <- rcellminerUtilsCDB::drugSynonymTab 
dim(drugSynonymTab) # 1130   13
#
drugSynonymTab$ukhyun = vector(mode = "list", length =nrow(drugSynonymTab) )
for (k in 1:nrow(drugSynonymTab)) drugSynonymTab$ncats[[k]]=NA
dim(drugSynonymTab) # 1130   14
## add m4344

n=nrow(drugSynonymTab)+1
drugSynonymTab[[n, 1]] <- c("M4344","VX803")
drugSynonymTab[n,2:13] <- NA
drugSynonymTab[[n,14]] <- "M4344"

dim(drugSynonymTab) #  1131   14

save(drugSynonymTab, file = "data/drugSynonymTab.RData")
#--------------------------------------------------------------------------------------------------


