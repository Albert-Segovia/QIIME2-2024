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

