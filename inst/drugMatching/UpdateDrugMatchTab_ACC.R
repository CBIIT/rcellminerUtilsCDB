#--------------------------------------------------------------------------------------------------
# Match 41 drugs in ACC to NCI60 / other drug sources
#--------------------------------------------------------------------------------------------------

acc = read.csv("inst/drugMatching/ACC_CellLines_DrugTest.csv", stringsAsFactors = F)
dim(acc)
# 41 - 9

dtable = rcellminerUtilsCDB::drugSynonymTab 
dim(dtable) # 2888   15

dtable$acc = vector(mode = "list", length =nrow(dtable) )
for (k in 1:nrow(dtable)) dtable$acc[[k]]=NA
dim(dtable) # 2888 16

## 

# n=nrow(dtable)
nm= nrow(acc) 
## try to match based on first nsc then by name
# 
for (k in 1:nm) {
  ind = NA
  y = acc$NSC[k]
  i <- which(vapply(dtable$NAME_SET, function(x,item){ item %in% x },item=y, logical(1)))
  if (length(i) == 1) ind = i else 
  { 
    y = toupper(acc$Drug.name[k])
    j <- which(vapply(dtable$NAME_SET, function(x,item){ item %in% x },item=y, logical(1)))
    if (length(j) == 1) ind =j
  }
  # print(ind)
  if(!is.na(ind)) { 
    dtable[[ind, "acc"]] <- acc$NSC[k]
    dtable[[ind, 1]] <- union(dtable[[ind, 1]],toupper(toupper(acc$Drug.name[k])))
    dtable[[ind, 1]] <- union(dtable[[ind, 1]], acc$NSC[k])
    cat(k, " drug Processed OK", acc$NSC[k], "\n")
  } else cat(k, " drug not processed New", acc$NSC[k], "\n")
}


dim(dtable) # 2888 46
t = which(!is.na(dtable$acc )) ; length(t) # 41
# View(dtable[t,c(1:5,16)])
## 

drugSynonymTab = dtable

save(drugSynonymTab, file = "data/drugSynonymTab.RData")

