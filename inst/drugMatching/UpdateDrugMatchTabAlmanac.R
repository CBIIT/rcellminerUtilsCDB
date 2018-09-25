#--------------------------------------------------------------------------------------------------
# LOAD DATA
#--------------------------------------------------------------------------------------------------
library(rcellminerUtils)

#--------------------------------------------------------------------------------------------------
# UPDATE TO ADD DATA FOR OTHER IMPORTANT DRUGS
#--------------------------------------------------------------------------------------------------
drugSynonymTab <- rcellminerUtils::drugSynonymTab
drugSynonymTab$almanac = vector(mode = "list", length =nrow(drugSynonymTab) )
for (k in 1:nrow(drugSynonymTab)) drugSynonymTab$almanac[[k]]=NA

i <- which(vapply(drugSynonymTab$NAME_SET, function(x){ "TOPOTECAN" %in% x }, logical(1)))
if (length(i) == 1) {
  drugSynonymTab[[i, "almanac"]] <- c("609699_123127", "609699_102816","609699_122758")
  save(drugSynonymTab, file = "data/drugSynonymTab.RData")
}
#--------------------------------------------------------------------------------------------------


