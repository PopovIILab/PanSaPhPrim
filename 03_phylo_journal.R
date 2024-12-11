#############################
# CHAPTER 3. Phylogenetics #
############################

# Set the dir

main_dir <- dirname(rstudioapi::getSourceEditorContext()$path)
setwd(main_dir)

if (!require("pacman")) install.packages("pacman")

pacman::p_load(ggtree, ggimage, phangorn, ggplot2, treeio, ggnewscale, viridis, phytools, patchwork)

############################
# Part 1: Metadata parsing #
############################

metadata <- read.table('metadata/metadata.tsv', sep='\t', header=T)

meta.year <- as.data.frame(metadata[,'Year'])
colnames(meta.year) <- 'Year'
rownames(meta.year) <- metadata$Name
meta.year$Year[meta.year$Year == "ND"] <- NA

meta.year$Year[meta.year$Year == "9-06"] <- 2019
meta.year$Year[meta.year$Year == "2-18"] <- 2018

country_code_map <- c(
  "South Korea" = "kr",
  "United Kingdom" = "gb",
  "USA" = "us",
  "China" = "cn",
  "Chile: Olmue, Avicola Los Maitenes" = "cl",
  "China: Liupanshui City, Gui Zhou Province" = "cn",
  "Canada" = "ca",
  "South Korea: Moran traditional markek, seognam" = "kr",
  "Poland" = "pl",
  "USA: TX" = "us",
  "Iran" = "ir",
  "Iran: Tehran province" = "ir",
  "Iran: Lorestan province" = "ir",
  "Peru: Lima, Virginia" = "pe",
  "Portugal: Frossos, Braga" = "pt",
  "China: Jilin" = "cn",
  "USA: MI" = "us",
  "Denmark: Copenhagen" = "dk",
  "Turkey" = "tr",
  "Egypt" = "eg",
  "Malawi" = "mw",
  "Pakistan" = "pk",
  "South Korea: Suwon" = "kr"
)

metadata$flag_code <- country_code_map[metadata$Country]
metadata$flag_code[is.na(metadata$flag_code)] <- NA

if (!dir.exists("flags")) dir.create("flags")

flag_urls <- paste0("https://raw.githubusercontent.com/HatScripts/circle-flags/gh-pages/flags/", unique(metadata$flag_code[!is.na(metadata$flag_code)]), ".svg")

for (i in seq_along(flag_urls)) {
  country_code <- sub(".*/flags/(.*)\\.svg", "\\1", flag_urls[i])
  
  destfile <- paste0("flags/", country_code, ".svg")
  
  download.file(flag_urls[i], destfile, mode = "wb")
}

metadata$flag_path <- paste0("flags/", metadata$flag_code, ".svg")
metadata$flag_path[metadata$flag_path == "flags/NA.svg"] <- NA

#####################
# Part 2: SaPh tree #
#####################

SaPh_tree <- read.tree("phylogenetics/tree/tree_ufb.treefile")

#midpoint.root(SaPh_tree)

SaPh <- ggtree(SaPh_tree) %<+% metadata + 
  xlim(0,0.8) + 
  geom_tiplab(
    aes(label=Full.Name),
    color="black",
    align=TRUE
  )

SaPh_boot <- SaPh$data
SaPh_boot <- SaPh_boot[!SaPh_boot$isTip,]
SaPh_boot$label <- as.numeric(SaPh_boot$label)
SaPh_boot$bootstrap <- '0'
SaPh_boot$bootstrap[SaPh_boot$label >= 70] <- '1'
SaPh_boot$bootstrap[is.na(SaPh_boot$label)] <- '1'

SaPh <- SaPh + new_scale_color() +
  geom_tree(data=SaPh_boot, aes(color=bootstrap == '1')) +
  scale_color_manual(name='Bootstrap', values=setNames(c("black", "grey"), c(T,F)), guide = "none")

SaPh <- SaPh + geom_tiplab(aes(image = flag_path), geom = "image", offset = 0.28, align = TRUE, size = 0.01, linesize = 0)

SaPh <- gheatmap(SaPh, meta.year, width=0.05, offset=0.3, color="black", font.size=4, colnames_offset_y = -0.05) + 
  scale_fill_viridis(option="D", name="Year", discrete = TRUE, na.translate = T)

SaPh <- SaPh +
  annotate("text", x=max(SaPh$data$x) + 0.28, y=-0.05, label="Country", size=4)

ggsave('imgs/SaPh_tree.png', SaPh, width=14, height=16, dpi=600)

#####################
# Part 3: SaPh MSA #
#####################

library(ggmsa)
library(ggplot2)
library(ggplotify)

protein_sequences <- 'Alignment/Align-SaPh/renamed_SaPh-mafft-align.414.aln'

msa <- ggmsa(protein_sequences, 1, 141, char_width = 0.5, seq_name = TRUE,
      consensus_views = TRUE, disagreement = FALSE, use_dot = FALSE)

saph_msa <- as.grob(msa)

ggsave("imgs/SaPh_MSA.png", plot = saph_msa, width = 25, height = 12, dpi = 600)
