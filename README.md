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
#!/bin/bash

# Definir la URL base del repositorio
BASE_URL="https://github.com/Albert-Segovia/QIIME2-2024/blob/045ddd1ff5ee1bf532a3acdb2727a765c9684043/data/"

# Lista de nombres de archivos
FILES=("APR_100_S126_L001_R1_001.fastq.gz"
"APR_100_S126_L001_R2_001.fastq.gz"
"APR_110_S138_L001_R1_001.fastq.gz"
"APR_110_S138_L001_R2_001.fastq.gz"
"APR_130_S150_L001_R1_001.fastq.gz"
"APR_130_S150_L001_R2_001.fastq.gz"
"APR_160_S162_L001_R1_001.fastq.gz"
"APR_160_S162_L001_R2_001.fastq.gz"
"APR_75_S102_L001_R1_001.fastq.gz"
"APR_75_S102_L001_R2_001.fastq.gz"
"APR_90_S114_L001_R1_001.fastq.gz"
"APR_90_S114_L001_R2_001.fastq.gz"
"JUN_100_S127_L001_R1_001.fastq.gz"
"JUN_100_S127_L001_R2_001.fastq.gz"
"JUN_110_S139_L001_R1_001.fastq.gz"
"JUN_110_S139_L001_R2_001.fastq.gz"
"JUN_130_S151_L001_R1_001.fastq.gz"
"JUN_130_S151_L001_R2_001.fastq.gz"
"JUN_160_S163_L001_R1_001.fastq.gz"
"JUN_160_S163_L001_R2_001.fastq.gz"
"JUN_75_S103_L001_R1_001.fastq.gz"
"JUN_75_S103_L001_R2_001.fastq.gz"
"JUN_90_S115_L001_R1_001.fastq.gz"
"JUN_90_S115_L001_R2_001.fastq.gz"
"AUG_100_S128_L001_R1_001.fastq.gz"
"AUG_100_S128_L001_R2_001.fastq.gz"
"AUG_110_S140_L001_R1_001.fastq.gz"
"AUG_110_S140_L001_R2_001.fastq.gz"
"AUG_130_S152_L001_R1_001.fastq.gz"
"AUG_130_S152_L001_R2_001.fastq.gz"
"AUG_160_S164_L001_R1_001.fastq.gz"
"AUG_160_S164_L001_R2_001.fastq.gz"
"AUG_75_S104_L001_R1_001.fastq.gz"
"AUG_75_S104_L001_R2_001.fastq.gz"
"AUG_90_S116_L001_R1_001.fastq.gz"
"AUG_90_S116_L001_R2_001.fastq.gz"
"OCT_100_S175_L001_R1_001.fastq.gz"
"OCT_100_S175_L001_R2_001.fastq.gz"
"OCT_110_S187_L001_R1_001.fastq.gz"
"OCT_110_S187_L001_R2_001.fastq.gz"
"OCT_130_S174_L001_R1_001.fastq.gz"
"OCT_130_S174_L001_R2_001.fastq.gz"
"OCT_160_S186_L001_R1_001.fastq.gz"
"OCT_160_S186_L001_R2_001.fastq.gz"
"OCT_75_S176_L001_R1_001.fastq.gz"
"OCT_75_S176_L001_R2_001.fastq.gz"
"OCT_90_S188_L001_R1_001.fastq.gz"
"OCT_90_S188_L001_R2_001.fastq.gz")

# Iterar sobre la lista de archivos
for file in "${FILES[@]}"; do
    # Construir la URL completa del archivo
    FILE_URL="$BASE_URL$file"

    # Descargar el archivo usando wget
    wget "$FILE_URL"
done

```

3. Proporcionar permisos y realizar la descarga de las secuencias 
```
chmod +777 download.sh  
bash download.sh 
```

##### Importar los datos con Casava 1.8 paired-end demultiplexed fastq (opcional)
QIIME utiliza sus propios artefactos por lo que tendremos que impotarlos al ambiente de trabajo (usando Casava)

```
qiime tools import \
  --type 'SampleData[PairedEndSequencesWithQuality]' \
  --input-path input \
  --input-format CasavaOneEightSingleLanePerSampleDirFmt \
  --output-path demux-paired-end-full.qza
