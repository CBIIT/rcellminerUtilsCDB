#--------------------------------------------------------------------------------------------------
# LOAD DATA
#--------------------------------------------------------------------------------------------------
library(rcellminerUtilsCDB)

#--------------------------------------------------------------------------------------------------
# UPDATE TO ADD DATA FOR OTHER IMPORTANT DRUGS
#--------------------------------------------------------------------------------------------------
drugSynonymTab <- rcellminerUtilsCDB::drugSynonymTab 
dim(drugSynonymTab) # 762 - 11
#
drugSynonymTab$uniSarcoma <- drugSynonymTab$sarcoma
dim(drugSynonymTab) # 762 - 12

save(drugSynonymTab, file = "data/drugSynonymTab.RData")
#--------------------------------------------------------------------------------------------------


