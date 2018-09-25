#--------------------------------------------------------------------------------------------------
# LOAD DATA
#--------------------------------------------------------------------------------------------------
library(rcellminerUtils)
library(tidyverse)
library(stringr)
library(igraph)

nci60Drugs <- rcellminer::getFeatureAnnot(rcellminerData::drugData)[["drug"]] %>%
  filter(FDA_STATUS %in% c("Clinical trial", "FDA approved"))

ctrpDrugs <- rcellminer::getFeatureAnnot(ctrpData::drugData)[["drug"]] %>%
  filter(STATUS %in% c("clinical", "FDA"))

gdscDrugs <- rcellminer::getFeatureAnnot(gdscDataDec15::drugData)[["drug"]]

ccleDrugs <- data.frame(NAME = rownames(exprs(rcellminer::getAct(ccleData::drugData))),
                        stringsAsFactors = FALSE)

sclcDrugs <- rcellminer::getFeatureAnnot(nciSclcData::drugData)[["drug"]] %>%
  filter(NAME != "")

#--------------------------------------------------------------------------------------------------
# CONSTRUCT INITIAL DRUG MATCH TABLE
#--------------------------------------------------------------------------------------------------
# drugMatchTab <- data.frame(
#   DRUG_NAME = drugNames <- sort(unique(c(toupper(nci60Drugs$NAME), toupper(ctrpDrugs$NAME),
#     toupper(gdscDrugs$NAME), toupper(ccleDrugs$NAME), toupper(sclcDrugs$NAME)))),
#   STD_NAME = NA,
#   nci60 = "",
#   ccle = "",
#   gdscDec15 = "",
#   ctrp = "",
#   nciSclc = "",
#   stringsAsFactors = FALSE
# )
#
# write_tsv(drugMatchTab, "inst/drugMatching/initial_drug_match_tab.txt")
#--------------------------------------------------------------------------------------------------
# FROM PUBCHEM SYNONYM-AUGMENTED DRUG MATCH TABLE, DERIVE LIST OF DRUG SYNONYM SETS
#--------------------------------------------------------------------------------------------------
drugMatchTab <- as.data.frame(read_tsv("inst/drugMatching/curated_initial_drug_match_tab_out.txt"))
drugMatchTab$PUBCHEM_NAME <- str_trim(drugMatchTab$PUBCHEM_NAME)

# drugNameLengths <- vapply(drugMatchTab$DRUG_NAME, nchar, integer(1))
maxNameLength <- 30 # To exclude long chemical names.

# Construct a list of (possibly overlapping) drug synonym sets, excluding long
# chemical names.
drugSynonymSets <- list()
for (i in seq_len(nrow(drugMatchTab))){
  drugName <- drugMatchTab[i, "DRUG_NAME"]
  pubchemSynonyms <- drugMatchTab[i, "PUBCHEM_NAME"]

  synSet <- drugName
  if (!is.na(pubchemSynonyms)){
    tmp <- str_split(pubchemSynonyms, ";")[[1]]
    for (j in seq_along(tmp)){
      if (nchar(tmp[j]) < maxNameLength){
        synSet <- c(synSet, tmp[j])
      }
    }
  }
  drugSynonymSets[[drugName]] <- unique(toupper(synSet))
}

#--------------------------------------------------------------------------------------------------
# FROM PUBCHEM SYNONYM-AUGMENTED DRUG MATCH TABLE, DERIVE LIST OF DISJOINT DRUG SYNONYM SETS
#--------------------------------------------------------------------------------------------------

#-----[helper functions]-----------------------------------------------------------------
# TESTING
# l <- list(A = 1:4, B = 4:8, C = c(1,7:12), D = 13:15)

# Given a list of atomic vectors representing sets, returns a symmetric matrix,
# with non-diagonal entries indicating the number of elements shared between pairs
# of distinct list items (sets). Diagonal entries are set to NA.
getSetOverlapCounts <- function(l){
  N <- length(l)
  if (N < 2){
    return(0)
  }

  A <- matrix(NA, N, N)
  for (i in 1:(N-1)){
    for (j in (i+1):N){
      A[i, j] <- length(intersect(l[[i]], l[[j]]))
      A[j, i] <- A[i, j]
    }
  }

  if (!is.null(names(l))){
    rownames(A) <- names(l)
    colnames(A) <- names(l)
  }

  return(A)
}

