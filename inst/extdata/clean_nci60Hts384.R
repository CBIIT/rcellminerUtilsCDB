#--------------------------------------------------------------------------------------------------
# remove drugs with plateau in drug matching table 
#   
## drug data -------------------------------------------------------

dtable = rcellminerUtilsCDB::drugSynonymTab 
dim(dtable) # 2986   23

length(which(!is.na(dtable$nci60Hts384))) # 751

# read drug with plateau at 80%
hts384 = read.csv("inst/extdata/hts384-drug-with-plateau.csv", stringsAsFactors = F, row.names = 1)
dim(hts384) # 960 2

## 1/ remove  drugs with plateau ------------------------------------------
idx = which(hts384$plateau)
length(idx) # 97

nscs = rownames(hts384)[idx]

k = match(nscs, dtable$nci60Hts384)
length(which(is.na(k))) # 27

for (i in 1:length(k)) {
  if (!is.na(k[i])) dtable[[k[i],"nci60Hts384"]] = NA
}

# additional with 2 drugs
dtable[[72,"nci60Hts384"]] = NA            # origin: 772254, 772255
dtable[[541,"nci60Hts384"]] = "755984"     # origin: 754230, 755984

length(which(!is.na(dtable$nci60Hts384))) # 680



####  saving  ------------------------------

# View(dtable[hts384$curated_index,c(1:2,23)])
drugSynonymTab = dtable
save(drugSynonymTab, file = "data/drugSynonymTab.RData")

## END
## stop here ----------------------





















