# Description

Utility functions for rcellminer package used by the [CellMinerCDB](https://github.com/CBIIT/cellminercdb) interactive web application for cell line pharmacogenomics data exploration. Data includes tables to map between drugs and cell lines from different datasets.

# Project Structure

Key folders described below:

-   data: Contains the following data files
    -   cellLineMatchTab.RData: Mapping table of cell lines in different collections (e.g., NCI60) and [Cellosaurus](https://www.cellosaurus.org/) identifiers.
    -   drugSynonymTab.RData: Mapping table of drugs from different collections and synonym names taken from [PubChem](https://pubchem.ncbi.nlm.nih.gov/)
    -   geneToChromBand.RData: Mapping table of genes to chromosomal locations
    -   HugoGeneSynonyms.RData: Mapping table of gene symbols to synonyms taken from [HGNC](https://www.genenames.org/)
-   inst: Script updating the data files
-   R: Functions related to retrieving information from the data files

**NOTE:** Column names for cellLineMatchTab and drugSynonymTab should match for particular datasets (e.g., nci60 exists in both).

# Data Descriptions and Updating Data Files

**NOTE:** The datasets below are data.frames. If multiple values are present for a given entry then the column will use a list of vectors.

## Cell Line and Drug Synonym Mapping

The data objects cellLineMatchTab and drugSynonymTab all exist as R data.frames. R scripts that update these objects should be placed in the inst folder and operate on a given data object.

-   cellLineMatchTab: Each column represents a different cell line dataset. Additionally, there are two columns that contain the Cellosaurus information:
    -   cellosaurus_accession (an identifier in the form CVCL_IW49)
    -   cellosaurus_identifier (the human readable name for the given cellosaurus_accession value)
- drugSynonymTab: Each column represents a different cell line dataset. Additionally, there is the NAME_SET column that contains synonyms as a list of vectors. Currently, synonyms have been populated using content from PubChem, but others may be added.

## Gene Information Mapping

-   HugoGeneSynonyms: This is a data.frame with content taken from [HGNC](https://www.genenames.org/) as needed. The current data.frame contain the following columns:
    -   Approved.symbol
    -   Approved.name
    -   Previous.symbols
    -   Synonyms: Same as Alias symbols from HGNC
    -   Chromosome
    -   Accession.numbers
    -   RefSeq.IDs
    -   Ensembl.gene.ID
    -   NCBI.Gene.ID
    -   all_synonyms: A list of vectors where each vector is a concatenation of Approved.symbol, Previous.symbols, and Synonyms
-   geneToChromBand: This is a named vector where the names are chromosomal locations (e.g., 3q27.1) and the values are gene symbols. This data is taken from the HugoGeneSynonyms columns Chromosome and Approved.symbol

# Installation

```         
if (!"devtools" %in% installed.packages()) install.packages("devtools")

setRepositories(ind=1:6)
library(devtools)

install_deps(".") 
```
