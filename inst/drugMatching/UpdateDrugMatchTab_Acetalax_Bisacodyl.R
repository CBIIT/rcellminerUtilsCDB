#--------------------------------------------------------------------------------------------------
# LOAD DATA
#--------------------------------------------------------------------------------------------------
## library(rcellminerUtilsCDB)
load("./data/drugSynonymTab.RData")

##load("./data/drugSynonymTab.RData")
temptable=drugSynonymTab
dim(temptable)
# 738   8
# Ok clean row numbers
rownames(temptable) = 1:738

temptable[[28,1]]
# [1] "ACETALAX"              "ACETOPHENOLISATIN"     "BROCATINE"             "CONTAX"               
# [5] "OXYPHENISATIN ACETATE"

temptable[[28,2]]
# [1] "614826" "59687"  "117186"

temptable[[28,4]] 
# [1] "Acetalax_NSC_59687"  "Acetalax_NSC_614826"

# correction: remove 614826 as Acetalax
temptable[[28,2]] <- c("59687","117186")
temptable[[28,4]] <- "Acetalax_NSC_59687"

## ADD Bisacodyl
n=nrow(temptable)
temptable[[n+1,1]] <- "BISACODYL" ## in upper case
temptable[[n+1,2]] <-  c("614826","755914")
temptable[[n+1,3]] <- NA
temptable[[n+1,4]] <- "Bisacodyl_NSC_614826"
temptable[[n+1,5]] <-  NA
temptable[[n+1,6]] <- NA
temptable[[n+1,7]] <- NA
temptable[[n+1,8]] <- NA
  
  
    
drugSynonymTab=temptable

# save new drug synonyms
save(drugSynonymTab, file = "data/drugSynonymTab.RData")
## end