```

#### Submuestreo de los datos para el ejercicio (opcional)
Realizaremos el sumbmuestreo de los datos para facilitar el análisis 
```

qiime demux subsample-paired \
  --i-sequences demux-paired-end-full.qza \
  --p-fraction 0.1 \
  --o-subsampled-sequences demux-subsample.qza
```

Step 1: Limpieza y control de calidad de los datos 
-----------------------------------------------
#### Descargar manualmente el objeto demux-subsample.qza (importante) 
https://github.com/Albert-Segovia/QIIME2-2024/blob/main/demux-subsample.qza

#### Eliminar los cebadores 

En ocasiones las secuencias aún tienen los cebadores adjuntos por lo que se deben de eliminar (usando cutadapt) justo antes de eliminar el ruido.

```
qiime cutadapt trim-paired \
--i-demultiplexed-sequences demux-subsample.qza \
--p-front-f ACGCGHNRAACCTTACC \
--p-front-r ACGGGCRGTGWGTRCAA \
--p-error-rate 0.1 \
--output-dir analysis/seqs_trimmed \
--verbose
```

#### Crear objetos de visualización e interpretar la calidad de las secuencias
Una vez eliminados los cebadores generaremos un artefacto de vusualización 
```
  qiime demux summarize \
  --i-data demux-subsample.qza \
  --o-visualization demux-subsample.qzv
```
Arrastrar el artefacto demux-subsample.qzv a la página https://view.qiime2.org/

#### Recorte e eliminación de ruido  
Usaremos estos gráficos para determinar qué parámetros de recorte queremos usar para eliminar el ruido con DADA2 y luego eliminaremos el ruido de las lecturas usando dada2 denoise-paired
```

qiime dada2 denoise-paired \
  --i-demultiplexed-seqs demux-subsample.qza \
  --p-trim-left-f 6 \
  --p-trim-left-r 6 \
  --p-trunc-len-f 263 \
  --p-trunc-len-r 221 \
  --o-table table.qza \
  --o-representative-sequences rep-seqs.qza \
  --o-denoising-stats denoising-stats.qza
```

#### Generar archivos de resumen
En este paso se generaran los ortefactos de vusualización que contienen la tabla de características, las secuencias de características correspondientes y las estadísticas de eliminación de ruido de DADA2. 
Es necesario tener el archivo de metadatos. Descargarlo con el script: wget https://github.com/Albert-Segovia/QIIME2-2024/blob/045ddd1ff5ee1bf532a3acdb2727a765c9684043/data/sample-metadata.tsv

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
Clasificaremos cada lectura idéntica o variante de los Amplicon Sequence Variant (ASV)a la resolución más alta según una base de datos de SILVA
Descargar manualmente silva-138-99-nb-classifier.qza o 

```
qiime feature-classifier classify-sklearn \
--i-classifier silva-138-99-nb-classifier.qza \
--i-reads rep-seqs.qza \
--o-classification taxonomy_silva.qza
```

Generamos el archivo para visualizacion

```
qiime metadata tabulate \
--m-input-file taxonomy_silva.qza \
--o-visualization taxonomy_silva.qzv


qiime taxa barplot \
--i-table table.qza \
--i-taxonomy taxonomy_silva.qza \
--m-metadata-file sample-metadata.tsv \
--o-visualization taxa-bar-plots_silva.qzv







# Generar las visualizacion de los datos (QIIME 2 View)
# A continuación, veremos la calidad de la secuencia 

qiime demux summarize \
--i-data demux-paired-end.qza \
--o-visualization demux-paired-end.qzv








