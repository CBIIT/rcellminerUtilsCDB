#--------------------------------------------------------------------------------------------------
# LOAD DATA
#--------------------------------------------------------------------------------------------------
## library(rcellminerUtilsCDB)
retrieve= function(myvector,mystring)
{ 
  tmp=unlist(strsplit(mystring,";"))
  cat(tmp,"\n")
  for (k in 1:length(myvector))
  {  
    #cat(k," ",myvector[[k]],"\n")
    if (identical(myvector[[k]],tmp)) return(k)
  }
  return(0)
}
# res=retrieve(drugSynonymTab$nci60,"765396;727125")
#
load("./data/drugSynonymTab.RData")
#--------------------------------------------------------------------------------------------------
# UPDATE TO ADD DATA FOR OTHER IMPORTANT DRUGS
#--------------------------------------------------------------------------------------------------
mupdate=read.delim("inst/drugMatching/new_nsc_in_table_drug_synonyms.txt",stringsAsFactors = F)
dim(mupdate)
## searching drug using gdsc column
## start here
ii =apply(array(mupdate$Drug_Synonyms),1,function(x) retrieve(drugSynonymTab$NAME_SET,x))
ii=unlist(ii); length(ii) # 63
## update table
temptab=drugSynonymTab; dim(temptab) # 749 -7
rownames(temptab)=1:749

for (j in 1:61) {
  temptab[[ii[j],2]] <- unlist(strsplit(mupdate$NCI.60.private[j],";"))
  
}

# update line ii[63] and remove ii[62]
temptab[[ii[63],4]] <-  "PXD101, Belinostat"
#
temptab= temptab[-ii[62],]
dim(temptab) # 748 -7

# save new drug synonyms
drugSynonymTab=temptab
save(drugSynonymTab, file = "data/drugSynonymTab.RData")

#--------------------------------------------------------------------------------------------------


