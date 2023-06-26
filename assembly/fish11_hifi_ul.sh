#!/bin/bash
#SBATCH --partition=largemem
#SBATCH --cpus-per-task=32
#SBATCH --mem=800g
#SBATCH --ntasks-per-core=1
#SBATCH --time=96:00:00
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=javan.okendo@nih.gov
#SBATCH --job-name=F11hifiasmconda

source /data/$USER/conda/etc/profile.d/conda.sh && source /data/$USER/conda/etc/profile.d/mamba.sh

mamba activate hifiasm #verkko and hifiasm are installed together

cd /data/okendojo/zebrafish/data/fish11/ont/fastq_pass

hifiData=/data/okendojo/zebrafish/data/fish11/hifi/*.fastq.gz
#ont=/data/okendojo/zebrafish/data/fish11/ont/fastq_pass/fish11ont.fastq.gz

#hifiasm -o f11_hifiasmconda -u 1 -z 50 --hom-cov -D 10 -N 75 -t32 -l0 --ul ${ont}  ${hifiData} 2> F11hifiasmconda.log  


hifiasm -o zhifiams_ontList -t 64 -l 0 --ul /data/okendojo/zebrafish/data/fish11/ont/fastq_pass/*.fastq.gz  /data/okendojo/zebrafish/data/fish11/hifi/*.fastq.gz	
