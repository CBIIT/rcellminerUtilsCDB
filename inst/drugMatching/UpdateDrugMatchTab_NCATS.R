#--------------------------------------------------------------------------------------------------
# LOAD DATA
#--------------------------------------------------------------------------------------------------
library(rcellminerUtilsCDB)

#--------------------------------------------------------------------------------------------------
# UPDATE TO ADD DATA FOR OTHER IMPORTANT DRUGS
#--------------------------------------------------------------------------------------------------
drugSynonymTab <- rcellminerUtilsCDB::drugSynonymTab 
dim(drugSynonymTab) # 740 - 10
#
drugSynonymTab$ncats = vector(mode = "list", length =nrow(drugSynonymTab) )
for (k in 1:nrow(drugSynonymTab)) drugSynonymTab$ncats[[k]]=NA
dim(drugSynonymTab) # 740 - 11
## reading NCATS drug data
## 
m=read.delim("./inst/extdata/ncats_sampleinfo_final.txt",stringsAsFactors = F)
dim(m) # 27 - 10

# Match 5 drugs and add 22 toxins
#
# start with 5 existing drugs
# drugs5  = m$SAMPLE_NAME[2:6]
for (k in 2:6) {
 y= toupper(m$SAMPLE_NAME[k])
i <- which(vapply(drugSynonymTab$NAME_SET, function(x,item){ item %in% x },item=y, logical(1)))
print(i)
if (length(i) == 1) {
  drugSynonymTab[[i, "ncats"]] <- m$SAMPLE_ID[k]
  drugSynonymTab[[i, 1]] <-  c(drugSynonymTab[[i, 1]],m$SAMPLE_ID[k])
}
}
# add new 22 toxins
n=nrow(drugSynonymTab)

for (j in c(1,7:27)) {
    y= toupper(m$SAMPLE_NAME[j])
    n=n+1
    drugSynonymTab[[n, "ncats"]] <- m$SAMPLE_ID[j]
    drugSynonymTab[[n, 1]] <-  c(y,m$SAMPLE_ID[j])
  
}

dim(drugSynonymTab) # 762 - 11

for (k in 741:762) drugSynonymTab[k,2:10] <- NA

save(drugSynonymTab, file = "data/drugSynonymTab.RData")
#--------------------------------------------------------------------------------------------------


