#!/bin/bash
#SBATCH --partition=largemem
#SBATCH --cpus-per-task=32
#SBATCH --mem=800g
#SBATCH --ntasks-per-core=1
#SBATCH --time=240:00:00
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=javan.okendo@nih.gov
#SBATCH --job-name=F11Purge

cd /data/okendojo/zebrafish/data/fish11

hifiData=/data/okendojo/zebrafish/data/fish11/hifi/*.fastq.gz
ont=/data/okendojo/zebrafish/data/fish11/ont/fastq_pass/fish11ont.fastq.gz

hifiasm -o fish11_hifi_ulPurge  -t32 -l1 --ul ${ont}  ${hifiData} 2> F11Purge.log  
