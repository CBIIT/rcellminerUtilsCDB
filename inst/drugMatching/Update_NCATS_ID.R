#--------------------------------------------------------------------------------------------------
# LOAD DATA
#--------------------------------------------------------------------------------------------------
library(rcellminerUtilsCDB)

#--------------------------------------------------------------------------------------------------
# 1 change ID for 2665 NCATS drugs without synonyms in NCATS 
# 2 change ID for 7 paired synonyms


drugSynonymTab <- rcellminerUtilsCDB::drugSynonymTab 
dim(drugSynonymTab) # 2888   15
# otable = drugSynonymTab
#
stopifnot(identical(drugSynonymTab$tncats, drugSynonymTab$ancats))

length(which(!is.na(drugSynonymTab$tncats) &  !is.na(drugSynonymTab$nci60))) # 664
length(which(!is.na(drugSynonymTab$tncats))) # 2672
length(unlist(drugSynonymTab$tncats[!is.na(drugSynonymTab$tncats)])) # 2679

# 1 read new ID
mylist = read.csv("./inst/drugMatching/Ncats_newID_nosyn.csv", stringsAsFactors = F)
dim(mylist) # 2665 - 4

k= match(mylist$cellminer_compound_name, drugSynonymTab$tncats)
length(which(is.na(k))) ## zero

for (i in 1:nrow(mylist)) {
   drugSynonymTab$tncats[[k[i]]] = trimws(mylist$display_name[i])
   drugSynonymTab[[k[i],1]] = union(drugSynonymTab[[k[i],1]],toupper(trimws(mylist$display_name[i])))
}


## 2 correct 
#--------------------------------------------------------------------------------------------------
# those are synonym in NCATS
# -----------------------------

# Pacritinib;Sb1518              >> 486            >> c("pacritinib","sb1518")
# Pilaralisib analog;PILARALISIB >> 688            >> c("xl-147 analog","pilaralisib")
# Brivanib alaninate;Brivanib    >> 744            >> c("brivanib alaninate","brivanib")
# AZD-1152-HQPA ;Barasertib      >> 755            >> c("azd-1152-hqpa","barasertib")
# Gdc-0623;Cobimetinib           >> 895            >> c("gdc-0623","cobimetinib")
# VISTUSERTIB;AZD-2014           >> 898            >> c("vistusertib","ku-0063794")
# VOXTALISIB;XL-765              >> 970            >> c("voxtalisib","xl-765")
##

## ------------------------------------------------------------
drugSynonymTab[[486,"tncats"]] = c("pacritinib","sb1518")
drugSynonymTab[[486,1]] = union(drugSynonymTab[[486,1]],toupper(drugSynonymTab[[486,"tncats"]]))
 
drugSynonymTab[[688,"tncats"]] = c("xl-147 analog","pilaralisib")
drugSynonymTab[[688,1]] = union(drugSynonymTab[[688,1]],toupper(drugSynonymTab[[688,"tncats"]]))

drugSynonymTab[[744,"tncats"]] = c("brivanib alaninate","brivanib")
drugSynonymTab[[744,1]] = union(drugSynonymTab[[744,1]],toupper(drugSynonymTab[[744,"tncats"]]))

drugSynonymTab[[755,"tncats"]] = c("azd-1152-hqpa","barasertib")
drugSynonymTab[[755,1]] = union(drugSynonymTab[[755,1]],toupper(drugSynonymTab[[755,"tncats"]]))

drugSynonymTab[[895,"tncats"]] = c("gdc-0623","cobimetinib")
drugSynonymTab[[895,1]] = union(drugSynonymTab[[895,1]],toupper(drugSynonymTab[[895,"tncats"]]))

drugSynonymTab[[898,"tncats"]] = c("vistusertib","ku-0063794")
drugSynonymTab[[898,1]] = union(drugSynonymTab[[898,1]],toupper(drugSynonymTab[[898,"tncats"]]))

drugSynonymTab[[970,"tncats"]] = c("voxtalisib","xl-765")
drugSynonymTab[[970,1]] = union(drugSynonymTab[[970,1]],toupper(drugSynonymTab[[970,"tncats"]]))

  
#
dim(drugSynonymTab) # 2888 15

drugSynonymTab$ancats = drugSynonymTab$tncats
stopifnot(identical(drugSynonymTab$tncats, drugSynonymTab$ancats))


## End saving

save(drugSynonymTab, file = "data/drugSynonymTab.RData")

