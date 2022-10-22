#--------------------------------------------------------------------------------------------------
# Match GDSC1 and GDSC2 drugs to NCI60 / other drug sources
#--------------------------------------------------------------------------------------------------

dtable = rcellminerUtilsCDB::drugSynonymTab 
dim(dtable) # 2883  18

length(which(!is.na(dtable$gdscDec15))) # 259

dtable$gdsc1 = vector(mode = "list", length =nrow(dtable) )
dtable$gdsc2 = vector(mode = "list", length =nrow(dtable) )

for (k in 1:nrow(dtable)) {
  dtable$gdsc1[[k]]=NA
  dtable$gdsc2[[k]]=NA
}
length(which(!is.na(dtable$gdsc1))) # 0

dim(dtable) # 2883   20

## read curated files
##--------------------- GDSC1 ---------------------------------------------------------------------

gdsc1.table = read.csv("inst/drugMatching/gdsc1.drugs.matches.curated.csv", stringsAsFactors = F, check.names = F)
dim(gdsc1.table) # 402 7

gdsc1.table$index.dtable.curated = as.numeric(gdsc1.table$index.dtable.curated)
idx = which(!is.na(gdsc1.table$index.dtable.curated)); length(idx) # 321
length(unique(gdsc1.table$index.dtable.curated[idx])) # 293
length(which(duplicated(gdsc1.table$index.dtable.curated[idx]))) # 28
## one drug has 3 synonyms 
# View(gdsc1.table[idx,])

# for view
# for (k in 1: length(idx)) dtable[[gdsc1.table$index.dtable.curated[idx[k]], "gdsc1"]] <- gdsc1.table$d.extname[idx[k]]

# real change -----------------------------------------------------
for (k in 1: length(idx)) {
  if (is.na(dtable[[gdsc1.table$index.dtable.curated[idx[k]], "gdsc1"]]))  { dtable[[gdsc1.table$index.dtable.curated[idx[k]], "gdsc1"]] <- gdsc1.table$d.extname[idx[k]] }
  else  
  { dtable[[gdsc1.table$index.dtable.curated[idx[k]], "gdsc1"]] <- c(dtable[[gdsc1.table$index.dtable.curated[idx[k]], "gdsc1"]],gdsc1.table$d.extname[idx[k]]) }
  
  dtable[[gdsc1.table$index.dtable.curated[idx[k]], 1]] = union(dtable[[gdsc1.table$index.dtable.curated[idx[k]], 1]], toupper(gdsc1.table$d.name[idx[k]])) # name without extension
}

v= which(!is.na(dtable$gdsc1)); length(v) # 293 # 321 with syn
View(dtable[v,c(1,4,15,18,19)])

## seems OK 
## 3 merges at the end after gdsc2 --------------------------------------------------

##--------------------- GDSC2 ---------------------------------------------------------------------
gdsc2.table = read.csv("inst/drugMatching/gdsc2.drugs.matches.curated.csv", stringsAsFactors = F, check.names = F)
dim(gdsc2.table) # 295 7

gdsc2.table$index.dtable.curated = as.numeric(gdsc2.table$index.dtable.curated)
idx2 = which(!is.na(gdsc2.table$index.dtable.curated)); length(idx2) # 205
length(unique(gdsc2.table$index.dtable.curated[idx2])) # 194
length(which(duplicated(gdsc2.table$index.dtable.curated[idx2]))) # 11

dtable2 = dtable
## for view
for (k in 1: length(idx2)) ## dtable2[[gdsc2.table$index.dtable.curated[idx2[k]], "gdsc2"]] <- gdsc2.table$d.extname[idx2[k]]
{
  if (is.na(dtable2[[gdsc2.table$index.dtable.curated[idx2[k]], "gdsc2"]]))  { dtable2[[gdsc2.table$index.dtable.curated[idx2[k]], "gdsc2"]] <- gdsc2.table$d.extname[idx2[k]] }
  else  
  { dtable2[[gdsc2.table$index.dtable.curated[idx2[k]], "gdsc2"]] <- c(dtable2[[gdsc2.table$index.dtable.curated[idx2[k]], "gdsc2"]],gdsc2.table$d.extname[idx2[k]]) }
  
  dtable2[[gdsc2.table$index.dtable.curated[idx2[k]], 1]] = union(dtable2[[gdsc2.table$index.dtable.curated[idx2[k]], 1]], toupper(gdsc2.table$d.name[idx2[k]])) # name without extension
  
}

v2= which(!is.na(dtable2$gdsc2)); length(v2) # 194 #  205 with syn
View(dtable2[v2,c(1,4,15,18,19,20)])
## seems OK

##--------------------- Merge from gdsc1 (3 rows) ---------------------------------------------------------------------
im = which(!is.na(gdsc1.table$merge))
View(gdsc1.table[im,])
# 575 <- 959
# 475 <- 982
# 707 <- 1575

dmerge <- function(drugSynonymTab, targetind, mergeind) {
  for (k in 1:ncol(drugSynonymTab)) {
    # print(drugSynonymTab[targetind,k])
    # print(drugSynonymTab[mergeind,k])
    
    
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

imerge = c()
for (ii in 1:length(im)) {
  dtable2 <- dmerge(dtable2, gdsc1.table$index.dtable.curated[im[ii]], gdsc1.table$merge[im[ii]] )
  imerge = c(imerge,gdsc1.table$merge[im[ii]])
  cat("row ",ii, " processed.\n")
}

dim(dtable2) # 2883 20
# View(dtable2)
## remove the 3 merged ones
imerge
dtable2 = dtable2[-imerge,]
dim(dtable2)
rownames(dtable2) = 1:nrow(dtable2)
#### -----------------

## 

drugSynonymTab = dtable2

save(drugSynonymTab, file = "data/drugSynonymTab.RData")

