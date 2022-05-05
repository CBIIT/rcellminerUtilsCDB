#--------------------------------------------------------------------------------------------------
# Cleaning ncats ic50 and auc  in drug matching table
#--------------------------------------------------------------------------------------------------
load("data/drugSynonymTab.Rdata")
dtable = drugSynonymTab 

dim(dtable) # 2886 18
t = which(!is.na(dtable$tncats )) ; length(t) # 2672 (in fact 2679 with synonyms)
## 
## -----------------------------------------------------------------------
# it should be 2665 ncats ic50, need to put na in 11 drugs
naic50 = read.csv("inst/drugMatching/na_in_ic50.csv", row.names = 1, stringsAsFactors = F)
dim(naic50) # 11 1 

i= match(naic50[,1], dtable$tncats); length(i)
dtable$tncats[i] = NA


# it should be 2675 ncats auc, need to put na in 1 drug
naauc = read.csv("inst/drugMatching/na_in_auc.csv", row.names = 1, stringsAsFactors = F)
dim(naauc) # 1 1

j= match(naauc[,1], dtable$ancats); length(j)
dtable$ancats[j] = NA


# need to remove 3 drugs from table since they have NA cross all cellines in tncats and ancats
toremove = read.csv("inst/drugMatching/remove.csv", row.names = 1, stringsAsFactors = F)
dim(toremove) # 3 1

k= match(toremove[,1], dtable$tncats); length(k)

dtable = dtable[-k,]
dim(dtable) # 2883 - 18
# checking 

t1 = which(!is.na(dtable$tncats )) ; length(t1) # 2658 (-14)
length(unlist(dtable$tncats[t1])) # 2665

t2 = which(!is.na(dtable$ancats )) ; length(t2) # 2668 (-4)
length(unlist(dtable$ancats[t2])) # 2675

t3= which(!is.na(dtable$tncats) & !is.na(dtable$ancats)); length(t3) # 2657
length(unlist(dtable$ancats[t3])) # 2664
## --------
rownames(dtable) = 1:2883
drugSynonymTab = dtable

save(drugSynonymTab, file = "data/drugSynonymTab.RData")

