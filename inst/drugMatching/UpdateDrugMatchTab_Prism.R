#--------------------------------------------------------------------------------------------------
# Match  drugs in PRISM to NCI60 / other drug sources
#--------------------------------------------------------------------------------------------------

load("data/drugSynonymTab.Rdata")
dtable = drugSynonymTab 
dim(dtable) # 2888   17

dtable$prism = vector(mode = "list", length =nrow(dtable) )
for (k in 1:nrow(dtable)) dtable$prism[[k]]=NA
dim(dtable) # 2888 18

## There are a total of 1413 unique drugs >> Total matching 718 = 717+1
## -----------------------------------------------------------------------
prism = read.csv("inst/drugMatching/matching_prism_drugs_to_curated.csv", stringsAsFactors = F,row.names = 1)
# table curated by FE
dim(prism) # 1499 - 4

# drugname = prismData::drugData@act@featureData@data$ID
# length(drugname) # 1413
# length(intersect(drugname, prism$drug_name)) # 1413

# step1 index for matching ones ------------------------------------------
idx = which(!is.na(prism$final_index)) ; length(idx) #  703

for (k in 1: length(idx)) dtable[[prism$final_index[idx[k]], "prism"]] <- prism$drug_name[idx[k]]
dim(dtable) # 2888 - 18
t = which(!is.na(dtable$prism )) ; length(t) # 703

# PRISM SYNONYM for 4 matching
dtable[[12,"prism"]] <- c("thioguanine","tioguanine")
dtable[[752,"prism"]] <- c("AP26113","brigatinib")
dtable[[898,"prism"]] <- c("AZD2014","KU-0063794")
dtable[[1960,"prism"]] <- c("norgestrel","levonorgestrel")
dtable[[1960, 1]] <- union(dtable[[1960, 1]], "NORGESTREL" )

# step 2- merge 3 drugs for redundancy ----------------------------------------
# warfarin: merge 1675 with 678 and then remove 1675
# cabozantinib: merge 1586 with 167 and then remove 1586
# ENMD-2076: merge 266 with 2313 and then remove 2313

dtable[[678, 1]] <- union(dtable[[678, 1]], dtable[[1675,1]])
dtable[[678, "tncats"]] <- dtable[[1675, "tncats"]]
dtable[[678, "ancats"]] <- dtable[[1675, "ancats"]]

dtable[[167, 1]] <- union(dtable[[167, 1]], dtable[[1586,1]])
dtable[[167, "tncats"]] <- dtable[[1586, "tncats"]]
dtable[[167, "ancats"]] <- dtable[[1586, "ancats"]]

dtable[[266, 1]] <- union(dtable[[266, 1]], dtable[[2313,1]])
dtable[[266, "tncats"]] <- dtable[[2313, "tncats"]]
dtable[[266, "ancats"]] <- dtable[[2313, "ancats"]]
dtable[[266, "nci60"]] <- dtable[[2313, "nci60"]]

## NSC-23766 to update for nci60
dtable[[2297, 1]] <- union(dtable[[2297, 1]],"23766")
dtable[[2297, "nci60"]] <- "23766"

# step 3 - add Uracil with NSC 3970 - aliases ---------------------------
# add uracil as new row and matching nci60 3970
# synonyms: uracil, pyrod, pirod, ru 12709, "2,4-Pyrimidinediol" "2,4-Dioxopyrimidine" "2,4(1H,3H)-Pyrimidinedione"

## remove redund 1675, 1586 and 2313
dtable = dtable[-c(1586,1675,2313),]
dim(dtable) # 2885 - 18

# add uracil
rownames(dtable) = 1:nrow(dtable)

n = nrow(dtable)+1
# add new drug uracil
dtable[[n,1]]=toupper(c("uracil", "pyrod", "pirod","3970", "ru 12709", "2,4-Pyrimidinediol" ,"2,4-Dioxopyrimidine", "2,4(1H,3H)-Pyrimidinedione"))
dtable[[n,"nci60"]]="3970"
dtable[[n,"prism"]]="uracil"
for (k in c(3:17)) dtable[[n,k]] = NA


dim(dtable) # 2886 - 18
t = which(!is.na(dtable$prism )) ; length(t) # 708 (IN FACT 712)


## No WARRANTRY 707 ARE GOOD USING GREP ??
# dd = dtable[t,]
# dim(dd) # 708 -18
# rownames(dd)=1:708
# u = which(toupper(dd$tncats)==toupper(dd$prism) ) 
# length(u) # 533
# # View(dd[u,])
# View(dd[-u,c(1,2,13,18)])
## Stop here
## 

drugSynonymTab = dtable

save(drugSynonymTab, file = "data/drugSynonymTab.RData")

