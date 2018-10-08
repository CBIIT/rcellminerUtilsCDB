#--------------------------------------------------------------------------------------------------
# LOAD DATA
#--------------------------------------------------------------------------------------------------
## library(rcellminerUtilsCDB)
load("./data/drugSynonymTab.RData")
#--------------------------------------------------------------------------------------------------
# UPDATE TO ADD DATA FOR OTHER IMPORTANT DRUGS
#--------------------------------------------------------------------------------------------------
## drugSynonymTab <- rcellminerUtils::drugSynonymTab

# add bmn 673 for nci 60 ---------------------------
# drugSynonymTab[[146,1]]
#[1] "1207456-01-6"    "BMN 673"         "BMN-673"         "TALAZOPARIB"     "UNII-9QHX048FRV"
drugSynonymTab[[146,2]] <- c("765396","727125")
drugSynonymTab[[146,6]] <- c("765396","767125","767533")

# update synonyms for lmp400 and lmp776 ---UPPER CASE !!!------------
# drugSynonymTab[[433,1]]
drugSynonymTab[[433,1]] <- c(drugSynonymTab[[433,1]],"LMP400")
# drugSynonymTab[[434,1]]
drugSynonymTab[[434,1]] <- c(drugSynonymTab[[434,1]],"LMP-776","INDIMITECAN")

# add LMP744 at row 147 replace old bmn-673 ------------------------------------
# drugSynonymTab[[147,1]]
drugSynonymTab[[147,1]] <- c("LMP744","LMP-744","MJ-III-65","INDENOISOQUINOLINE")
drugSynonymTab[[147,2]] <- "706744"
drugSynonymTab[[147,6]] <- NA

# to remove 148 old second bmn-673 ---------------------------------
# drugSynonymTab[[148,1]]
drugSynonymTab= drugSynonymTab[-148,]
# save new drug synonyms
save(drugSynonymTab, file = "data/drugSynonymTab.RData")

#--------------------------------------------------------------------------------------------------


