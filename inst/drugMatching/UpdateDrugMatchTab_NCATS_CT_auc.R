#--------------------------------------------------------------------------------------------------
# LOAD DATA
#--------------------------------------------------------------------------------------------------
library(rcellminerUtilsCDB)

#--------------------------------------------------------------------------------------------------
# UPDATE with NCATS Craig Thomas drugs
#--------------------------------------------------------------------------------------------------
drugSynonymTab <- rcellminerUtilsCDB::drugSynonymTab 
original <- rcellminerUtilsCDB::drugSynonymTab
dim(drugSynonymTab) # 1131   14
ll = length(which(!is.na(drugSynonymTab$tncats))) # 528

##1# check tncats drugs names are incorporatated as synonyms
##-----------------------------------------------------------
i = which(!is.na(drugSynonymTab$tncats))
for (j in 1:ll) {
   k= i[j]
  if (is.na(match(toupper(drugSynonymTab$tncats[k]),drugSynonymTab[[k, 1]])) & !(k %in% c(191,199)))  { 
        # avoid updating 191: Lestaurtinib??? and 199: [1] "GDC-0980" , "Alectinib (CH5424802)"
        cat("not found: ",k,"\n")
        drugSynonymTab[[k, 1]] <-  c(drugSynonymTab[[k, 1]],toupper(drugSynonymTab$tncats[k]))
        }
  
  #cat("processed: ",j,"\n")
}


##2 # remove redundacy for 4 drugs based on recent discovery
##------------------------------------------------------------------------
# y:  AZD-2014  i : 100 1014   # to remove 100, merge information from 1014
# y:  Barasertib  i : 98 791   # remove 98 and merge
# y:  Brivanib  i : 151 164 774   # remove 151 164 and merge
# y:  XL-765  i : 716 1106  # remove 716 and merge


# vtar = c(1014,791,774,1106)

drugSynonymTab[[1014, 1]] = union(drugSynonymTab[[1014, 1]], drugSynonymTab[[100, 1]] )
drugSynonymTab[[1014, "nciSclc"]]  = "767189"
drugSynonymTab[[1014, "sarcoma"]]  = "767189"
drugSynonymTab[[1014, "uniSarcoma"]]  = "767189"

drugSynonymTab[[791, 1]] = union(drugSynonymTab[[791, 1]], drugSynonymTab[[98, 1]] )
drugSynonymTab[[791, "ctrp"]]  = "barasertib"
drugSynonymTab[[791, "nciSclc"]]  = "757444"
drugSynonymTab[[791, "sarcoma"]]  = "757444"
drugSynonymTab[[791, "uniSarcoma"]]  = "757444"

drugSynonymTab[[774, 1]] = union(drugSynonymTab[[774, 1]], drugSynonymTab[[164, 1]] )
drugSynonymTab[[774, 1]] = union(drugSynonymTab[[774, 1]], drugSynonymTab[[151, 1]] )
drugSynonymTab[[774, "ctrp"]]  = "brivanib"
drugSynonymTab[[774, "nciSclc"]]  = "764481"
drugSynonymTab[[774, "sarcoma"]]  = "764481"
drugSynonymTab[[774, "uniSarcoma"]]  = "764481"


drugSynonymTab[[1106, 1]] = union(drugSynonymTab[[1106, 1]], drugSynonymTab[[716, 1]] )
drugSynonymTab[[1106, "ctrp"]]  = "XL765"
drugSynonymTab[[1106, "nciSclc"]]  = "768100"

# now remove the redundants
vred = c(100,98,151,164,716)

drugSynonymTab = drugSynonymTab[-vred,]
dim(drugSynonymTab) # 1126 14
rownames(drugSynonymTab) = 1:1126



##3#  Use synonyms for the rest of NCATS drugs ...

## 
m=read.delim("./inst/extdata/NCATSNSC_matches_CDB_June23_529drugs_bycas.txt",stringsAsFactors = F)
dim(m) # 529 - 22
## GDC-0980, Alectinib (CH5424802) refer to the same compound
tncats = unlist(drugSynonymTab$tncats)
length(which(!is.na(tncats))) # 529
setdiff(m$compound_name,tncats) # zero OK

## need to check the (2679 -529 =)  2150 new drugs

druginfo=read.delim("./inst/extdata/NCATS_drug_info_2679_June5.txt",stringsAsFactors=F)
dim(druginfo) # 2679    9
## correct weird characters ..........
# XL-765 name
druginfo[1215,2] = "XL-765"
# taxifolin name
druginfo[1972,2] = "(+)-taxifolin"
# Alvelestat name
druginfo[1893,2] = "Alvelestat (azd9668)"
# Scopine moa
druginfo[1084,4] = "Metabolite Of Anisodine. Anisodine Is An Alpha1-adrenergic Receptor Agonist"
druginfo[1084,5] = "[Metabolite Of Anisodine. Anisodine Is An Alpha1-adrenergic Receptor Agonist, Alkaloid, Alpha-1 Adrenergic Receptor Agonist, Metabolite Of Anisodine. Anisodine Is An alpha1-adrenergic Receptor Agonist]"
## ...................................

