#--------------------------------------------------------------------------------------------------
# LOAD DATA
#--------------------------------------------------------------------------------------------------
library(rcellminerUtilsCDB)

#--------------------------------------------------------------------------------------------------
# UPDATE with NCATS Craig Thomas drugs
#--------------------------------------------------------------------------------------------------
drugSynonymTab <- rcellminerUtilsCDB::drugSynonymTab 
dim(drugSynonymTab) # 762 - 12
#
drugSynonymTab$tncats = vector(mode = "list", length =nrow(drugSynonymTab) )

for (k in 1:nrow(drugSynonymTab)) drugSynonymTab$tncats[[k]]=NA
dim(drugSynonymTab) # 762 13
## reading NCATS drug data
## 
m=read.delim("./inst/extdata/NCATSNSC_matches_CDB_June23_529drugs_bycas.txt",stringsAsFactors = F)
dim(m) # 529 - 22
n=nrow(drugSynonymTab)
nm= nrow(m) 
## try to match based on first nsc if found add ncats name in the synonym list
# k=323

cntl = c()

for (k in 1:nm) {
 ## y= toupper(m$SAMPLE_NAME[k])
 y = unlist(strsplit(m$nsc[k],","))[1]
i <- which(vapply(drugSynonymTab$NAME_SET, function(x,item){ item %in% x },item=y, logical(1)))
cntl=c(cntl,i)
# print(i)
  
if (length(i) == 1) {
   if (is.na(drugSynonymTab[[i, "tncats"]]))   drugSynonymTab[[i, "tncats"]] <- m$compound_name[k] else drugSynonymTab[[i, "tncats"]] <- c(drugSynonymTab[[i, "tncats"]],m$compound_name[k])
  if (length(match(toupper(m$compound_name[k]),drugSynonymTab[[i, 1]]))==0) drugSynonymTab[[i, 1]] <-  c(drugSynonymTab[[i, 1]],toupper(m$compound_name[k]))
 } else
 {
   n=n+1
   drugSynonymTab[n,3:12] <- NA
   drugSynonymTab[[n, "tncats"]] <- m$compound_name[k]
   drugSynonymTab[[n, "nci60"]] <- m$nsc[k]
   synlist = toupper(unlist(strsplit(m$synonym[k],"||",fixed=T)))
   nsclist = unlist(strsplit(m$nsc[k],",",fixed=T))
   if (m$name[k]!="" & m$name[k]!=m$compound_name[k])
   { 
     drugSynonymTab[[n, 1]] <-  c(toupper(m$name[k]),toupper(m$compound_name[k]),synlist,nsclist) 
   } else
   { 
       drugSynonymTab[[n, 1]] <-  c(toupper(m$compound_name[k]),synlist,nsclist) }

   }
 cat("compound :",k," processed \n")
}


dim(drugSynonymTab) # 1130   13
length(which(!is.na(drugSynonymTab$tncats))) # 528 !! missing one no no !!
## GDC-0980, Alectinib (CH5424802) refer to the same compound
tncats = unlist(drugSynonymTab$tncats)
length(which(!is.na(tncats))) # 529

setdiff(m$compound_name,tncats) # zero OK

save(drugSynonymTab, file = "data/drugSynonymTab.RData")
#--------------------------------------------------------------------------------------------------


