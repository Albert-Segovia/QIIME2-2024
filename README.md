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

Examinemos una descripción general conceptual de los distintos flujos de trabajo posibles para examinar los datos de secuencias de amplicones:

![](https://docs.qiime2.org/2023.9/_images/overview.png)

Las muestras obtenidas de este ejercicio fueron tomadas en Saanich Inlet que es un fiordo estacionalmente euxínico ubicado en la isla de Vancouver, Canadá, que se caracteriza por cambios estacionales y extremos generados por gradientes redox de la columna de agua, que son impulsados por ciclos de producción primaria y mezcla física. Igualmente, la ensenada se distingue por tener zonas marinas con deficiencia de oxígeno (ODZ) por sus profundidades restringidas (~225 m como máximo) y la presencia de aguas de fondo sulfurosas durante gran parte del año.

Trabajaremos con una fracción de los datos de amplicones de la región V6-V8 del 16S rRNA obtenidos en la plataforma ILLUMINA MiSeq (2 x 300 pb) con formato FASTQ. Además que se encuentran como paired-end (R1 y R2) y demultiplexados. Los datos originales se encuentran depositados en NCBI bajo el BioProject PRJNA901178 y en [PANGEA](https://doi.org/10.1594/PANGAEA.912191) del artículo "Network analysis of 16S rRNA sequences suggests microbial keystone taxa contribute to marine N2O cycling" [(Jameson et al., 2023)](https://www.nature.com/articles/s42003-023-04597-5).

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
2.  Copiar el escript download dentro de archivo download.sh y concederle permisos de ejecución

```
nano download.sh
```

```

# URL base del repositorio en GitHub
base_url="https://github.com/Albert-Segovia/QIIME2-2024/raw/a501a29ee1ac24d9f4a16b0d43295bb696ea94f3/input/"
# Lista de nombres de archivo
archivos=(
"GD10_S1_L001_R1_001.fastq.gz"  "GD16_S1_L001_R1_001.fastq.gz"  "MN13_S3_L001_R1_001.fastq.gz"  "MX11_S2_L001_R1_001.fastq.gz"
"GD10_S1_L001_R2_001.fastq.gz"  "GD16_S1_L001_R2_001.fastq.gz"  "MN13_S3_L001_R2_001.fastq.gz"  "MX11_S2_L001_R2_001.fastq.gz"
"GD11_S1_L001_R1_001.fastq.gz"  "MN10_S3_L001_R1_001.fastq.gz"  "MN16_S3_L001_R1_001.fastq.gz"  "MX13_S2_L001_R1_001.fastq.gz"
"GD11_S1_L001_R2_001.fastq.gz"  "MN10_S3_L001_R2_001.fastq.gz"  "MN16_S3_L001_R2_001.fastq.gz"  "MX13_S2_L001_R2_001.fastq.gz"
"GD13_S1_L001_R1_001.fastq.gz"  "MN11_S3_L001_R1_001.fastq.gz"  "MX10_S2_L001_R1_001.fastq.gz"  "MX16_S2_L001_R1_001.fastq.gz"
"GD13_S1_L001_R2_001.fastq.gz"  "MN11_S3_L001_R2_001.fastq.gz"  "MX10_S2_L001_R2_001.fastq.gz"  "MX16_S2_L001_R2_001.fastq.gz"
)

# Descargar cada archivo en la lista
for archivo in "${archivos[@]}"; do
    wget --restrict-file-names=ascii "${base_url}${archivo}"
done
```

3. Proporcionar permisos y realizar la descarga de las secuencias 
```
chmod +777 download.sh  
bash download.sh 
```
4. Se pueden descargar de manera manual pero tomaría demasiado tiempo (no es recomendable). 

##### Importar los datos con Casava 1.8 paired-end demultiplexed fastq (opcional)
QIIME utiliza sus propios artefactos por lo que tendremos que impotarlos al ambiente de trabajo (usando Casava)

```
qiime tools import \
  --type 'SampleData[PairedEndSequencesWithQuality]' \
  --input-path input \
  --input-format CasavaOneEightSingleLanePerSampleDirFmt \
  --output-path demux-paired.qza
```
##### Realizar el submuestreo de las lecturas de un estudio (opcional)
   
   qiime demux subsample-paired \
     --i-sequences demux-paired.qza \
     --p-fraction 0.1 \
     --o-subsampled-sequences demux-subsample.qza

   qiime demux summarize \
     --i-data demux-subsample.qza \
     --o-visualization demux-subsample.qzv


Step 1: Limpieza y control de calidad de los datos 
-----------------------------------------------
#### Descargar manualmente el objeto demux-paired.qza (importante) 
https://github.com/Albert-Segovia/QIIME2-2024/blob/main/demux-paired.qza o con:

```
base_url="https://github.com/Albert-Segovia/QIIME2-2024/raw/a501a29ee1ac24d9f4a16b0d43295bb696ea94f3/demux-paired.qza
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
Una vez eliminados los cebadores generaremos un artefacto de vusualización 
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
  --p-trunc-len-r 175 \
  --o-table table.qza \
  --o-representative-sequences rep-seqs.qza \
  --o-denoising-stats denoising-stats.qza
```

#### Generar archivos de resumen

En este paso se generaran los ortefactos de vusualización que contienen la tabla de características, las secuencias de características correspondientes y las estadísticas de eliminación de ruido de DADA2. 
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

Clasificaremos cada lectura idéntica o variante de los Amplicon Sequence Variant (ASV) a la resolución más alta (99% de identidad) de acuerdo a la base de datos de SILVA y/o Greengenes 2022. 

**Debido a limitaciones del taller, NO ejecute el qiime feature-classifier classify-sklearn.**


Descargar manualmente la base de datos Silva 138 99% OTUs full-length sequences: silva-138-99-nb-classifier.qza de https://docs.qiime2.org/2023.9/data-resources/ o con wget 
```
wget https://data.qiime2.org/2023.9/common/silva-138-99-515-806-nb-classifier.qza
```
Clasifiación con la base de datos de Silva (opcional)
```
qiime feature-classifier classify-sklearn \
--i-classifier silva-138-99-nb-classifier.qza \
--i-reads rep-seqs.qza \
--o-classification taxonomy_silva.qza
```


Descargar manualmente la base de datos de Greengenes2 2022.10 full length sequences: gg_2022_10_backbone_full_length.nb.qza de https://docs.qiime2.org/2023.9/data-resources/ o con wget 
```
wget https://data.qiime2.org/2023.9/common/gg_2022_10_backbone_full_length.nb.qza
```
Clasificación con la base de datos de Greengenes actualizada al año 2022 (opcional)
```
qiime feature-classifier classify-sklearn \
--i-classifier silva-138-99-nb-classifier.qza \
--i-reads rep-seqs.qza \
--o-classification taxonomy_silva.qza
```

**Necesitará acceder a una clasificación precalculada por lo que deberá descargar manualmente taxonomy_silva.qza.** 

Generar el artefacto de visualización de las asignaciones taxonómicas

```
qiime metadata tabulate \
--m-input-file taxonomy_silva.qza \
--o-visualization taxonomy_silva.qzv
```

Filtre lecturas clasificadas como mitocondrias y cloroplastos. Los ASV no asignados se conservan. Genere un archivo de resumen visible de la nueva tabla para ver el efecto del filtrado.
Según el desarrollador de QIIME, Nicholas Bokulich, el filtrado de baja abundancia (es decir, la eliminación de ASV que contienen muy pocas secuencias) no es necesario en el modelo ASV.
```
qiime taxa barplot \
--i-table table.qza \
--i-taxonomy taxonomy_silva.qza \
--m-metadata-file sample-metadata.tsv \
--o-visualization taxa-bar-plots_silva.qzv
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
--p-max-depth 1129 \
--m-metadata-file sample-metadata.tsv \
--o-visualization alpha-rarefaction.qzv
```

Step 4: Análisis de diversidad alfa y beta
--------------------------------------------

***Nota** La profundidad de muestreo de depende del resumen de la tabla de características de DADA2.

Aplique la lógica del párrafo anterior para ayudarlo a elegir una profundidad de muestreo uniforme.

```
qiime diversity core-metrics-phylogenetic \
  --i-phylogeny analysis/tree/rooted-tree.qza \
  --i-table table.qza \
  --p-sampling-depth 1129 \
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
# Beta diversity NMDS. Non-metric Multidimensional Scaling plot (NMDS) depicting Bray–Curtis dissimilarity distance for ASVs diversity.
