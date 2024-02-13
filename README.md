# Curso Metagenómica UPEMOR 2024
![](https://qiime2.org/assets/img/qiime2.svg)

Análisis de los amplicones del gen ribosomal 16S rRNA en QIIME2 (Metabarcoding)                   
PhD. Alberto Segovia (alberto.segovia@ibt.unam.mx)                       
Copyright QIIME2-2024	

<!-- This content will not appear in the rendered Markdown -->

QIIME (Quantitative Insights Into Microbial Ecology)
----------------------------------------

[(Bolyen et al., 2019)](https://www.nature.com/articles/s41587-019-0209-9).



Descripción conceptual de QIIME2
----------------------------------------

Examinemos una descripción general conceptual de los distintos flujos de trabajo posibles para examinar los datos de secuencias de amplicones:

![](https://docs.qiime2.org/2023.9/_images/overview.png)

Las muestras obtenidas de este ejercicio fueron tomadas en Saanich Inlet que es un fiordo estacionalmente euxínico ubicado en la isla de Vancouver, Canadá, que se caracteriza por cambios estacionales extremos generados por gradientes redox de la columna de agua, que son impulsados por ciclos de producción primaria (producción de materia orgánica que realizan los organismos autótrofos) y mezcla física. Igualmente, la ensenada se distingue por tener zonas marinas con deficiencia de oxígeno (ODZ) por sus profundidades restringidas (~225 m como máximo) y la presencia de aguas de fondo sulfurosas durante gran parte del año.

Trabajaremos con datos de amplicones de la región V6-V8 del 16S rRNA obtenidos en la plataforma ILLUMINA MiSeq (2 x 300 pb) con formato FASTQ. Los datos fueron depositados en NCBI bajo el BioProject PRJNA901178 y en PANGEA https://doi.org/10.1594/PANGAEA.912191 del artículo "Network analysis of 16S rRNA sequences suggests microbial keystone taxa contribute to marine N2O cycling" [(Jameson et al., 2023)(https://www.nature.com/articles/s42003-023-04597-5)]. [(Bolyen et al., 2019)](https://www.nature.com/articles/s41587-019-0209-9).


  QIIME 2 command-line interface
  --------------------------------------

`$ conda activate qiime2-amplicon-2023.9`                                                                                                                                                                    

`$ qiime --help`





# QIIME2 utiliza sus propios artefactos, por lo que es necesario imporalos a su entorno. 
# Cambiar el formato de las secuencias antes de importar. Consierar los siguiente:  

$ mv sequence_R1_fastq.gz BAQ1552.1.1_67_L001_R1_001.fastq.gz  
$ mv sequence_R2_fastq.gz BAQ1552.1.1_67_L001_R2_001.fastq.gz

# Importar secuencias demultiplexing
# Casava 1.8 paired-end demultiplexed fastq o Casava 1.8 single-end demultiplexed fastq

qiime tools import \
  --type 'SampleData[PairedEndSequencesWithQuality]' \
  --input-path r \
  --input-format CasavaOneEightSingleLanePerSampleDirFmt \
  --output-path demux-paired-end.qza

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