# Given a list of atomic vectors representing sets, returns TRUE if the
# sets are pairwise disjoint.
setsAreDisjoint <- function(l){
  A <- getSetOverlapCounts(l)

  if (sum(A[upper.tri(A, diag = FALSE)]) > 0){
    return(FALSE)
  } else{
    return(TRUE)
  }
}

# Given a list of atomic vectors representing sets, merges sets with
# with shared elements to return a list of pairwise disjoint sets.
mergeSetOverlaps <- function(l){
  if (is.null(names(l))){
    names(l) <- paste0("L", seq_along(l))
  }

  # (1) Construct an undirected 'overlap' graph, with nodes representing
  # list elements (sets) and edges connecting sets with shared elements.
  A <- getSetOverlapCounts(l)
  diag(A) <- 0
  A[A != 0] <- 1
  g <- igraph::graph_from_adjacency_matrix(adjmatrix = A, mode = "undirected")

  # (2) Merge sets with shared elements, identified as connected components
  # in the constructed overlap graph.
  connectedComps <- igraph::groups(igraph::components(g))

  lMerged <- vector(mode = "list", length = length(connectedComps))
  for (i in seq_along(lMerged)){
    compNodes <- connectedComps[[i]]
    lMerged[[i]] <- sort(unique(unname(c(l[compNodes], recursive = TRUE))))
  }

  stopifnot(setsAreDisjoint(lMerged))
  return(lMerged)
}
#----------------------------------------------------------------------------------------

drugSynonymSets <- mergeSetOverlaps(drugSynonymSets)

#--------------------------------------------------------------------------------------------------
# ORGANIZE DRUG ANNOTATION AND ACTIVITY DATA TO FACILITATE FURTHER PROCESSING
#--------------------------------------------------------------------------------------------------

srcDrugAnnot <- list()
srcDrugAct <- list()

#----[nci60]-----------------------------------------------------------------------------
drugAnnot <- select(nci60Drugs, ID = NSC, NAME)
drugAct <- exprs(rcellminer::getAct(rcellminerData::drugData))

stopifnot(all(unlist(lapply(drugAnnot, is.character))))
stopifnot(all(drugAnnot$ID %in% rownames(drugAct)))

srcDrugAnnot[["nci60"]] <- drugAnnot
srcDrugAct[["nci60"]]   <- drugAct[drugAnnot$ID, ]

#----[ctrp]------------------------------------------------------------------------------
drugAnnot <- select(ctrpDrugs, ID, NAME)
drugAct <- exprs(rcellminer::getAct(ctrpData::drugData))

stopifnot(all(unlist(lapply(drugAnnot, is.character))))
stopifnot(all(drugAnnot$ID %in% rownames(drugAct)))

srcDrugAnnot[["ctrp"]] <- drugAnnot
srcDrugAct[["ctrp"]]   <- drugAct[drugAnnot$ID, ]

#----[gdscDec15]-------------------------------------------------------------------------
drugAnnot <- select(gdscDrugs, ID = EXTENDED_NAME, NAME)
drugAct <- exprs(rcellminer::getAct(gdscDataDec15::drugData))

#-----[handle special cases]---------------------------------------------------
# NCI/DTB compounds submitted for GDSC testing are named by NSC identifier,
# rather than drug name, so rectify this here.
stopifnot(identical(rownames(drugAnnot), drugAnnot$ID))
drugAnnot["elephantin", "NAME"]            <- "elephantin"
drugAnnot["Teniposide", "NAME"]            <- "Teniposide"
drugAnnot["Bleomycin_NSC_125066", "NAME"]  <- "Bleomycin"
drugAnnot["Oxaliplatin", "NAME"]           <- "Oxaliplatin"
drugAnnot["Mitoxantrone", "NAME"]          <- "Mitoxantrone"

drugAnnot["BEN", "NAME"]            <- "BEN"
drugAnnot["sinularin", "NAME"]      <- "sinularin"
drugAnnot["Actinomycin D", "NAME"]  <- "Actinomycin D"
drugAnnot["Fludarabine", "NAME"]    <- "Fludarabine"
drugAnnot["Dacarbazine", "NAME"]    <- "Dacarbazine"

drugAnnot["Carmustine", "NAME"]           <- "Carmustine"
drugAnnot["dihydrorotenone", "NAME"]      <- "dihydrorotenone"
drugAnnot["Acetalax_NSC_59687", "NAME"]   <- "Acetalax"
drugAnnot["Acetalax_NSC_614826", "NAME"]  <- "Acetalax"
drugAnnot["gallibiscoquinazole", "NAME"]  <- "gallibiscoquinazole"

