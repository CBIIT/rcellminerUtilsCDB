#--------------------------------------------------------------------------------------------------
# LOAD DATA
#--------------------------------------------------------------------------------------------------
library(rcellminerUtilsCDB)

#--------------------------------------------------------------------------------------------------
# 1 Add NCATS matching drugs based on Kelli annotation 
# 2 correction:  GDC-0980; Alectinib (CH5424802) are NOT synonyms line 195, 
#   GDC-0980 is also "1032754-93-0"  "APITOLISIB"     "GDC-0980"        "GDC0980"         "UNII-1C854K1MIJ" "764091"           
#   Alectinib (CH5424802) is "1256580-46-7"    "ALECENSA" "ALECTINIB"       "CH 5424802"      "CH-5424802"      "CH5424802"   "764040"    "764821"
# 3 remove the corrected ones
#--------------------------------------------------------------------------------------------------

drugSynonymTab <- rcellminerUtilsCDB::drugSynonymTab 
dim(drugSynonymTab) # 3064   15
#
stopifnot(identical(drugSynonymTab$tncats, drugSynonymTab$ancats))

k= which(!is.na(drugSynonymTab$tncats))
length(drugSynonymTab$tncats[k]) # 2671
length(unlist(drugSynonymTab$tncats[k])) # 2679

k2= which(!is.na(drugSynonymTab$nci60))
length(drugSynonymTab$nci60[k2]) # 708
length(unlist(drugSynonymTab$nci60[k2])) # 813

length(which(!is.na(drugSynonymTab$tncats) &  !is.na(drugSynonymTab$nci60))) # 651

# function to update table ---------------------------------------------------

dmerge <- function(drugSynonymTab, targetind, mergeind, nb=15) {
   for (k in 1:nb) {
      # print(drugSynonymTab[targetind,k])
      # print(drugSynonymTab[mergeind,k])
      
      # if (!is.na(drugSynonymTab[[mergeind,k]])) {
      #    if (!is.na(drugSynonymTab[[targetind,k]]))
            
      if (length(na.omit(drugSynonymTab[[mergeind,k]]))!=0) {
         
        if (length(na.omit(drugSynonymTab[[targetind,k]]))!=0)
         drugSynonymTab[[targetind,k]] = union(drugSynonymTab[[targetind,k]], drugSynonymTab[[mergeind,k]]) else
            drugSynonymTab[[targetind,k]]  = drugSynonymTab[[mergeind,k]]
      }
      # print("done")
      # print(drugSynonymTab[targetind,k])
      # print("..........................")
   }
   return(drugSynonymTab)
}

# end function  -----------------------------------------------------------
# 1 read new matches
d177 = read.delim("./inst/drugMatching/Table_Drugs_Synonyms_Sep20_169_v2.txt", stringsAsFactors = F)
dim(d177) # 177 - 13

## xx1 = drugSynonymTab[d177$update,]; View(xx1)

length(unique(d177$update)) # 169
length(unique(d177$merge))  # 177
stopifnot(identical(d177$merge, d177$remove)) # TRUE

for (i in 1:177) {
  drugSynonymTab <- dmerge(drugSynonymTab, d177$update[i], d177$merge[i])
   cat("row ",i, " processed.\n")
}

dim(drugSynonymTab) # 3064   15

## View(drugSynonymTab[d177$update,])

## 2 correct 
## GDC-0980; Alectinib (CH5424802) are NOT synonyms , line 195
## ------------------------------------------------------------
drugSynonymTab[[195,1]] = c("1032754-93-0","APITOLISIB","GDC-0980","GDC0980","UNII-1C854K1MIJ","764091")
drugSynonymTab[[195,2]]    = "764091"
drugSynonymTab[[195,3]] = NA
drugSynonymTab[[195,4]]     = NA
drugSynonymTab[[195,5]] = NA
drugSynonymTab[[195,6]]   = "764091"
drugSynonymTab[[195,7]] = NA
drugSynonymTab[[195,8]]    = NA
drugSynonymTab[[195,9]] = NA
drugSynonymTab[[195,10]]   = "764091"
drugSynonymTab[[195,11]] = NA
drugSynonymTab[[195,12]]    = NA
drugSynonymTab[[195,13]]    = "GDC-0980"
drugSynonymTab[[195,14]] = NA
drugSynonymTab[[195,15]]    = "GDC-0980"
# New
drugSynonymTab[[3065,1]] = c("ALECTINIB (CH5424802)", "1256580-46-7","ALECENSA","ALECTINIB","CH 5424802","CH-5424802","CH5424802","764040","764821")
drugSynonymTab[[3065,2]] = c("764040","764821")
drugSynonymTab[[3065,3]] = NA
drugSynonymTab[[3065,4]] = "CH5424802"
drugSynonymTab[[3065,5]] = NA
drugSynonymTab[[3065,6]] = c("764040","764821")
drugSynonymTab[[3065,7]] = NA
drugSynonymTab[[3065,8]] = "764821"
drugSynonymTab[[3065,9]] = NA
drugSynonymTab[[3065,10]] = c("764040","764821")
drugSynonymTab[[3065,11]] = NA
drugSynonymTab[[3065,12]] = "764821"
drugSynonymTab[[3065,13]] = "Alectinib (CH5424802)"
drugSynonymTab[[3065,14]] = NA
drugSynonymTab[[3065,15]] = "Alectinib (CH5424802)"
#
dim(drugSynonymTab) # 3065 15

### ---     cleaning
## remove the merged one
## ------------------------------------------------------------
length(unique(d177$merge)) # 177

drugSynonymTab = drugSynonymTab[-d177$merge,]
dim(drugSynonymTab) # 2888 15

stopifnot(identical(drugSynonymTab$tncats, drugSynonymTab$ancats))
k= which(!is.na(drugSynonymTab$tncats))
length(drugSynonymTab$tncats[k]) # 2672
length(unlist(drugSynonymTab$tncats[k])) # 2679

length(which(!is.na(drugSynonymTab$tncats) &  !is.na(drugSynonymTab$nci60))) # 664

k2= which(!is.na(drugSynonymTab$nci60))
length(drugSynonymTab$nci60[k2]) # 701
length(unlist(drugSynonymTab$nci60[k2])) # 812


## End saving

rownames(drugSynonymTab) = 1:2888
save(drugSynonymTab, file = "data/drugSynonymTab.RData")

