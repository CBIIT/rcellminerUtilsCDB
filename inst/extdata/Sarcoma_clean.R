#--------------------------------------------------------------------------------------------------
# cleaning Sarcoma Sarcoma matching cell lines, REMOVE 2 ROWS
# 
#--------------------------------------------------------------------------------------------------
#  LS141 == LPS141
#  RH18 == RH18DM
# ---------------------------------------------------------
 
tmpEnv <- new.env()
load("data/cellLineMatchTab.RData", envir = tmpEnv)

# 
currenttable= tmpEnv$cellLineMatchTab
dim(currenttable) # 2099 - 35


## -------------------------------------------------------------------------------------------------


# "LPS141","RH18DM" from Achilles already exist in Sarcoma 

index1 = match(c("LS141","Rh18"),currenttable$uniSarcoma)
index2 = match(c("LPS141","RH18DM"),currenttable$achilles)

currenttable$achilles[index1] = currenttable$achilles[index2] 

dim(currenttable) # 2099 - 35


#--------------------------------------------------------------------------------------------------
# 2) cleaning dup cell lines, remove 2 lines
#
# ---------------------------------------------------------
currenttable = currenttable[-index2,]
dim(currenttable) # 2097 - 35
# View(currenttable) 

## END ======================


rownames(currenttable) = 1:nrow(currenttable)

cellLineMatchTab <- currenttable

save(cellLineMatchTab, file = "data/cellLineMatchTab.RData")

## END

















