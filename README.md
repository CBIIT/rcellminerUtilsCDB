# Description

Utility functions for rcellminer package used by the [CellMinerCDB](https://github.com/CBIIT/cellminercdb) interactive web application for cell line pharmacogenomics data exploration. Data includes tables to map between drugs and cell lines from different datasets.

# Project Structure

Key folders described below:

-   data: Contains the following data files
    -   cellLineMatchTab.RData: Mapping table of cell lines in different collections (e.g., NCI60) and [Cellosaurus](https://www.cellosaurus.org/) identifiers
    -   drugSynonymTab.RData: Mapping table of drugs from different collections and synonym names taken from [PubChem](https://pubchem.ncbi.nlm.nih.gov/)
    -   geneToChromBand.RData: Mapping table of genes to chromosomal locations
    -   HugoGeneSynonyms.RData: Mapping table of gene symbols to synonyms
-   inst: Script updating the data files
-   R: Functions related to retrieving information from the data files

# Installation

```         
if (!"devtools" %in% installed.packages()) install.packages("devtools")

setRepositories(ind=1:6)
library(devtools)

install_deps(".") 
```
