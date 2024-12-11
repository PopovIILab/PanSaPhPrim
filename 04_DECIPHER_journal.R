##################################################################
# CHAPTER 4. Design Primers That Yield Group-Specific Signatures #
##################################################################

# Set the dir

main_dir <- dirname(rstudioapi::getSourceEditorContext()$path)
setwd(main_dir)

# Load/install required packages

#if (!requireNamespace("BiocManager", quietly=TRUE))
  #install.packages("BiocManager")

#BiocManager::install("DECIPHER")

#install.packages("RSQLServer")

#devtools::install_github('imanuelcostigan/RSQLServer')

system("hybrid-min-V")

library(DECIPHER)
library(DBI)
library(DECIPHER)
library("RSQLServer")
library("RSQLite")
library("writexl")

fas <- "Alignment/Align-SaPh/SaPh-current.414.gen"

dbConn <- dbConnect(SQLite(), ":memory:")

N <- Seqs2DB(fas, "FASTA", dbConn, "")

N # number of sequences in the database

desc <- dbGetQuery(dbConn, "select description from Seqs")$description

unique(desc)

Add2DB(data.frame(identifier=desc, stringsAsFactors=FALSE), dbConn)

# Designing primers for community fingerprinting (FLP):
TYPE <- "length"
# it is important to have a width range of lengths
MIN_SIZE <- 70 # base pairs
MAX_SIZE <- 300
# define bin boundaries for distinguishing length,
  # the values below require high-resolution, but
  # the bin boundaries can be redefined for lower
  # resolution experiments such as gel runs
RESOLUTION <- 1
LEVELS <- 2 # presence/absence of the length

example_primers <- DesignSignatures(dbConn,
                            type=TYPE,
                            minProductSize=MIN_SIZE,
                            maxProductSize=MAX_SIZE,
                            resolution=RESOLUTION,
                            levels=LEVELS)

write_xlsx(example_primers, "primers.xlsx")