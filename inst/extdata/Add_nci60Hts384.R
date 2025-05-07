#--------------------------------------------------------------------------------------------------
#Adding new data source: nci60Hts384 cell lines
#   
#--------------------------------------------------------------------------------------------------

# library(rcellminerUtilsCDB)
 
currenttable=rcellminerUtilsCDB::cellLineMatchTab
dim(currenttable) # 2106   38

## 58 nci60Hts384 cell lines ---------------------------------

currenttable$nci60Hts384 = currenttable$nci60
toremove  = match(c("ME:SK-MEL-2","ME:MDA-N"),currenttable$nci60Hts384)
currenttable$nci60Hts384[toremove] = NA

dim(currenttable) # 2106   39

cellLineMatchTab <- currenttable
save(cellLineMatchTab, file = "data/cellLineMatchTab.RData")

## drug data -------------------------------------------------------

dtable = rcellminerUtilsCDB::drugSynonymTab 
dim(dtable) # 2880   22

dtable$nci60Hts384 = vector(mode = "list", length =nrow(dtable) )
for (k in 1:nrow(dtable)) dtable$nci60Hts384[[k]]=NA
dim(dtable) # 2880 23

length(which(!is.na(dtable$nci60))) # 703

# add drug matching
hts384 = read.csv("inst/extdata/nci60Hts384_name_index_drugtable_v3_curated.csv", stringsAsFactors = F, row.names = 1)
dim(hts384) # 960 9

## 1/ add drug with matching NSC ------------------------------------------
idx = which(hts384$to.addinSynonyms == "no" & hts384$curated_NSC !="")
length(idx) # 470
temp1 = hts384[idx,]; dim(temp1) # 470 - 9
nscs = strsplit(temp1$curated_NSC,",")

for (k in 1: nrow(temp1)) {
  dtable[[temp1$curated_index[k], "nci60Hts384"]] = trimws(nscs[[k]])
  dtable[[temp1$curated_index[k], 1]] = union( dtable[[temp1$curated_index[k], 1]], toupper(temp1$NAME[k]) )

  if (temp1$existsNCI60[k]== TRUE) {
    if (is.na(dtable[[temp1$curated_index[k], "nci60"]]))
      dtable[[temp1$curated_index[k], "nci60"]] = trimws(nscs[[k]])
    else
      dtable[[temp1$curated_index[k], "nci60"]] = union( dtable[[temp1$curated_index[k], "nci60"]] , trimws(nscs[[k]]))
  }
  
  
  }

length(which(!is.na(dtable$nci60Hts384))) # 470
length(which(!is.na(dtable$nci60))) # 705

## 2/ add drug with matching names
idx2 = which(hts384$to.addinSynonyms == "yes" & hts384$curated_NSC !="")
length(idx2) # 183
temp2 = hts384[idx2,]; dim(temp2) # 183 - 9
nscs2 = strsplit(temp2$curated_NSC,",")

for (k in 1: nrow(temp2)) {
  if ( is.na(dtable[[temp2$curated_index[k], "nci60Hts384"]]) ) dtable[[temp2$curated_index[k], "nci60Hts384"]] = trimws(nscs2[[k]]) 
  else 
    dtable[[temp2$curated_index[k], "nci60Hts384"]] = union(dtable[[temp2$curated_index[k], "nci60Hts384"]],  trimws(nscs2[[k]]) ) 
  # add to nci60
  if (temp2$toadd.NCI60[k]=="yes") {
    if (is.na(dtable[[temp2$curated_index[k], "nci60"]]))
      dtable[[temp2$curated_index[k], "nci60"]] = trimws(nscs2[[k]])
      else
        dtable[[temp2$curated_index[k], "nci60"]] = union( dtable[[temp2$curated_index[k], "nci60"]] , trimws(nscs2[[k]]))
  }
  # add ncs to synonym
  dtable[[temp2$curated_index[k], 1]] = union(dtable[[temp2$curated_index[k], 1]], trimws(nscs2[[k]]))
  
}

length(which(!is.na(dtable$nci60Hts384))) # 645 ? vs653
length(which(!is.na(dtable$nci60))) # 764
## 3/ add new drug in bothnci60 classic and nsc60 hts384
n = nrow(dtable)+1

idx3 = which(hts384$to.addinSynonyms == "new" & hts384$curated_NSC !="" & hts384$existsNCI60 == T & hts384$NAME != "")
length(idx3) # 106
temp3 = hts384[idx3,]; dim(temp3) # 106 9
nscs3 = strsplit(temp3$curated_NSC,",")

for (k in 1: nrow(temp3)) {
  dtable[[n, "nci60Hts384"]] = trimws(nscs3[[k]])
  # add to nci60
  dtable[[n, "nci60"]] = trimws(nscs3[[k]])
  # add to synonym
  dtable[[n, 1]] = union(temp3$NAME[k], trimws(nscs3[[k]]) )
  for (t in c(3:22)) dtable[[n,t]] = NA
  n = n + 1
}
length(which(!is.na(dtable$nci60Hts384))) # 645 + 106
length(which(!is.na(dtable$nci60))) # 870
## 4  correct 295 nciSclc 772992 + synonym list (vs 1833)
# dtable[295,]  
dtable[[295,"nciSclc"]] = NA ## this is piceatannol
dtable[[295,1]] = c("365798", "PICEATANNOL" ,"TRANS-PICEATANNOL" ,"ASTRINGENIN") ## to recheck

# dtable[1833,]
dtable[[1833,"nciSclc"]] = "772992" # this is fostamatinib
dtable[[1833,1]] = union(dtable[[1833,1]], c("FOSTAMATINIB(R788)","R-788","R788","901119-35-5","UNII-SQ8A3S5101"))

# View(dtable[hts384$curated_index,c(1:2,23)])
drugSynonymTab = dtable
save(drugSynonymTab, file = "data/drugSynonymTab.RData")

## END
## stop here ----------------------





















