#--------------------------------------------------------------------------------------------------
#Adding new data source: GDSC1 and GDSC2 
# 
#--------------------------------------------------------------------------------------------------
# There are 970 and 969 cell lines
#
# ---------------------------------------------------------
cann1 = read.csv("./inst/extdata/gdsc1_cell_ann_curated.csv", row.names = 1, stringsAsFactors = F, check.names = F)
cann2 = read.csv("./inst/extdata/gdsc2_cell_ann_curated.csv", row.names = 1, stringsAsFactors = F, check.names = F) # 7 news

dim(cann1); dim(cann2)
# 970 - 24 ; 969 - 24 

# length(intersect(cann1$Sample.Name, gdsc1Data::drugData@sampleData@samples$Name)) # 970
# length(intersect(cann2$Sample.Name, gdsc2Data::drugData@sampleData@samples$Name)) # 969

 
ctable=rcellminerUtilsCDB::cellLineMatchTab
dim(ctable) # 2068 - 28

## GDSC1------------------------------------------------------------
ctable$gdsc1 = NA

ind1 = match(cann1$Sample.Name.Old, ctable$gdscDec15)
## notf1 =which(is.na(ind1)) # zero
# kk = which(cann1$Sample.Name!=cann1$Sample.Name.Old)
# View(cann1[kk,])
##
ctable$gdsc1[ind1] = cann1$Sample.Name

## GDSC2 -----------------------------------------------------------
ctable$gdsc2 = NA
ind2 = match(cann2$Sample.Name.Old, ctable$gdscDec15)
notf2 = which(is.na(ind2)) 
length(notf2) # 7

ctable$gdsc2[ind2[-notf2]] = cann2$Sample.Name[-notf2]
# new ones to dec15

cvcls = cann2$`cellosaurus ID`[which(cann2$`cellosaurus ID`!="")]
newc = cann2$Sample.Name[which(cann2$`cellosaurus ID`!="")]
ind3 = match(cvcls, ctable$cellosaurus_accession)

ctable$gdsc2[ind3] = newc

# View(ctable[ind3,])
## OK done for both datasets !!!
length(which(!is.na(ctable$gdsc1))) # 970
length(which(!is.na(ctable$gdsc2))) # 969

length(which(!is.na(ctable$gdsc1) & !is.na(ctable$gdsc2) )) # 961
## ======================

dim(ctable) # 2068   30
cellLineMatchTab <- ctable

save(cellLineMatchTab, file = "data/cellLineMatchTab.RData")

## END

















