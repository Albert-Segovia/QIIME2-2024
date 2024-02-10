# Curso Metagenómica UPEMOR 2024
![](https://qiime2.org/assets/img/qiime2.svg)

Análisis de los amplicones del gen ribosomal 16S rRNA en QIIME2 (Metabarcoding)                   
Alberto Segovia (alberto.segovia@ibt.unam.mx)                       
Copyright QIIME2-2024	

##### Descripción general conceptual de QIIME2 

Examinemos una descripción general conceptual de los distintos flujos de trabajo posibles para examinar los datos de secuencias de amplicones:

![](https://docs.qiime2.org/2023.9/_images/overview.png)



`$ conda activate qiime2-amplicon-2023.9`

`$ qiime --help`

Usage: qiime [OPTIONS] COMMAND [ARGS]...

  QIIME 2 command-line interface (q2cli)
  --------------------------------------

  To get help with QIIME 2, visit https://qiime2.org.

  To enable tab completion in Bash, run the following command or add it to
  your .bashrc/.bash_profile:

      source tab-qiime

  To enable tab completion in ZSH, run the following commands or add them to
  your .zshrc:

      autoload -Uz compinit && compinit
      autoload bashcompinit && bashcompinit
      source tab-qiime

Options:
  --version   Show the version and exit.
  --help      Show this message and exit.

Commands:
  info                Display information about current deployment.
  tools               Tools for working with QIIME 2 files.
  dev                 Utilities for developers and advanced users.
  alignment           Plugin for generating and manipulating alignments.
  composition         Plugin for compositional data analysis.
  cutadapt            Plugin for removing adapter sequences, primers, and
                      other unwanted sequence from sequence data.
  dada2               Plugin for sequence quality control with DADA2.
  deblur              Plugin for sequence quality control with Deblur.
  demux               Plugin for demultiplexing & viewing sequence quality.
  diversity           Plugin for exploring community diversity.
  diversity-lib       Plugin for computing community diversity.
  emperor             Plugin for ordination plotting with Emperor.
  feature-classifier  Plugin for taxonomic classification.
  feature-table       Plugin for working with sample by feature tables.
  fragment-insertion  Plugin for extending phylogenies.
  longitudinal        Plugin for paired sample and time series analyses.
  metadata            Plugin for working with Metadata.
  phylogeny           Plugin for generating and manipulating phylogenies.
  quality-control     Plugin for quality control of feature and sequence data.
  quality-filter      Plugin for PHRED-based filtering and trimming.
  sample-classifier   Plugin for machine learning prediction of sample
                      metadata.
  taxa                Plugin for working with feature taxonomy annotations.
  vsearch             Plugin for clustering and dereplicating with vsearch.
