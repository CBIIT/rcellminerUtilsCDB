#--------------------------------------------------------------------------------------------------
# LOAD DATA
#--------------------------------------------------------------------------------------------------
## library(rcellminerUtilsCDB)
load("./data/drugSynonymTab.RData")
temptable=drugSynonymTab
dim(temptable)
# 748   7
#--------------------------------------------------------------------------------------------------
# UPDATE TO ADD DATA FOR OTHER IMPORTANT DRUGS
#--------------------------------------------------------------------------------------------------
## 
sarcoma.info=read.delim("inst/extdata/sarcoma_drugs_in_synonyms_curated.txt",stringsAsFactors = F)
dim(sarcoma.info) # 445 - 11 ##
rownames(sarcoma.info)=as.character(sarcoma.info$nsc)
#  -------------------------------------------------------------------------------------
# First Make some correction for observed error before adding the matching Sarcoma drugs
# --------------------------------------------------------------------------------------
# related to nciSclc (c(203,483,215,10,379,508,320,121,747,161))
temptable[[202,6]] <- c("764040","764821")
# to remove later line 203
temptable[[204,6]] <- temptable[[483,6]]
temptable[[204,1]] <- c(temptable[[204,1]],temptable[[483,1]])
# to remove later line 483
temptable[[380,6]] <- temptable[[215,6]]
temptable[[380,1]] <- c(temptable[[380,1]],temptable[[215,1]])
# to remove later line 215
temptable[[9,6]] <- temptable[[10,6]]
temptable[[9,1]] <- c(temptable[[9,1]],temptable[[10,1]])
# to remove later line 10

temptable[[92,2]] <- temptable[[379,2]]
temptable[[92,1]] <- c(temptable[[92,1]],temptable[[379,1]])
# to remove later line 379

temptable[[352,6]] <- temptable[[508,6]]
temptable[[352,1]] <- c(temptable[[352,1]],temptable[[508,1]])
# to remove later line 508


temptable[[202,6]] <- c(temptable[[202,6]],"764091")
temptable[[202,1]] <- c(temptable[[202,1]],temptable[[320,1]])
# to remove later line 320

temptable[[591,6]] <- temptable[[121,6]]
temptable[[591,1]] <- c(temptable[[591,1]],temptable[[121,1]])
# to remove later line 121

temptable[[746,6]] <- temptable[[747,6]]
temptable[[746,1]] <- c(temptable[[746,1]],temptable[[747,1]])
# to remove later line 747

# correction
temptable[[248,2]] <- "45388"
temptable[[465,2]] <- "38721"

temptable[[162,6]] <- temptable[[161,6]]
temptable[[162,1]] <- c(temptable[[162,1]],temptable[[161,1]])
# to remove later line 161
# OK update done

# choose selected 291 drugs
drug291=as.character(nciSarcomaData::drugData@act@featureData@data$NSC)
sarcoma.info.291=sarcoma.info[drug291,]; dim(sarcoma.info.291)
nzz=which(sarcoma.info.291$correct_index!=0); length(nzz) # 288

temptable$sarcoma = vector(mode = "list", length =nrow(temptable) )
for (k in 1:nrow(temptable)) temptable$sarcoma[[k]]=NA
# now update 288 lines in sarcoma
for (xx in 1:288) {
  elt = sarcoma.info.291$correct_index[nzz[xx]]
  temptable$sarcoma[[elt]]=as.character(sarcoma.info.291$nsc[nzz[xx]])
}
  # removed cited lines
dim(temptable) # 748 -8 
rm=sort(c(203,483,215,10,379,508,320,121,747,161))
temptable= temptable[-rm,]
dim(temptable)
# 738   8
#save 

drugSynonymTab=temptable

# save new drug synonyms
save(drugSynonymTab, file = "data/drugSynonymTab.RData")

#--------------------------------------------------------------------------------------------------


