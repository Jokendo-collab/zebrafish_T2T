#!/bin/bash
#SBATCH --partition=largemem
#SBATCH --cpus-per-task=32
#SBATCH --mem=800g
#SBATCH --ntasks-per-core=1
#SBATCH --time=240:00:00
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=javan.okendo@nih.gov
#SBATCH --job-name=HF_6purge

cd /data/okendojo/zebrafish/data/fish11

hifiData=/data/okendojo/zebrafish/data/fish6/hifi/*.fastq.gz
ont=/data/okendojo/zebrafish/data/fish6/ontData/*.fastq.gz

#hifiasm -o hifiasmF6NoPurge -t 32 --primary -l0  --ul ${ont}  ${hifiData} 2> fish6Nopurge.log

hifiasm -o hifiasmF6Purge -t 32 --primary --ul ${ont}  ${hifiData} 2> fish6purge.log
  