# Análisis de Paired-end read 
# gene 16S rRNA región V4 cebadores 515F/806R
# Esto realiza el filtrado de calidad, la verificación de quimeras y la unión de lectura de Paired-end. 
La acción denoise_paired requiere algunos parámetros que se establecerán en función de los gráficos de puntuación de calidad 
de secuencia que se generaron previamente en el resumen de las lecturas de demultiplexación.
# Generar y cuantificar variantes de secuencia de amplicón (ASV) con DADA2.
# Tenemos que considerar los parámetros de recorte que queremos usar para eliminar el ruido con DADA2, 
y luego eliminar el ruido de las lecturas usando dada2 denoise-paired. 

qiime dada2 denoise-paired \
  --i-demultiplexed-seqs demux-paired-end.qza \
  --p-trim-left-f 10 \     
  --p-trim-left-r 10 \
  --p-trunc-len-f 300 \
  --p-trunc-len-r 300 \
  --o-table table.qza \
  --o-representative-sequences rep-seqs.qza \
  --o-denoising-stats denoising-stats.qza

# En este paso, tendrán ortefactos de vusualización que contienen la tabla de características, las secuencias de características correspondientes 
y las estadísticas de eliminación de ruido de DADA2. Es necesario tener el archivo de metadatos. Se unieron a 253 pb.  
Se puede generar resúmenes de estos de la siguiente manera:
 
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
  
# Asignacion taxonomica con clasificadores Naive Bayes entrenados usando -Greengenes

qiime feature-classifier classify-sklearn \
--i-classifier gg-13-8-99-515-806-nb-classifier.qza \
--i-reads rep-seqs.qza \
--o-classification taxonomy_gg.qza

# Generamos el archivo para visualizacion

qiime metadata tabulate \
--m-input-file taxonomy_gg.qza \
--o-visualization taxonomy_gg.qzv

# Generar grafica de barras apiladas con dos bases de datos 
# taxonomy-barplot con gg

qiime taxa barplot \
--i-table table.qza \
--i-taxonomy taxonomy_silva.qza \
--m-metadata-file sample-metadata.tsv \
--o-visualization taxa-bar-plots_gg.qzv

# Asignacion taxonomica con clasificadores Naive Bayes entrenados usando -Silva  

qiime feature-classifier classify-sklearn \
--i-classifier silva-138-99-515-806-nb-classifier.qza \
--i-reads rep-seqs.qza \
--o-classification taxonomy_silva.qza

# Generamos el archivo para visualizacion
qiime metadata tabulate \
--m-input-file taxonomy_silva.qza \
--o-visualization taxonomy_silva.qzv

# Taxonomy-barplot con silva

qiime taxa barplot \
--i-table table.qza \
--i-taxonomy taxonomy_silva.qza \
--m-metadata-file sample-metadata.tsv \
--o-visualization taxa-bar-plots_silva.qzv

# Reconstruccion filogenetica para los analisis de diversidad donde se genera un árbol 

qiime phylogeny align-to-tree-mafft-fasttree \
  --i-sequences rep-seqs.qza \
  --o-alignment aligned-rep-seqs.qza \
  --o-masked-alignment masked-aligned-rep-seqs.qza \
  --o-tree unrooted-tree.qza \
  --o-rooted-tree rooted-tree.qza




# Análisis de diversidad alfa y beta
# Nota
# La profundidad de muestreo de 208 se eligió en función del resumen de la tabla de características de DADA2.

Aplique la lógica del párrafo anterior para ayudarlo a elegir una profundidad de muestreo uniforme.

qiime diversity core-metrics-phylogenetic \
  --i-phylogeny rooted-tree.qza \
  --i-table table.qza \
  --p-sampling-depth 208 \
  --m-metadata-file sample-metadata.tsv \
  --output-dir core-metrics-results

# Rarefacción 


qiime diversity alpha-rarefaction \
--i-table table.qza \
--i-phylogeny rooted-tree.qza \
--p-max-depth 130 \
--m-metadata-file sample-metadata.tsv \
--o-visualization alpha-rarefaction.qzv

