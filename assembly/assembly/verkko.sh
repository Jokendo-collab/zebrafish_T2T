#!/bin/bash
#SBATCH --partition=norm
#SBATCH --cpus-per-task=32
#SBATCH --mem=180g
#SBATCH --ntasks-per-core=1
#SBATCH --time=240:00:00
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=javan.okendo@nih.gov
#SBATCH --job-name=f11vkconda


#Load the modules
source /data/$USER/conda/etc/profile.d/conda.sh && source /data/$USER/conda/etc/profile.d/mamba.sh

mamba activate hifiasm #verkko and hifiasm are installed together

#move to the asm dir

cd /data/okendojo/zebrafish/data/fish11

#Run verkko

verkko -d asmvk_2 --hifi /data/okendojo/zebrafish/data/fish11/hifi/*.fastq.gz --nano /data/okendojo/zebrafish/data/fish11/ont/fastq_pass/*.fastq.gz --slurm --graphaligner --mbg 



