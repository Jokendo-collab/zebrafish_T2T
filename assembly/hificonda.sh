#!/bin/bash
#SBATCH --partition=largemem
#SBATCH --cpus-per-task=32
#SBATCH --mem=800g
#SBATCH --ntasks-per-core=1
#SBATCH --time=240:00:00
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=javan.okendo@nih.gov
#SBATCH --job-name=F6_Trimmed

source /data/$USER/conda/etc/profile.d/conda.sh && source /data/$USER/conda/etc/profile.d/mamba.sh

cd /data/okendojo/zebrafish/data/fish6/asm/filteredONT

mamba activate hifiasm

hifiData=/data/okendojo/zebrafish/data/fish6/hifi/qc/m54313U_220817_024630.hifi_reads.filt.fastq.gz
ont=/data/okendojo/zebrafish/data/fish6/ontData/zontTrimmed.fastq.gz

hifiasm -o f6TrimmedONTHiFi  -t32 -l0 --ul ${ont}  ${hifiData}  
