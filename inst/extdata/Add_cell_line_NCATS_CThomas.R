#--------------------------------------------------------------------------------------------------
#Adding nes data source: TNCATS = NCATS from Craig Thomas
# 
#--------------------------------------------------------------------------------------------------
# There are 183 cell lines
#
# ---------------------------------------------------------

library(rcellminerUtilsCDB)
 
currenttable=rcellminerUtilsCDB::cellLineMatchTab
dim(currenttable) # 1831 - 20

# pre-processed 
m=read.delim("./inst/extdata/NCATS_183_cells_Oncotypes_curated_june23.txt",stringsAsFactors = F)
dim(m) # 183 - 10

k=which(is.na(m$source)); length(k) # 69 new cell lines and 114 existing

# new column and new cell lines
currenttable$tncats = NA
# add new 69 cell lines
currenttable[1832:1900,] = NA
currenttable[1832:1900,"tncats"] = m$cell_name_ncats[k]
##-----------
# matching the 114 cell lines
table(m$source)
# ccle       gdsc genSarcoma    genSclc mdAnderson 
# 98         11          2          1          2 

iccle = which(m$source=="ccle")
igdsc =  which(m$source=="gdsc")
igsarc =  which(m$source=="genSarcoma")
igsclc =  which(m$source=="genSclc")
imdand =  which(m$source=="mdAnderson")

ind.ccle = match(m$Cell_Name_source[iccle],currenttable$ccle); length(ind.ccle) #98
currenttable[ind.ccle,"tncats"] = m$cell_name_ncats[iccle]
View(currenttable[ind.ccle,c("ccle","tncats")])

ind.gdsc = match(m$Cell_Name_source[igdsc],currenttable$gdscDec15); length(ind.gdsc) #11
currenttable[ind.gdsc,"tncats"] = m$cell_name_ncats[igdsc]
View(currenttable[ind.gdsc,c("gdscDec15","tncats")])

ind.gsarc = match(m$Cell_Name_source[igsarc],currenttable$genSarcoma); length(ind.gsarc) #2
currenttable[ind.gsarc,"tncats"] = m$cell_name_ncats[igsarc]
View(currenttable[ind.gsarc,c("genSarcoma","tncats")])

ind.gsclc = match(m$Cell_Name_source[igsclc],currenttable$genSclc); length(ind.gsclc) #1
currenttable[ind.gsclc,"tncats"] = m$cell_name_ncats[igsclc]
View(currenttable[ind.gsclc,c("genSclc","tncats")])

ind.mdand = match(m$Cell_Name_source[imdand],currenttable$mdaMills); length(ind.mdand) #2
currenttable[ind.mdand,"tncats"] = m$cell_name_ncats[imdand]
View(currenttable[ind.mdand,c("mdaMills","tncats")])

length(which(!is.na(currenttable$tncats))) # 183
dim(currenttable) # 1900 - 21
cellLineMatchTab <- currenttable

save(cellLineMatchTab, file = "data/cellLineMatchTab.RData")

## END

















