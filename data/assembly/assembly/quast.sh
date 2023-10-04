#!/bin/bash
#SBATCH --partition=norm
#SBATCH --cpus-per-task=32
#SBATCH --mem=232g
#SBATCH --ntasks-per-core=1
#SBATCH --time=36:00:00
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=javan.okendo@nih.gov
#SBATCH --job-name=quast

#Activate mamba environment
source /data/$USER/conda/etc/profile.d/conda.sh && source /data/$USER/conda/etc/profile.d/mamba.sh

mamba activate QUAST
module load augustus

cd /data/okendojo/zebrafish/data/fish11


quast.py -o quast_2/ -r /data/okendojo/zebrafish/refGenome/GRCz11.fasta --est-ref-size 1456394440 --debug --fragmented  -l "F11_HiFiasm, F11_HifiasmTrimmed,F11_Verkko,F11_vkTrimmed, F6_HiFiasm, F6_Verkko, F6_VkTrimmed" --space-efficient --eukaryote /data/okendojo/zebrafish/data/shawmasmres/fish11_hifi_ul_hifiasm.fasta /data/okendojo/zebrafish/data/fish11/cleanedHIfiasmData/hifiasm.fasta /data/okendojo/zebrafish/data/shawmasmres/fish11_hifi_ul_verkko.fasta /data/okendojo/zebrafish/data/fish11/f11vkcleanedata/assembly.fasta /data/okendojo/zebrafish/data/shawmasmres/fish6_hifi_ul_hifiasm.fasta /data/okendojo/zebrafish/data/shawmasmres/fish6_hifi_ul_verkko.fasta /data/okendojo/zebrafish/data/fish6/asm/f6vkcleanedONT/assembly.fasta  
