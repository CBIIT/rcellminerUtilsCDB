#--------------------------------------------------------------------------------------------------
# Match 5 drugs in nob to NCI60 / other drug sources
#--------------------------------------------------------------------------------------------------

vnob = read.csv("inst/drugMatching/nob_drug_info.csv", stringsAsFactors = F)
dim(vnob)
# 5 - 6

dtable = rcellminerUtilsCDB::drugSynonymTab 
dim(dtable) # 2888   16

dtable$nob = vector(mode = "list", length =nrow(dtable) )
for (k in 1:nrow(dtable)) dtable$nob[[k]]=NA
dim(dtable) # 2888 17


## 

# n=nrow(dtable)
nm= nrow(vnob) 

for (k in 1:nm) {
 
    ind  = vnob$index_table[k]
    dtable[[ind, "nob"]] <- vnob$ID[k]
    dtable[[ind, 1]] <- union(dtable[[ind, 1]],toupper(toupper(vnob$NAME[k])))
    if (k==4) dtable[[ind, "nci60"]] <- vnob$new.nci60[k]
    cat(k, " drug Processed OK", vnob$NSC[k], "\n")
 
}

################################
## try to match based on first nsc then by name
# 

dim(dtable) # 2888 17
t = which(!is.na(dtable$nob )) ; length(t) # 5
# View(dtable[t,c(1:5,17)])
## 

drugSynonymTab = dtable

save(drugSynonymTab, file = "data/drugSynonymTab.RData")

