#--------------------------------------------------------------------------------------------------
#Adding new data source: zurich 3 cell lines
#   
#--------------------------------------------------------------------------------------------------

# library(rcellminerUtilsCDB)
 
currenttable=rcellminerUtilsCDB::cellLineMatchTab
dim(currenttable) # 2100 37

## wurzburg  cell line JIL-2266 ---------------------------------


currenttable$pdxEwing = currenttable$pdxSarcoma
dim(currenttable) # 2100   38

oldnames = c("SJ18_1" ,  "SJ18_2" ,  "SJ18_3" ,  "SJ49_1"  , "SJ49_2"  , "SJ49_3" , 
              "SJ17_1"  , "SJ17_2" ,  "SJ17_3" ,  "OH1_1"  ,  "OH1_2" ,   "OH1_3" ,
              "NCI21_1" , "NCI21_2", "NCI21_3" , "OH4_1"  ,  "OH4_2" ,   "OH4_3"  ,
              "NCI21R_1", "NCI21R_2", "NCI21R_3" )

newnames = c("SJEW-18-09520_1"," SJEW-18-09520_2"," SJEW-18-09520_3",
             "SJEWS049193_X1_1","SJEWS049193_X1_2","SJEWS049193_X1_3",
             "SJEWS-17-06841_1","SJEWS-17-06841_2","SJEWS-17-06841_3",
             "NCH-EWS-1_1","NCH-EWS-1_2","NCH-EWS-1_3",
             "XEN-EWS-021_1","XEN-EWS-021_2","XEN-EWS-021_3",
             "NCH-EWS-4_1","NCH-EWS-4_2","NCH-EWS-4_3", NA, NA, NA)

ind = match(oldnames, currenttable$pdxEwing)
View(currenttable[ind,])
currenttable$pdxEwing[ind] = newnames
View(currenttable[ind,])


# saving

dim(currenttable) # 2100 37
cellLineMatchTab <- currenttable

save(cellLineMatchTab, file = "data/cellLineMatchTab.RData")

## END
## stop here ----------------------





















