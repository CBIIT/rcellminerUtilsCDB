#--------------------------------------------------------------------------------------------------
# UPDATE ORIGINAL TABLE with Sarcoma cell lines
# 
#--------------------------------------------------------------------------------------------------
library(rcellminerUtilsCDB)
 
currenttable=rcellminerUtilsCDB::cellLineMatchTab
dim(currenttable) # 1793 10
currenttable = data.frame(apply(currenttable,2,as.character),stringsAsFactors = F)

sarcoma.info=read.delim("inst/extdata/match_sarcoma_cells_other_curated.txt",stringsAsFactors = F)
dim(sarcoma.info) # 71 - 4 ##
sarcoma=replicate(nrow(currenttable),NA)
## 
# add the matching ones
ii=which(!is.na(sarcoma.info$correct_index)); length(ii) ## 44
sarcoma[sarcoma.info$correct_index[ii]]=sarcoma.info$CELL.LINE[ii]

## add sarcoma column
 
 currenttable$sarcoma=sarcoma
 dim(currenttable) # 1793 - 11
 # now new ones
 nn=which(is.na(sarcoma.info$correct_index)); length(nn) ## 27
 
mnew27=data.frame(matrix(NA,27,11))
mnew27[,11]=sarcoma.info$CELL.LINE[nn]
colnames(mnew27)=colnames(currenttable)

tablenew=rbind(currenttable,mnew27)
dim(tablenew) # 1820 11

# Correct cell line A549/ATCC for nciSclc
tablenew$nciSclc[36]=tablenew$nciSclc[1504]
tablenew2=tablenew[-1504,] # remove 1504
dim(tablenew2) # 1819 11
#
cellLineMatchTab <- tablenew2
save(cellLineMatchTab, file = "data/cellLineMatchTab.RData")

#--------------------------------------------------------------------------------------------------
