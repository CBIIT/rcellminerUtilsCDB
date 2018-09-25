# Open Project

Open Rproj file in RStudio 

# Install Dependencies 
    if (!"devtools" %in% installed.packages()) install.packages("devtools")
    
    setRepositories(ind=1:6)
    library(devtools)

    install_deps(".") 

# Run Vignette

Open vignette (Rmd files) from vignettes/ folder and use "Knit HTML" button to generate the HTML file.