drugAnnot["Topotecan", "NAME"]            <- "Topotecan"
drugAnnot["Docetaxel_NSC_628503", "NAME"] <- "Docetaxel"
drugAnnot["Vincristine", "NAME"]          <- "Vincristine"
drugAnnot["Schweinfurthin A", "NAME"]     <- "Schweinfurthin A"
drugAnnot["MJ-III-65", "NAME"]            <- "MJ-III-65"

drugAnnot["Fulvestrant", "NAME"]  <- "Fulvestrant"
drugAnnot["Zoledronate", "NAME"]  <- "Zoledronate"
drugAnnot["Romidepsin", "NAME"]   <- "Romidepsin"
drugAnnot["Nelarabine", "NAME"]   <- "Nelarabine"
#------------------------------------------------------------------------------

stopifnot(all(unlist(lapply(drugAnnot, is.character))))
stopifnot(all(drugAnnot$ID %in% rownames(drugAct)))

srcDrugAnnot[["gdscDec15"]] <- drugAnnot
srcDrugAct[["gdscDec15"]]   <- drugAct[drugAnnot$ID, ]

#----[ccle]------------------------------------------------------------------------------
drugAnnot <- select(ccleDrugs, ID = NAME)
drugAnnot$NAME <- drugAnnot$ID
drugAct <- exprs(rcellminer::getAct(ccleData::drugData))

stopifnot(all(unlist(lapply(drugAnnot, is.character))))
stopifnot(all(drugAnnot$ID %in% rownames(drugAct)))

srcDrugAnnot[["ccle"]] <- drugAnnot
srcDrugAct[["ccle"]]   <- drugAct[drugAnnot$ID, ]

#----[nciSclc]---------------------------------------------------------------------------
drugAnnot <- select(sclcDrugs, ID = NSC, NAME)
drugAct <- exprs(rcellminer::getAct(nciSclcData::drugData))

stopifnot(all(unlist(lapply(drugAnnot, is.character))))
stopifnot(all(drugAnnot$ID %in% rownames(drugAct)))

srcDrugAnnot[["nciSclc"]] <- drugAnnot
srcDrugAct[["nciSclc"]]   <- drugAct[drugAnnot$ID, ]

#--------------------------------------------------------------------------------------------------
# CONSTRUCT DRUG SYNONYM MATCH TABLE
#--------------------------------------------------------------------------------------------------
drugSynonymTab <- data.frame(
  NAME_SET = I(drugSynonymSets),
  stringsAsFactors = FALSE
)

dataSources <- names(srcDrugAnnot)
for (db in dataSources){
  drugAnnot <- srcDrugAnnot[[db]]
  drugAct   <- srcDrugAct[[db]]
  stopifnot(identical(drugAnnot$ID, rownames(drugAct)))

  nameSetIdMatches <- vector(mode = "list", length = nrow(drugSynonymTab))
  #----------------------------------------------------------------------------
  for (i in seq_len(nrow(drugSynonymTab))){
    nameSet <- drugSynonymTab[[i, "NAME_SET"]]
    iMatch <- which(toupper(drugAnnot$NAME) %in% nameSet)
    if (length(iMatch) > 0){
      dbIds <- drugAnnot[iMatch, "ID"]
      numObs <- apply(drugAct[dbIds, , drop = FALSE], MARGIN = 1, function(x){
        sum(!is.na(x))
        })
      nameSetIdMatches[[i]] <- names(sort(numObs, decreasing = TRUE))
    } else{
      nameSetIdMatches[[i]] <- NA
    }
  }
  #----------------------------------------------------------------------------
  drugSynonymTab[[db]] <- I(nameSetIdMatches)
}

#--------------------------------------------------------------------------------------------------
# SAVE DRUG SYNONYM MATCH TABLE
#--------------------------------------------------------------------------------------------------
save(drugSynonymTab, file = "data/drugSynonymTab.RData")

#--------------------------------------------------------------------------------------------------
# UPDATE TO ADD DATA FOR OTHER IMPORTANT DRUGS
#--------------------------------------------------------------------------------------------------
drugSynonymTab <- rcellminerUtils::drugSynonymTab
i <- which(vapply(drugSynonymTab$NAME_SET, function(x){ "CAMPTOTHECIN" %in% x }, logical(1)))
if ((length(i) == 1) && is.na(drugSynonymTab[[i, "nci60"]])){
  drugSynonymTab[[i, "nci60"]] <- c("94600", "100880")
  save(drugSynonymTab, file = "data/drugSynonymTab.RData")
}
#--------------------------------------------------------------------------------------------------


