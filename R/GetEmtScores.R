#' Get EMT score for a data gene expression matrix or dataframe.
#'
#' @param genedata A data matrix with observations along the rows and variables along the columns.
#' @param sampleOncoTree1  a vector with tissue of origin for each sample (in genedata) based on oncoTree level 1 
#'
#' @return A list with the following elements:
#' $emtScores pc1 scores 
#' $mdaAnnot metadata for the scores
#' $nbEmtGenes number of used EMT genes
#' $emtStatus final emt status
#' 
#' @examples
#' genedata <- exprs(rcellminerData::molData@eSetList$xai)
#' sampleOncoTree1 <- rcellminerData::molData@sampleData@samples$OncoTree1
#' emtResults <- getEmtScores(genedata,sampleOncoTree1)
#'
#'
#' @concept rcellminerUtilsCDB
#' @export
getEmtScores <- function(genedata,sampleOncoTree1){

## expDataType <- "xai" NOT ZSCORE !!!
#library(rcellminerUtilsCDB)

# Epithelial and mesenchymal gene sets are derived from Figure 11 of
# https://doi.org/10.1371/journal.pone.0099269
epiGenes <- c(
  "ADAP1", "ATP2C2", "CLDN3", "CLDN4", "CLDN7", "EHF", "EPN3", "ESRP1", "ESRP2",
  "GRHL1", "GRHL2", "IRF6", "LLGL2", "MARVELD2", "MARVELD3", "MYO5B",
  "OVOL1", "PRSS8", "RAB25", "S100A14", "ST14", "TJP3"
)

mesGenes <- c(
  "AP1M1", "BICD2", "CCDC88A", "CMTM3", "EMP3", "GNB4", "IKBIP",
  "MSN", "QKI", "SNAI1", "SNAI2", "STARD9", "VIM", "ZEB1", "ZEB2"
)

nonHmLines <- which(!(sampleOncoTree1 %in% c("Blood", "Lymph")))

# stopifnot(all(!duplicated(epiGenes)))
# stopifnot(all(!duplicated(mesGenes)))
# stopifnot(length(intersect(epiGenes, mesGenes)) == 0)

if (!(all(epiGenes %in% rownames(genedata)))) {
  epiGenes <- intersect(epiGenes, rownames(genedata))
}

if (!(all(mesGenes %in% rownames(genedata)))) {
  mesGenes <- intersect(mesGenes, rownames(genedata))
}

stopifnot(all(c(epiGenes, mesGenes) %in% rownames(genedata)))
emtGenes <- c(epiGenes, mesGenes)

#--------------------------------------------------------------------------------------------------
# PCA
#--------------------------------------------------------------------------------------------------
pkgEmtExp <- genedata[emtGenes, nonHmLines]
colHasNa  <- apply(pkgEmtExp, MARGIN = 2, FUN = function(x) { any(is.na(x)) })

pcEmt <- rcellminerUtilsCDB::getPcaResults(X = t(pkgEmtExp[, !colHasNa]))
## pcEmt <- getPcaResults(X = t(pkgEmtExp[, !colHasNa]))
pc1VarWts <- pcEmt$evecs[, 1, drop = TRUE]

stopifnot(all(names(pc1VarWts[pc1VarWts > 0]) %in% epiGenes))
stopifnot(length(intersect(names(pc1VarWts[pc1VarWts > 0]), mesGenes)) == 0)

stopifnot(all(names(pc1VarWts[pc1VarWts < 0]) %in% mesGenes))
stopifnot(length(intersect(names(pc1VarWts[pc1VarWts < 0]), epiGenes)) == 0)

tmp <- pcEmt$dat[, "PC1", drop = TRUE]
stopifnot(all(names(tmp) %in% colnames(genedata)))

emtPc1 <- setNames(rep(NA, ncol(genedata)), colnames(genedata))
emtPc1[names(tmp)] <- tmp
# stopifnot(identical(names(emtPc1), pkgAnnot$Name))

# check PC computation ------------------------------------------------------------
# Note: EMT gene weights are applied to the scaled EMT expression data matrix
# (z-score for each gene across cell lines) to obtain the first PC (EMT score).
tmpX <- scale(t(pkgEmtExp[, !colHasNa]))
stopifnot(identical(colnames(tmpX), names(pc1VarWts)))
tmpPc1 <- setNames(as.numeric(tmpX %*% pc1VarWts), rownames(tmpX))
stopifnot(identical(names(pcEmt$dat[, "PC1", drop = TRUE]), names(tmpPc1)))
stopifnot(identical(round(pcEmt$dat[, "PC1", drop = TRUE], 4), round(tmpPc1, 4)))
# --------------------------------------------------------------------------------

mdaAnnot <-  c("KOHN_EMT_PC1",
    "1st Principal Component of Non-Hematopoietic Cell Line Expression Data Matrix for 38 EMT Genes",
    "For EMT gene set details, see PMID: 24940735, Kohn et al., Gene Expression Correlations in Human Cancer Cell Lines Define Molecular Interaction Networks for Epithelial Phenotype")

## add EMT status
im = which(emtPc1 <=0) ; ie = which(emtPc1 >0)
mcut = mean(emtPc1[im],na.rm=T) + sd(emtPc1[im], na.rm=T)
ecut = mean(emtPc1[ie],na.rm=T) - sd(emtPc1[ie], na.rm=T)
emtstatus=rep("NA",length(emtPc1))
for (k in 1:length(emtPc1)) {
  if (!is.na(emtPc1[k])) {
    if (emtPc1[k]<=0) {
      if (emtPc1[k]< mcut) emtstatus[k]="Mesenchymal" else  emtstatus[k]="Epithelial-Mesenchymal"
    } else
    {
      if (emtPc1[k]> ecut) emtstatus[k]="Epithelial" else  emtstatus[k]="Epithelial-Mesenchymal"
    }
  }
}
##
result=list(emtScores=emtPc1,mdaAnnot=mdaAnnot,nbEmtGenes=length(emtGenes),emtStatus=emtstatus)
return(result)

}
#--------------------------------------------------------------------------------------------------
