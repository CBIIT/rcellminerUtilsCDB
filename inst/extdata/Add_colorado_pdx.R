#--------------------------------------------------------------------------------------------------
#Adding new data source: colorado cell lines
#  and pdx Sarcoma samples
#--------------------------------------------------------------------------------------------------
# There are 4 cell lines
#
# ---------------------------------------------------------

# library(rcellminerUtilsCDB)
 
currenttable=rcellminerUtilsCDB::cellLineMatchTab
dim(currenttable) # 2068 30 

## colorado cell lines ---------------------------------
cu = c("CUACC1","CUACC2","H295R")
currenttable$colorado = NA
dim(currenttable) # 2068 - 31

ind.acc  = match(cu,currenttable$acc)
length(which(!is.na(ind.acc))) # 3

currenttable$colorado[ind.acc] = cu

## pdxSarcoma samples ---------------------------------

currenttable$pdxSarcoma = NA
dim(currenttable) # 2068 - 32

## no need to add the samples, this is just for cellminercdb code
pdxs = c("SJ18_1","SJ18_2",   "SJ18_3",   "SJ49_1",   "SJ49_2",   "SJ49_3",   "SJ17_1"  , "SJ17_2" ,  "SJ17_3", 
        "OH1_1" ,   "OH1_2" ,   "OH1_3",    "NCI21_1",  "NCI21_2",  "NCI21_3",  "OH4_1",    "OH4_2",    "OH4_3",   
        "NCI21R_1", "NCI21R_2", "NCI21R_3")

currenttable[2069:2089,] = NA
currenttable[2069:2089,"pdxSarcoma"] = pdxs
dim(currenttable) # 2089 32
cellLineMatchTab <- currenttable

save(cellLineMatchTab, file = "data/cellLineMatchTab.RData")

## END
## stop here ----------------------


## add 3 cell lines
# currenttable[2050:2052,] = NA
# currenttable[2050:2052,"acc"] = c("CUACC1","CUACC2","H295R")



















