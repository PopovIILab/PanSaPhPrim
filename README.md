# Pan _Salmonella_ phages degenerate PCR primers design

> This is the repository for supplementary materials for the upcoming publication

**Files**:
- 📑 [`01_PanACoTA_journal.ipynb`](01_PanACoTA_journal.ipynb) - laboratory journal with commands to reproduce the 1st step of pipeline
- 📑 [`02_Pangenome_vis_journal.R`](02_Pangenome_vis_journal.R) - laboratory journal with commands to reproduce the 2nd step of pipeline
- 📑 [`03_phylo_journal.R`](03_phylo_journal.R) - laboratory journal with commands to reproduce the 3rd step of pipeline
- 📑 [`04_DECIPHER_journal.R`](04_DECIPHER_journal.R) - laboratory journal with commands to reproduce the 4th step of pipeline
- 📑 [`panacota.yaml`](panacota.yaml) - conda environment
- 📁 [`scripts`](scripts) - folder with scripts:
  - 📑 [`filter_seqs.py`](scripts/filter_seqs.py) - script that filters out "trash" downloaded from `RefSeq` with `Entrez`
  - 📑 [`sepfasta.py`](scripts/sepfasta.py) - script that separates 1 fasta with multiple seqs to multiple fasta files with 1 seq
  - 📑 [`process_LSTINFO.py`](scripts/process_LSTINFO.py) - script that filters `PanACoTA`'s `corepers` subcommand output to make it fit `align` subcommand

**Instruction**:
- Create new environment `panacota`
```bash
conda env create -f panacota.yaml
```

**Pipeline:**

<img src="https://github.com/PopovIILab/PanSaPhPrim/blob/main/imgs/PanSaPhPrim_pipeline.png" width="100%"/>

_Figure 1. Pipeline overview._
