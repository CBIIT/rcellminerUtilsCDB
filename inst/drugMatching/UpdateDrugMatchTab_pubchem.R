#---------------------------------------------------------------------------------------------------------
# Adding pubchem CID for nci60, gdsc1 and gdsc2 taken from original data sources: NCI DTP, GDSC1 and GDSC2
#---------------------------------------------------------------------------------------------------------
# input with pubchem CID 
nci60 = read.csv("inst/drugMatching/drug_annot_cid_v2.14.csv")
gdsc1 = read.csv("inst/drugMatching/gdsc1_drug_ann_extname.csv")
gdsc2 = read.csv("inst/drugMatching/gdsc2_drug_ann_extname.csv")

dim(nci60); dim(gdsc1); dim(gdsc2)
# 25374     5;  402   6 ; 295 8

# length(unique(gdsc1$drug_name)) # 378
# length(unique(gdsc1$extended_name)) # 402
# 
# length(unique(gdsc2$drug_name)) # 286
# length(unique(gdsc2$extended_name)) # 295

dtable = rcellminerUtilsCDB::drugSynonymTab
dim(dtable) # 2986 23

dtable$cid_gdsc1 = vector(mode = "list", length =nrow(dtable) )
dtable$cid_gdsc2 = vector(mode = "list", length =nrow(dtable) )
dtable$cid_nci60 = vector(mode = "list", length =nrow(dtable) )

for (k in 1:nrow(dtable)) 
{ 
  dtable$cid_gdsc1[[k]]=NA
  dtable$cid_gdsc2[[k]]=NA
  dtable$cid_nci60[[k]]=NA
}
dim(dtable) # 2986   26


## process gdsc1 -------------------------------------------------------

i1 = which(!is.na(dtable[,"gdsc1"])); length(i1) # 293
# View(dtable[i1,])

for (k in 1:length(i1))
{
  idx = i1[k]
  temp = dtable[[idx,"gdsc1"]]
  for (j in 1:length(temp))
  {
    ind = match(temp[j],  gdsc1$extended_name )
    if (is.na(ind)) {
      
      cat("warning:", temp[j], " not found in gdsc1 \n" )
      
    }
    else {
      if (is.na(dtable[[idx,"cid_gdsc1"]]))
        dtable[[idx,"cid_gdsc1"]] = gdsc1$pubchem[ind]
      else 
        dtable[[idx,"cid_gdsc1"]] = union(dtable[[idx,"cid_gdsc1"]], gdsc1$pubchem[ind])
    }
  }
}

# View(dtable[i1,c("NAME_SET","gdsc1","cid_gdsc1")])

#####
## process gdsc2 -------------------------------------------------------

i2 = which(!is.na(dtable[,"gdsc2"])); length(i2) # 194 
# View(dtable[i2,])

for (k in 1:length(i2))
{
  idx = i2[k]
  temp = dtable[[idx,"gdsc2"]]
  for (j in 1:length(temp))
  {
    ind = match(temp[j],  gdsc2$extended_name )
    if (is.na(ind)) {
      
      cat("warning:", temp[j], " not found in gdsc2 \n" )
      
    }
    else {
      if (is.na(dtable[[idx,"cid_gdsc2"]]))
        dtable[[idx,"cid_gdsc2"]] = unlist(strsplit(gdsc2$pubchem[ind],","))
      else 
        ## dtable[[idx,"cid_gdsc2"]] = union(gdsc2$pubchem[ind], dtable[[idx,"cid_gdsc2"]])
        dtable[[idx,"cid_gdsc2"]] = union(dtable[[idx,"cid_gdsc2"]], unlist(strsplit(gdsc2$pubchem[ind],",")) )
    }
  }
}

# View(dtable[i2,c("NAME_SET","gdsc2","cid_gdsc2")])
# View(dtable[c(i1,i2),c("NAME_SET","gdsc1","gdsc2","cid_gdsc1","cid_gdsc2")])3

### now NCI60 -------------------------------------------------------------------------------------------

i3 = which(!is.na(dtable[,"nci60"])); length(i3) # 870
# View(dtable[i3,])

for (k in 1:length(i3))
{
  idx = i3[k]
  temp = dtable[[idx,"nci60"]]
  for (j in 1:length(temp))
  {
    ind = match(temp[j],  nci60$nsc)
    if (is.na(ind)) {
      
      cat("warning:", temp[j], " not found in NCI60 \n" )
      
    }
    else {
      if (is.na(dtable[[idx,"cid_nci60"]]))
        dtable[[idx,"cid_nci60"]] = nci60$pubchem_cid[ind]
      else 
        dtable[[idx,"cid_nci60"]] = union(dtable[[idx,"cid_nci60"]], nci60$pubchem_cid[ind]  )
    }
  }
}


# View(dtable[i3,c("NAME_SET","nci60","cid_nci60")])

drugSynonymTab = dtable
save(drugSynonymTab, file = "data/drugSynonymTab.RData")




