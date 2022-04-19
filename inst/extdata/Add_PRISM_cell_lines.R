#--------------------------------------------------------------------------------------------------
#Adding new data source: prism
# 
#--------------------------------------------------------------------------------------------------
# There are 480 cell lines
#
# ---------------------------------------------------------

library(rcellminerUtilsCDB)
 
celltable=rcellminerUtilsCDB::cellLineMatchTab
dim(celltable) # 2100 - 25


# new column and new cell lines
celltable$prism = NA
dim(celltable) # 2100 - 26

cellinfo  = read.csv("./inst/extdata/prism2_cell_info.csv", stringsAsFactors = F, row.names = 1)
dim(cellinfo) # 480 - 6

# prismcell = prismData::drugData@sampleData@samples$Name
# stopifnot(identical(prismcell, cellinfo$cell_line_display_name)) ## OK
## Processing ===============

lccle = toupper(celltable$ccle)
lccle[which(lccle=="T.T")]="TDOTT"
lccle = gsub("-","",lccle)
lccle = gsub(" ","",lccle)
lccle = gsub("/","",lccle)
lccle = gsub(",","",lccle)
lccle = gsub("\\.","",lccle)
lccle = gsub("\\(","",lccle)
lccle = gsub("\\)","",lccle)


idx = match(cellinfo$cell_line_display_name, lccle)

kmiss = which(is.na(idx)) ; length(kmiss) ## ZERO !!! OK

celltable$prism[idx] = cellinfo$cell_line_display_name

# View(celltable[,c(1:3,26)])
## END ======================

dim(celltable) # 2100 - 26
cellLineMatchTab <- celltable

save(cellLineMatchTab, file = "data/cellLineMatchTab.RData")

## END

















