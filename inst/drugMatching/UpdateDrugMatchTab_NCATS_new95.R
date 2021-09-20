#--------------------------------------------------------------------------------------------------
# LOAD DATA
#--------------------------------------------------------------------------------------------------
library(rcellminerUtilsCDB)

#--------------------------------------------------------------------------------------------------
# Add new 95 NCATS with match to NCI60 NSC (tncats, ancats)
#--------------------------------------------------------------------------------------------------
drugSynonymTab <- rcellminerUtilsCDB::drugSynonymTab 
dim(drugSynonymTab) # 3064   15
#
stopifnot(identical(drugSynonymTab$tncats, drugSynonymTab$ancats))
k= which(!is.na(drugSynonymTab$tncats))
length(drugSynonymTab$tncats[k]) # 2671
length(unlist(drugSynonymTab$tncats[k])) # 2679

length(which(!is.na(drugSynonymTab$tncats) &  !is.na(drugSynonymTab$nci60))) # 556

# read new 95 matches
d95 = read.delim("./inst/drugMatching/NCATS_NSC_New95_matches_June3_2021_curated.txt", stringsAsFactors = F)
dim(d95) # 95 - 19

length(unique(d95$compound_name)) #95
length(unique(d95$nsc)) #95

nscs = trimws(unlist(strsplit(d95$nsc,","))); length(nscs) # 107

# # i = which(d95$compound_name %in% drugSynonymTab$tncats)
# j=  match(d95$compound_name, drugSynonymTab$tncats)
# # 65 missing 
# d95$compound_name[65]# Pacritinib

# find index of new 95 drugs in drug table
j2 = unlist(apply(array(d95$compound_name),1, function(x) grep(x, drugSynonymTab$tncats, fixed=T)))
length(j2) # 95
View(drugSynonymTab[j2,])

# now be sure that all nscs did not exist
j3 = unlist(apply(array(nscs),1, function(x) paste(x,grep(x, drugSynonymTab$nci60, fixed=T))))
# 897 partial match after checking >> no matching

j3b = unlist(apply(array(nscs),1, function(x) paste(x,grep(x, drugSynonymTab$NAME_SET, fixed=T))))
# 897, every thing OK , no new NSC already exits...

## so ADD new nsc and synonyms
k=1
for (n in 1:length(j2)) {
   
   ## drugSynonymTab[[n, "nci60"]] <- d95$nsc[k]
   synlist = toupper(trimws(unlist(strsplit(d95$synonyms[k],"|",fixed=T))))
   nsclist = trimws(unlist(strsplit(d95$nsc[k],",",fixed=T)))
   namelist = toupper(trimws(unlist(strsplit(d95$name[k],",",fixed=T))))
   drugSynonymTab[[j2[n], "nci60"]] <- nsclist
   drugSynonymTab[[j2[n], 1]] <-  union(namelist,union(toupper(d95$compound_name[k]),union(synlist,nsclist)))
   k = k+1
}


## End saving

dim(drugSynonymTab) # no change in dimension and added 95 new matched compounds 

save(drugSynonymTab, file = "data/drugSynonymTab.RData")

