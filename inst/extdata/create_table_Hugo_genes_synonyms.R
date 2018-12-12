#--------------------------------------------------------------------------------------------------
# Load Hugo genes files 
# 
#--------------------------------------------------------------------------------------------------

hugo.info=read.delim("inst/extdata/HugoAnnot_approved.txt",stringsAsFactors = F)
dim(hugo.info) # 41626     9 ##
length(unique(hugo.info$Approved.symbol)) # 41626
## 
## create an array of synonymes
# syn=toupper(hugo.info$Approved.symbol)
# for (k in 1:nrow(hugo.info)) {
#   if (trimws(hugo.info$Previous.symbols[k])!="") syn[k]=paste(syn[k],toupper(hugo.info$Previous.symbols[k]),sep=",")
#   if (trimws(hugo.info$Synonyms[k])!="") syn[k]=paste(syn[k],toupper(hugo.info$Synonyms[k]),sep=",")
# }

syn=hugo.info$Approved.symbol
for (k in 1:nrow(hugo.info)) {
  if (trimws(hugo.info$Previous.symbols[k])!="") syn[k]=paste(syn[k],hugo.info$Previous.symbols[k],sep=",")
  if (trimws(hugo.info$Synonyms[k])!="") syn[k]=paste(syn[k],hugo.info$Synonyms[k],sep=",")
}


#
## syn2=paste(hugo.info$Approved.symbol,hugo.info$Previous.symbols,hugo.info$Synonyms,sep=",")

## vsyn=strsplit(syn,",")
vsyn = apply(array(syn),1,function(x) trimws(unlist(strsplit(x,","))))


# Need to be sure that the official hugo names are NOT included as synonyms in other genes 
# myres=list()
# for (k in 1:length(syn)) {
# gene   <- toupper(hugo.info$Approved.symbol[k])
# temp <- which(vapply(vsyn, function(x){ gene %in% toupper(x) }, logical(1)))
# if (length(temp)>1) cat(k,"\t",gene,"\t",temp,"\n")
# }

##
hugo.info$all_synonyms=vsyn
HugoGeneSynonyms=hugo.info
save(HugoGeneSynonyms, file = "data/HugoGeneSynonyms.RData")

#--------------------------------------------------------------------------------------------------
