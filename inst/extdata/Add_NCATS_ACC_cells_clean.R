#--------------------------------------------------------------------------------------------------
#Adding 3 cell lines to NCATS and cleaning duplicates cell lines
# 
#--------------------------------------------------------------------------------------------------
# 1) There are 3 cell lines: "CU-ACC1", "CU-ACC2" and "NCI-H295R"
#
# ---------------------------------------------------------
 
tmpEnv <- new.env()
load("data/cellLineMatchTab.RData", envir = tmpEnv)

# 
currenttable= tmpEnv$cellLineMatchTab
dim(currenttable) # 2100 - 26

## ADD Cellosaurus information from Augustin ---------------------------------------------------------

newtable = read.delim("inst/extdata/tmp_cellline_match.txt", check.names = F, stringsAsFactors = F)
dim(newtable) # 2100 - 28

stopifnot(identical(colnames(currenttable), colnames(newtable)[1:26])) ## TRUE

for (k in 1:26) {
  print(identical(currenttable[,k],newtable[,k]))
}

currenttable$cellosaurus_accession = newtable$cellosaurus_accession
currenttable$cellosaurus_identifier = newtable$cellosaurus_identifier 

dim(currenttable) # 2100 - 28
stopifnot(identical(colnames(currenttable), colnames(newtable))) ## TRUE

stopifnot(identical(currenttable, newtable))
## -------------------------------------------------------------------------------------------------


# add 3 new cell lines "CUACC1" "CUACC2" "H295R"

index3 = match(c("CUACC1","CUACC2","H295R"),currenttable$acc)

currenttable$tncats[index3] = c("CU-ACC1", "CU-ACC2", "NCI-H295R")
currenttable$ancats[index3] = c("CU-ACC1", "CU-ACC2", "NCI-H295R")
dim(currenttable) # 2100 - 28


#--------------------------------------------------------------------------------------------------
# 2) cleaning dup cell lines, remove 32 lines
#
# ---------------------------------------------------------
dups = read.csv("inst/extdata/dup_36_cells.csv", check.names = F, stringsAsFactors = F)
dim(dups) # 37 - 8
i = which(dups$decision=="Yes"); length(i) # 32

dups = dups[i,]; dim(dups) # 32 - 8

currenttable2 = currenttable
dim(currenttable2) # 2100 - 28

for (k in 1:nrow(dups)) 
  {
  # index1 will be combined with index2
  # k=1
  for (j in 1:ncol(currenttable2)) {
    temp = union(currenttable2[dups$index1[k],j],currenttable2[dups$index2[k],j])
    if (length(temp)>1) temp = na.omit(temp)
    currenttable2[dups$index1[k],j] = temp
  }
  
}

dim(currenttable2) # 2100   28
# View(currenttable2) 
## 
# View(currenttable[dups$index1,]) # old 
# View(currenttable2[dups$index1,]) # new
# View(currenttable2[dups$index2,]) # to remove

currenttable2 = currenttable2[-dups$index2,]
dim(currenttable2) # 2068 - 28
# View(currenttable2) 

## END ======================


rownames(currenttable2) = 1:nrow(currenttable2)

cellLineMatchTab <- currenttable2

save(cellLineMatchTab, file = "data/cellLineMatchTab.RData")

## END

