ncompounds = setdiff(druginfo$compound_name,m$compound_name)
n=nrow(drugSynonymTab) # 1126
nm= length(ncompounds) # 2150

## try to match based on ncats compound name if found add ncats name in the synonym list

cntl = c()
# k=1
for (k in 1:nm) {
 ## y= toupper(m$SAMPLE_NAME[k])
 y = ncompounds[k]
i <- which(vapply(drugSynonymTab$NAME_SET, function(x,item){ item %in% x },item=toupper(y), logical(1)))
# cntl=c(cntl,i)
#  print(i)
if (length(i) > 1) cat("y: ",y," i :",i, " \n")
if (length(i) == 1) {
   # cat("found one: ",i,"\n")
   cntl=c(cntl,i)
   if (is.na(drugSynonymTab[[i, "tncats"]]))   drugSynonymTab[[i, "tncats"]] <- y else drugSynonymTab[[i, "tncats"]] <- c(drugSynonymTab[[i, "tncats"]],y)
 } else
 {
   n=n+1
   drugSynonymTab[n,2:14] <- NA
   drugSynonymTab[[n, "tncats"]] <- y
   drugSynonymTab[[n, 1]] <- toupper(y)
 }
 # cat("compound :",k," processed \n")
}

length(cntl) # 206
dim(drugSynonymTab) # 3070 -14


# checks
length(which(!is.na(drugSynonymTab$tncats))) # 2671
tncats = unlist(drugSynonymTab$tncats)
length(which(!is.na(tncats))) # 2679


## NEW sources ANCATS for NCATS auc drugs
#
drugSynonymTab$ancats = drugSynonymTab$tncats
dim(drugSynonymTab) # 3070  15
length(which(!is.na(drugSynonymTab$ancats))) # 2671

## Make some corrections
##------------------check NCATS Mat hall --------
## try to match based on ncats compound name if found add ncats name in the synonym list
## drugSynonymTab <- rcellminerUtilsCDB::drugSynonymTab 
# 
dim(drugSynonymTab) # 3070   15
m=read.delim("./inst/extdata/ncats_sampleinfo_final.txt",stringsAsFactors = F)
dim(m) # 27 - 10
nm=nrow(m)
cntl = c()
# k=1
for (k in 1:nm) {
  ## y= toupper(m$SAMPLE_NAME[k])
  y= m$SAMPLE_NAME[k]
  z= m$SAMPLE_ID[k]
  i <- which(vapply(drugSynonymTab$NAME_SET, function(x,item){ item %in% x },item=toupper(y), logical(1)))
  # cntl=c(cntl,i)
  #  print(i)
   if (length(i) > 1) cat("y: ",y," i :",i, " \n")
  if (length(i) == 1) {
     cat("found one: ",i,"\n")
    cntl=c(cntl,i)
     if (is.na(drugSynonymTab[[i, "ncats"]]))   drugSynonymTab[[i, "ncats"]] <- z else drugSynonymTab[[i, "ncats"]] <- c(drugSynonymTab[[i, "ncats"]],z)
  } 
  # else
  # {
  #   n=n+1
  #   drugSynonymTab[n,2:14] <- NA
  #   drugSynonymTab[[n, "tncats"]] <- y
  #   drugSynonymTab[[n, 1]] <- toupper(y)
  # }
      # cat("compound :",k," processed \n")
}

length(cntl) # 27
dim(drugSynonymTab) # 3070 -15
## end NCAT Matt Hall ---------------------------

# correct Ukhyun column NULL >> NA

for (k in 1:nrow(drugSynonymTab)) if (is.null(drugSynonymTab$ukhyun[[k]])) drugSynonymTab$ukhyun[[k]]=NA

## end Ukhyun clean ---------------------------

## other correction from curation based on multiple nsc for ncats compounds

drugSynonymTab[[764,2]] =  unlist(strsplit(drugSynonymTab[[764,2]],", "))
drugSynonymTab[[892,2]] =  unlist(strsplit(drugSynonymTab[[892,2]],", "))
drugSynonymTab[[980,2]] =  unlist(strsplit(drugSynonymTab[[980,2]],", "))
drugSynonymTab[[985,2]] =  unlist(strsplit(drugSynonymTab[[985,2]],", "))
drugSynonymTab[[1013,2]] =  unlist(strsplit(drugSynonymTab[[1013,2]],", "))
drugSynonymTab[[1024,2]] =  unlist(strsplit(drugSynonymTab[[1024,2]],", "))
drugSynonymTab[[1029,2]] =  unlist(strsplit(drugSynonymTab[[1029,2]],", "))
drugSynonymTab[[1051,2]] =  unlist(strsplit(drugSynonymTab[[1051,2]],", "))
drugSynonymTab[[1056,2]] =  unlist(strsplit(drugSynonymTab[[1056,2]],", "))
drugSynonymTab[[1072,2]] =  unlist(strsplit(drugSynonymTab[[1072,2]],", "))
drugSynonymTab[[1080,2]] =  unlist(strsplit(drugSynonymTab[[1080,2]],", "))
drugSynonymTab[[1088,2]] =  unlist(strsplit(drugSynonymTab[[1088,2]],", "))
drugSynonymTab[[850,2]] =  unlist(strsplit(drugSynonymTab[[850,2]],", "))
drugSynonymTab[[860,2]] =  unlist(strsplit(drugSynonymTab[[860,2]],", "))
drugSynonymTab[[874,2]] =  unlist(strsplit(drugSynonymTab[[874,2]],", "))
drugSynonymTab[[916,2]] =  unlist(strsplit(drugSynonymTab[[916,2]],", "))
drugSynonymTab[[917,2]] =  unlist(strsplit(drugSynonymTab[[917,2]],", "))

