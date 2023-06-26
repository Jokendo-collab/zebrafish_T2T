#!/bin/bash
#SBATCH --partition=largemem
#SBATCH --cpus-per-task=32
#SBATCH --mem=800g
#SBATCH --ntasks-per-core=1
#SBATCH --time=240:00:00
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=javan.okendo@nih.gov
#SBATCH --job-name=F111_Trimmed

source /data/$USER/conda/etc/profile.d/conda.sh && source /data/$USER/conda/etc/profile.d/mamba.sh

cd /data/okendojo/zebrafish/data/fish11

mamba activate hifiasm

hifiData=/data/okendojo/zebrafish/data/fish11/hifi/qc/hifi.filt.fastq.gz
ont=/data/okendojo/zebrafish/data/fish11/ont/fastq_pass/fish11ontTrimmed.fastq.gz

hifiasm -o f11TrimmedONTHiFi  -t32 -l0 --ul ${ont}  ${hifiData}  
