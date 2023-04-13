#--------------------------------------------------------------------------------------------------
# Additional Matching 5 drugs in NCI ACCORG (cell lines and surgical samples)
#--------------------------------------------------------------------------------------------------
load("data/drugSynonymTab.Rdata")
dtable = drugSynonymTab 

dim(dtable) # 2880   21
t = which(!is.na(dtable$accorg )) ; length(t) # 42
## 
ndrugs = read.csv("inst/drugMatching/ACC_CellLines_5drugs_info.csv", stringsAsFactors = F)
dim(ndrugs) # 5 -5 

## idx = match(as.character(ndrugs$NSC.CDB), dtable$nci60)
cn = c()

for (k in 1:5) {
  idx = grep(as.character(ndrugs$NSC.CDB)[k], dtable$nci60)
  if (length(idx) !=0 ) {
    cn = c(cn,idx)
    if (k<5) {
      dtable[[idx, "accorg"]] <- as.character(ndrugs$NSC.CDB[k])
    } else {
      # "PEVONEDISTAT" has a new NSC 793435
      dtable[[idx, "accorg"]] <- as.character(ndrugs$NSC)[k]
      dtable[[idx, 1]] = union( dtable[[idx, 1]], as.character(ndrugs$NSC)[k] )
      
    }
  }
  
}

# cn
# View(dtable[cn,])

## -----------------------------------------------------------------------
dim(dtable)

drugSynonymTab = dtable

save(drugSynonymTab, file = "data/drugSynonymTab.RData")

