# Curso Metagenómica UPEMOR 2024
![](https://qiime2.org/assets/img/qiime2.svg)

Análisis de los amplicones del gen ribosomal 16S rRNA en QIIME2 (Metabarcoding)                   
PhD. Alberto Segovia (alberto.segovia@ibt.unam.mx)                       
Copyright QIIME2-2024	

<!-- This content will not appear in the rendered Markdown -->

QIIME2 (Quantitative Insights Into Microbial Ecology)
----------------------------------------
es una plataforma bioinformática para el análisis integral y totalmente reproducible de los microbiomas, que permite el procesamiento de lecturas de secuencias de DNA sin procesar hasta la generación de figuras interactivas publicables. Proporcionando herramientas para limpiar secuencias, agrupar, asignar taxonomía, reconstruir filogenias, inferir métricas de diversidad, abundancia diferencial, etc. Es de código abierto, posee una interfaz gráfica amigable, mucha documentación, tutoriales y foros de ayuda [(Bolyen et al., 2019)](https://www.nature.com/articles/s41587-019-0209-9).



Descripción conceptual de QIIME2
----------------------------------------
\
Examinemos una descripción general conceptual de los distintos flujos de trabajo posibles para examinar los datos de secuencias de amplicones:

![](https://docs.qiime2.org/2023.9/_images/overview.png)

Las muestras obtenidas de este ejercicio fueron tomadas de veinte localidades en aguas mexicanas del Golfo de México a diferentes profundidades. Nosotros utilizaremos una pequeña cantidad de los datos, 9 de las 57 muestras. Además, los mismos serán submuestreados por lo que trabajaremos con una fracción de los datos de amplicones de la región V3–V4 del 16S rRNA obtenidos en la plataforma ILLUMINA MiSeq paired-end (2 × 300 bp) demultiplexados en formato FASTQ. Los datos originales se encuentran depositados en NCBI bajo el BioProject PRJNA609564 (SAMN14259149-SAMN14259166, SAMN14255300-SAMN14255357), y PRJNA380945 (SAMN06649846) del artículo "Metagenomic Profiling and Microbial Metabolic Potential of Perdido Fold Belt (NW) and Campeche Knolls (SE) in the Gulf of Mexico" [(Raggi et al., 2020)](https://doi.org/10.3389/fmicb.2020.01825).

![](https://www.frontiersin.org/files/Articles/562255/fmicb-11-01825-HTML/image_m/fmicb-11-01825-g001.jpg)

Instalación de QIIME 2 
--------------------------------------

#### Descarga e instalación de QIIME 2 dentro de un ambiente conda

```
wget https://data.qiime2.org/distro/amplicon/qiime2-amplicon-2023.9-py38-linux-conda.yml 
conda env create -n qiime2-amplicon-2023.9 --file qiime2-amplicon-2023.9-py38-linux-conda.yml
```

LIMPIEZA OPCIONAL

```
rm qiime2-amplicon-2023.9-py38-linux-conda.yml
```
#### Activación 

```
conda activate qiime2-amplicon-2023.9
```

#### Desactivación 

```
conda deactivate
```

#### Verificación de instalación                                                                                                                                                                   

```
qiime --help
```

Descargar e importar secuencias
----------------------------------------
#### QIIME2 utiliza sus propios artefactos, por lo que es necesario importarlos a su entorno (opcional) 

1. Crear un directorio de trabajo 
```
mkdir input 
cd input
```
2.  Descargar todos los archivos desde [dropbox.com ](https://www.dropbox.com/)

https://www.dropbox.com/scl/fo/5nu784fhq7zt2dexcbtz9/h?rlkey=79cexfd45te5y0adi0djbp6cw&dl=0

3. Nombre de los datos (542Mb)
```
GD11_S1_L001_R1_001.fastq.gz
GD11_S1_L001_R2_001.fastq.gz
GD13_S1_L001_R1_001.fastq.gz
GD13_S1_L001_R2_001.fastq.gz
GD16_S1_L001_R1_001.fastq.gz
GD16_S1_L001_R2_001.fastq.gz
MN11_S3_L001_R1_001.fastq.gz
MN11_S3_L001_R2_001.fastq.gz
MN13_S3_L001_R1_001.fastq.gz
MN13_S3_L001_R2_001.fastq.gz
MN16_S3_L001_R2_001.fastq.gz
MN16_s3_L001_R1_001.fastq.gz
MX11_S2_L001_R1_001.fastq.gz
MX11_S2_L001_R2_001.fastq.gz
MX13_S2_L001_R1_001.fastq.gz
MX13_S2_L001_R2_001.fastq.gz
MX16_S2_L001_R1_001.fastq.gz
MX16_S2_L001_R2_001.fastq.gz
```
##### Importar los datos con Casava 1.8 paired-end demultiplexed fastq (opcional)
QIIME utiliza sus propios artefactos por lo que tendremos que impotarlos al ambiente de trabajo (usando Casava)

```
qiime tools import \
  --type 'SampleData[PairedEndSequencesWithQuality]' \
  --input-path input \
  --input-format CasavaOneEightSingleLanePerSampleDirFmt \
  --output-path demux-paired.qza
```
##### Realizar el submuestreo del 0.02 % (11 Mb) de las lecturas (opcional)

```   
   qiime demux subsample-paired \
     --i-sequences demux-paired.qza \
     --p-fraction 0.02 \
     --o-subsampled-sequences demux-subsample.qza
```
```
   qiime demux summarize \
     --i-data demux-subsample.qza \
     --o-visualization demux-subsample.qzv
```

Step 1: Limpieza y control de calidad de los datos 
-----------------------------------------------
#### Descargar manualmente el objeto demux-paired.qza (importante) 
https://github.com/Albert-Segovia/QIIME2-2024/blob/main/demux-subsample.qza o con:

```
wget https://github.com/Albert-Segovia/QIIME2-2024/raw/5205277c905ad2bcab5375a20ca7475984b38edd/demux-subsample.qza
```
#### Eliminar los cebadores 

En ocasiones las secuencias aún tienen los cebadores adjuntos por lo que se deben de eliminar (usando cutadapt) justo antes de eliminar el ruido.

```
qiime cutadapt trim-paired \
--i-demultiplexed-sequences demux-subsample.qza \
--p-front-f CCTACGGGNGGCWGCAG \
--p-front-r GACTACHVGGGTATCTAATCC \
--p-error-rate 0.2 \
--output-dir analysis/seqs_trimmed \
--verbose
```

#### Crear objetos de visualización e interpretar la calidad de las secuencias
Una vez eliminados los cebadores generaremos un artefacto de visualización 

```
qiime demux summarize \
  --i-data analysis/seqs_trimmed/trimmed_sequences.qza \
  --o-visualization trimmed-demux-paired.qzv
```
Realizar la visualización arrastrando el artefacto demux-subsample.qzv a la página https://view.qiime2.org/

#### Recorte e eliminación de ruido  
Usaremos estos gráficos para determinar qué parámetros de recorte queremos usar para eliminar el ruido con DADA2 y luego eliminaremos el ruido de las lecturas usando dada2 denoise-paired

```
qiime dada2 denoise-paired \
  --i-demultiplexed-seqs analysis/seqs_trimmed/trimmed_sequences.qza \
  --p-trim-left-f 0 \
  --p-trim-left-r 0 \
  --p-trunc-len-f 260 \
  --p-trunc-len-r 174 \
  --o-table table.qza \
  --o-representative-sequences rep-seqs.qza \
  --o-denoising-stats denoising-stats.qza
```

#### Generar archivos de resumen

En este paso se generarán los artefactos de visualización que contienen la tabla de características, las secuencias de características correspondientes y las estadísticas de eliminación de ruido de DADA2. 
Es necesario tener el archivo de metadatos. Descargar manualmente el sample-metadata.tsv.  

```
qiime feature-table summarize \
  --i-table table.qza \
  --o-visualization table.qzv \
  --m-sample-metadata-file sample-metadata.tsv

qiime feature-table tabulate-seqs \
  --i-data rep-seqs.qza \
  --o-visualization rep-seqs.qzv

qiime metadata tabulate \
  --m-input-file denoising-stats.qza \
  --o-visualization denoising-stats.qzv  
```

Step 2: Análisis taxonómico
-----------------------------------------------

Clasificaremos cada lectura idéntica o variante de los Amplicon Sequence Variant (ASV) a la resolución más alta (99% de identidad) de acuerdo con la base de datos de SILVA y/o Greengenes 2022. 

**Debido a limitaciones del taller, NO ejecute el qiime feature-classifier classify-sklearn.**


Descargar manualmente la base de datos Silva 138 99% OTUs full-length sequences: Greengenes2 2022.10 from 515F/806R region of sequences de https://docs.qiime2.org/2023.9/data-resources/ 

Clasificación con la base de datos de Greengenes actualizada al año 2022 (opcional)

```
qiime feature-classifier classify-sklearn \
--i-classifier gg_2022_10_backbone.v4.nb.qza \
--i-reads rep-seqs.qza \
--o-classification taxonomy_gg.qza
```

Descargar manualmente la base de datos de Silva: Silva 138 99% OTUs from 515F/806R region of sequences de https://docs.qiime2.org/2023.9/data-resources/ 


Clasificación con la base de datos de Silva (opcional)
```
qiime feature-classifier classify-sklearn \
--i-classifier silva-138-99-515-806-nb-classifier.qza \
--i-reads rep-seqs.qza \
--o-classification taxonomy_silva.qza
```

**Necesitará acceder a una clasificación precalculada por lo que deberá descargar manualmente taxonomy_gg.qzv.** 

Generar el artefacto de visualización de las asignaciones taxonómicas

```
qiime metadata tabulate \
--m-input-file taxonomy_gg.qza \
--o-visualization taxonomy_gg.qzv
```

Generaremos una Taxonomy-barplot con Grengenes (2022)
```
qiime taxa barplot \
--i-table table.qza \
--i-taxonomy taxonomy_gg.qza \
--m-metadata-file sample-metadata.tsv \
--o-visualization taxa-bar-plots_gg.qzv
```

Generaremos una Taxonomy-barplot con silva 
```
qiime taxa barplot \
--i-table table.qza \
--i-taxonomy taxonomy_silva.qza \
--m-metadata-file sample-metadata.tsv \
--o-visualization taxa-bar-plots_silva.qzv
```
Realizar la visualización arrastrando el artefacto taxa-bar-plots_silva.qzv a la página https://view.qiime2.org/

Step 3: Construir un árbol filogenético para el análisis de diversidad 
---------------------------------------------------------------------

Crear el directorio tree 
```
mkdir analysis/tree  
```

```
qiime phylogeny align-to-tree-mafft-fasttree \
  --i-sequences rep-seqs.qza \
  --o-alignment aligned-rep-seqs.qza \
  --o-masked-alignment masked-aligned-rep-seqs.qza \
  --o-tree analysis/tree/unrooted-tree.qza \
  --o-rooted-tree analysis/tree/rooted-tree.qza
```

#### Rarefacción 

```
qiime diversity alpha-rarefaction \
--i-table table.qza \
--i-phylogeny analysis/tree/rooted-tree.qza \
--p-max-depth 229 \
--m-metadata-file sample-metadata.tsv \
--o-visualization alpha-rarefaction.qzv
```

Step 4: Análisis de diversidad alfa y beta
--------------------------------------------

***Nota** La profundidad de muestreo depende del resumen de la tabla de características de DADA2.

Aplique la lógica del párrafo anterior para ayudarlo a elegir una profundidad de muestreo uniforme.

```
qiime diversity core-metrics-phylogenetic \
  --i-phylogeny analysis/tree/rooted-tree.qza \
  --i-table table.qza \
  --p-sampling-depth 229 \
  --m-metadata-file sample-metadata.tsv \
  --output-dir core-metrics-results

qiime diversity alpha-group-significance \
  --i-alpha-diversity core-metrics-results/faith_pd_vector.qza \
  --m-metadata-file sample-metadata.tsv \
  --o-visualization core-metrics-results/faith-pd-group-significance.qzv

qiime diversity alpha-group-significance \
  --i-alpha-diversity core-metrics-results/evenness_vector.qza \
  --m-metadata-file sample-metadata.tsv \
  --o-visualization core-metrics-results/evenness-group-significance.qzv
```
Mediremos la diversidad alfa como la riqueza observada (número de taxones) o la uniformidad (la abundancia relativa de esos taxones) de una muestra promedio dentro de un tipo de ambiente (sin rarefacción).

Índice de Chao1
```
qiime diversity alpha \
--i-table table.qza \
--p-metric chao1 \
--o-alpha-diversity chao1.qza

qiime metadata tabulate \
--m-input-file chao1.qza \
--o-visualization chao1.qzv
```
Índice de Shannon 
```
qiime diversity alpha \
--i-table table.qza \
--p-metric shannon \
--o-alpha-diversity shannon.qza

qiime metadata tabulate \
--m-input-file shannon.qza \
--o-visualization shannon.qzv
```
Índice de Simpson 
```
qiime diversity alpha \
--i-table table.qza \
--p-metric simpson \
--o-alpha-diversity simpson.qza

qiime metadata tabulate \
--m-input-file simpson.qza \
--o-visualization simpson.qzv
```

**El Análisis de Coordenadas Principales (Principal Coordinates Analysis) de beta diversidad. 
La gráfica de PCoA representa la distancia de disimilitud de Bray-Curtis no ponderada para la diversidad de secuencias de amplicones (ASVs).** 

Dirigirse a la carpeta core-metrics-results
Realizar la visualización arrastrando el artefacto bray_curtis_emperor.qzv a la página https://view.qiime2.org/
