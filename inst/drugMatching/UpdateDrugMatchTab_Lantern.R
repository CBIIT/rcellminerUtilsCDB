#--------------------------------------------------------------------------------------------------
# LOAD DATA
#--------------------------------------------------------------------------------------------------
library(rcellminerUtilsCDB)

#--------------------------------------------------------------------------------------------------
# UPDATE TO ADD DATA FOR OTHER IMPORTANT DRUGS
#--------------------------------------------------------------------------------------------------
drugSynonymTab <- rcellminerUtilsCDB::drugSynonymTab 
dim(drugSynonymTab) # 739 - 8
drugSynonymTab$lantern = vector(mode = "list", length =nrow(drugSynonymTab) )
for (k in 1:nrow(drugSynonymTab)) drugSynonymTab$lantern[[k]]=NA

i <- which(vapply(drugSynonymTab$NAME_SET, function(x){ "IROFULVEN" %in% x }, logical(1)))
if (length(i) == 1) {
  drugSynonymTab[[i, "lantern"]] <- "Irofulven"
  drugSynonymTab[[i, 1]] <-  c(drugSynonymTab[[i, 1]],"LP-100","LP100")
  ## save(drugSynonymTab, file = "data/drugSynonymTab.RData")
}
# add new drug LP-184
drugSynonymTab[[740,1]]=c("LP-184","LP184","740821")
drugSynonymTab[[740,9]]="LP-184"
for (k in 2:8) drugSynonymTab[[740,k]] = NA

save(drugSynonymTab, file = "data/drugSynonymTab.RData")
#--------------------------------------------------------------------------------------------------