drugSynonymTab[[437,2]] =  c(drugSynonymTab[[437,2]],"755769")
drugSynonymTab[[437,1]] =  c(drugSynonymTab[[437,1]],"755769")
drugSynonymTab[[975,2]] =  unlist(strsplit(drugSynonymTab[[975,2]],", "))
drugSynonymTab[[275,2]] =  c(drugSynonymTab[[275,2]],"756642")
drugSynonymTab[[275,1]] =  c(drugSynonymTab[[275,1]],"756642")
drugSynonymTab[[1108,2]] =  unlist(strsplit(drugSynonymTab[[1108,2]],", "))
# merging 2 cases -------

drugSynonymTab[[890,4]] = drugSynonymTab[[485,4]] # gdsc
drugSynonymTab[[890,1]] = union(drugSynonymTab[[890,1]], drugSynonymTab[[485,1]]) 
drugSynonymTab[[890,2]] =  unlist(strsplit(drugSynonymTab[[890,2]],", "))
# to remove 485

drugSynonymTab[[932,3]] = drugSynonymTab[[426,3]] # ctrp
drugSynonymTab[[932,1]] = union(drugSynonymTab[[932,1]], drugSynonymTab[[426,1]]) 
drugSynonymTab[[932,2]] =  unlist(strsplit(drugSynonymTab[[932,2]],", "))
# to remove 426

drugSynonymTab[[973,6]] = drugSynonymTab[[627,6]] # ncisclc
drugSynonymTab[[973,1]] = union(drugSynonymTab[[973,1]], drugSynonymTab[[627,1]]) 
drugSynonymTab[[973,2]] =  unlist(strsplit(drugSynonymTab[[973,2]],", "))
# to remove 627

drugSynonymTab[[57,13]] = drugSynonymTab[[820,13]] # tncats
drugSynonymTab[[57,15]] = drugSynonymTab[[820,15]] #ancats
drugSynonymTab[[57,1]] = union(drugSynonymTab[[57,1]], drugSynonymTab[[820,1]]) 
drugSynonymTab[[57,2]] =  unlist(strsplit(drugSynonymTab[[820,2]],", "))
# to remove 820

drugSynonymTab[[836,4]] = drugSynonymTab[[562,4]] # gdsc
drugSynonymTab[[836,1]] = union(drugSynonymTab[[836,1]], drugSynonymTab[[562,1]]) 
drugSynonymTab[[836,2]] =  unlist(strsplit(drugSynonymTab[[836,2]],", "))
# to remove 562

drugSynonymTab[[721,13]] = drugSynonymTab[[876,13]] # tncats
drugSynonymTab[[721,15]] = drugSynonymTab[[876,15]] #ancats
drugSynonymTab[[721,1]] = union(drugSynonymTab[[721,1]], drugSynonymTab[[876,1]]) 
drugSynonymTab[[721,2]] =  unlist(strsplit(drugSynonymTab[[876,2]],", "))
# to remove 876

drugSynonymTab[[885,3]] = drugSynonymTab[[480,3]] # ctrp
drugSynonymTab[[885,1]] = union(drugSynonymTab[[885,1]], drugSynonymTab[[480,1]]) 
drugSynonymTab[[885,2]] =  unlist(strsplit(drugSynonymTab[[885,2]],", "))
# to remove 480

drugSynonymTab = drugSynonymTab[-c(485,426,627,820,562,876,480),]
# 
dim(drugSynonymTab) # 3063 -  15
# update topotecan

drugSynonymTab[[661,13]] = drugSynonymTab[[2264,13]] # tncats
drugSynonymTab[[661,15]] = drugSynonymTab[[2264,15]] #ancats
drugSynonymTab[[661,1]] = union(drugSynonymTab[[661,1]], drugSynonymTab[[2264,1]]) 
drugSynonymTab = drugSynonymTab[-2264,]
dim(drugSynonymTab) # 3062 -  15
rownames(drugSynonymTab) = 1:nrow(drugSynonymTab)
save(drugSynonymTab, file = "data/drugSynonymTab.RData")
#--------------------------------------------------------------------------------------------------


