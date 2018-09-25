library(rcellminer)
library(rcellminerUtils)
library(org.Hs.eg.db)

geneSet <- rownames(exprs(rcellminerData::molData[["exp"]]))

geneToChromBand <- character(length(geneSet))
names(geneToChromBand) <- geneSet

tmp <- select(org.Hs.eg.db, keys=geneSet, columns=c("SYMBOL", "MAP"), keytype="SYMBOL")
tmp <- tmp[!duplicated(tmp$SYMBOL), ]
tmp <- tmp[!is.na(tmp$MAP), ]

geneToChromBand[tmp$SYMBOL] <- tmp$MAP

save(geneToChromBand, file = "./data/geneToChromBand.RData")

#------------------------------------------------------------------------------
# chromSet <- c(as.character(1:22), "X", "Y")
# batchSize <- 100
#
# geneToChromBand <- character(length(geneSet))
# names(geneToChromBand) <- geneSet
#
# i <- 1
# i <- 13301
# while (i <= length(geneSet)){
#   cat(i, sep = "\n")
#   iEnd <- min((i + batchSize - 1), length(geneSet))
#   batchGenes <- geneSet[i:iEnd]
#
#   tmp <- getGeneLoc(batchGenes)
#   tmp <- tmp[(tmp$chromosome_name %in% chromSet), ]
#   if (any(duplicated(tmp$hgnc_symbol))){
#     warning("Excluding duplicate gene entries ... ")
#     tmp <- tmp[!duplicated(tmp$hgnc_symbol), ]
#   }
#
#   if (nrow(tmp) == 0){
#     i <- iEnd + 1
#     next
#   }
#   rownames(tmp) <- tmp$hgnc_symbol
#
#   geneToChromBand[rownames(tmp)] <- paste0(tmp$chromosome_name, tmp$band)
#
#   i <- iEnd + 1
# }
# cat("done.", "\n")
#------------------------------------------------------------------------------


