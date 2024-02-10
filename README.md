# Curso Metagenómica UPEMOR 2024
![](https://qiime2.org/assets/img/qiime2.svg)

Análisis de los amplicones del gen ribosomal 16S rRNA en QIIME2 (Metabarcoding)                   
PhD. Alberto Segovia (alberto.segovia@ibt.unam.mx)                       
Copyright QIIME2-2024	

QIIME ( inglés: / tʃ aɪ m / ch-eye-m ) [1] es una plataforma de ciencia de datos bioinformática , desarrollada originalmente para el análisis de datos de secuenciación de amplicones de genes marcadores de microbioma de alto rendimiento (p. ej., genes de ARNr 16S o 18S ) . Ha habido dos versiones principales de la plataforma QIIME, QIIME 1 [2] y QIIME 2. [3]

Descripción general y conceptual de QIIME2
----------------------------------------

Examinemos una descripción general conceptual de los distintos flujos de trabajo posibles para examinar los datos de secuencias de amplicones:

![](https://docs.qiime2.org/2023.9/_images/overview.png)


Trabajaremos con datos de amplicones de la región V3-V4 del 16S rRNA de muestras de tres tiempos de fermentación del pulque, estos se obtuvieron con una plataforma ILLUMINA MiSeq (2 x 300 pb) y están en formato FASTQ. Los datos fueron depositados en NCBI y ENA bajo el BioProject PRJEB13870 del artículo Deep microbial community profiling along the fermentation process of pulque, a biocultural resource of Mexico (Rocha-Arriaga et al., 2020).

  QIIME 2 command-line interface
  --------------------------------------

`$ conda activate qiime2-amplicon-2023.9`                                                                                                                                                                    

`$ qiime --help`



