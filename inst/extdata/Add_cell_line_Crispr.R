#--------------------------------------------------------------------------------------------------
#Adding new data source: Achilles
# 
#--------------------------------------------------------------------------------------------------
# There are 769 cell lines
#
# ---------------------------------------------------------

library(rcellminerUtilsCDB)
 
currenttable=rcellminerUtilsCDB::cellLineMatchTab
dim(currenttable) # 1900 - 21

# read curated info

# info available for 579 matching ccle
m=read.delim("./inst/extdata/Crispr_769_sample_ccle_info.txt",stringsAsFactors = F)
dim(m) # 769 - 33

# matching info for remaining 190 cell lines
m190 = read.delim("./inst/extdata/Matching_190_samples_v2_curated.txt",stringsAsFactors = F, row.names = 1)
dim(m190) # 190 - 8

# new column and new cell lines
currenttable$achilles = NA
dim(currenttable) # 1900 22

## start with matching CCLE

iccle = which(!is.na(m$cdb.name)); length(iccle) # 579
ccle.cdbname = m$cdb.name[iccle]
achilles.name = m$stripped_cell_line_name[iccle]

ind.ccle  = match(ccle.cdbname,currenttable$ccle)
length(which(!is.na(ind.ccle))) # 579
currenttable$achilles[ind.ccle] = achilles.name

## now remaining matched

m190uniq = unique(m190); dim(m190uniq) # 44 8
m190uniq = m190uniq[-1,] ## remove first row with all NA
dim(m190uniq) # 43 - 8

nba = apply(m190uniq,2,function(x) length(which(is.na(x))))
j= which(nba == 43 | nba==0)

m190uniq = m190uniq[,-j]; dim(m190uniq) # 43 -5

ind2 = apply(m190uniq,1, function(x) max(x,na.rm=T))
m190uniq$index = ind2

## found error in matching GDSC HEC-1 to CCLE HEC-1-B
## HEC1 should be new row with matching Achilles and GDSC
m190uniq[16,]
# igdsc imda igenSarcoma incats iccle index
# HEC1   115   NA          NA     NA    NA   115

m190uniq = m190uniq[-16,]; dim(m190uniq) # 42 - 6

currenttable$achilles[m190uniq$index] = rownames(m190uniq)

## Now add new cell lines

newcells = setdiff(rownames(m190),rownames(m190uniq))
length(newcells) # 148

# add new 148 cell lines
currenttable[1901:2048,] = NA
currenttable[1901:2048,"achilles"] = newcells
##-----------
# correct HEC-1 for GDSC

currenttable[115,c("gdscDec15","achilles")]
#     gdscDec15 achilles
# 115     HEC-1    HEC1B
currenttable[1945,c("gdscDec15","achilles")]
#        gdscDec15 achilles
# 1945      <NA>     HEC1

currenttable[115,"gdscDec15"] = NA
currenttable[1945,"gdscDec15"] = "HEC-1"

length(which(!is.na(currenttable$achilles))) # 769
length(which(!is.na(currenttable$gdscDec15))) # 1080
## 
## TK10 to CCLE
currenttable[60,c("gdscDec15","ccle")]
#      gdscDec15 ccle
# 60      TK10   NA>
currenttable[60,"ccle"] = "TK10"
## END ======================

dim(currenttable) # 2048 - 22
cellLineMatchTab <- currenttable

save(cellLineMatchTab, file = "data/cellLineMatchTab.RData")

## END

















