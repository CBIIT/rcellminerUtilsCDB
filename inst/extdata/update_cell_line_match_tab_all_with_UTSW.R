#--------------------------------------------------------------------------------------------------
# UPDATE ORIGINAL TABLE
# we will update all table adding the Gordo Mills cell lines and moving fro 1520 row to
# 1744
#--------------------------------------------------------------------------------------------------
library(rcellminerUtilsCDB)
 
currenttable=rcellminerUtilsCDB::cellLineMatchTab
dim(currenttable) # 1773 9
currenttable = data.frame(apply(currenttable,2,as.character),stringsAsFactors = F)

utsw.info=read.delim("inst/extdata/Matching_UTSW_70_SCLC.txt",stringsAsFactors = F)
dim(utsw.info) # 70 - 6 ##
utsw=replicate(nrow(currenttable),NA)
 
# add the 41 NCI matching
## better do for
for (k in 1:41) {
 index=which(as.character(currenttable$nciSclc) == utsw.info$NCI.SCLC[k])
 utsw[index]=utsw.info$UTSW[k]
}

# add other 9 
 index9=utsw.info$INDEX_Utils_table[62:70]
 utsw[index9]=utsw.info$UTSW[62:70]
 
 currenttable$utsw=utsw
 
 # now new ones
 
mnew20=data.frame(matrix(NA,20,10))
mnew20[,10]=utsw.info$UTSW[42:61]
colnames(mnew20)=colnames(currenttable)

tablenew=rbind(currenttable,mnew20)
dim(tablenew) # 1793 10

# do we need to have factors?
# annotnew$almanac <-  annotnew$nci60



cellLineMatchTab <- tablenew
save(cellLineMatchTab, file = "data/cellLineMatchTab.RData")

#--------------------------------------------------------------------------------------------------
