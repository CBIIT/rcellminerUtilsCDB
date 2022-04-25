#--------------------------------------------------------------------------------------------------
# Additional Matching 112 PRISM drugs in NCATS from Kelli curation
#--------------------------------------------------------------------------------------------------
load("data/drugSynonymTab.Rdata")
dtable = drugSynonymTab 

dim(dtable) # 2886 18
t = which(!is.na(dtable$prism )) ; length(t) # 708 (IN FACT 712) 
## 
## -----------------------------------------------------------------------
prism = read.csv("inst/drugMatching/prism_drugs_matching_info_Kelli_correct.csv", stringsAsFactors = F)
# table curated by Kelli Wilson
dim(prism) # 1413 - 9

# step1 index for matching ones ------------------------------------------
idx = which(trimws(prism$kw_matching)!=""); length(idx) # 112 (with 9 synonyms)
i= match(prism$kw_matching[idx], dtable$tncats)
length(which(!is.na(i))) # 112
# View(dtable[i,])
j = which(trimws(prism$matching_in_cellminercdb)=="SYN"); length(j) # 9
## there are no NA in prism
# xx = dtable[i,]
# w = which(!is.na(xx$prism))
# found = unlist(xx$prism[w])
# [1] "abiraterone"   "bardoxolone"   "crizotinib"    "digoxin"       "estramustine"  "etoposide"     "fludarabine"   "parthenolide" 
# [9] "triamcinolone"

# kk = match(found,prism$pert_iname); length(kk)
# View(prism[kk,])
# 
# kk2= match(found,prism$kw_matching); length(kk2)
# View(prism[kk2,])
## write.csv(prism[c(kk,kk2),],"toremove.csv")
##


for (k in 1: length(i)) 
  { 
  if (prism$matching_in_cellminercdb[idx[k]] != "SYN") 
    { 
      dtable[[i[k], "prism"]] <- prism$pert_iname[idx[k]]
      dtable[[i[k], 1]] = union( dtable[[i[k], 1]],toupper(prism$pert_iname[idx[k]]) )
    } else {
      dtable[[i[k], "prism"]] <- union(dtable[[i[k], "prism"]], prism$pert_iname[idx[k]])
      dtable[[i[k], 1]] = union( dtable[[i[k], 1]],toupper(prism$pert_iname[idx[k]]) )
  }
 }

t = which(!is.na(dtable$prism )) ; length(t) # 708 (IN FACT 712) + 112-9 >> 811 >> 815

# View(dtable[i,])
dim(dtable)

drugSynonymTab = dtable

save(drugSynonymTab, file = "data/drugSynonymTab.RData")

