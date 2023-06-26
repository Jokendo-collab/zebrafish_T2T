#!/bin/bash
#SBATCH --partition=norm
#SBATCH --cpus-per-task=32
#SBATCH --mem=180g
#SBATCH --ntasks-per-core=1
#SBATCH --time=10:00:00
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=javan.okendo@nih.gov
#SBATCH --job-name=mashmap


#==================================
#####Load the required module======
#==================================
module load mashmap

#move to the directory containing the data

cd /data/okendojo/zebrafish/assembly_results/homopolymer

#Start the analysis
mashmap -r GRCz11_genomic.fasta -q assembly.fasta --pi 95 -s 1000 -f one-to-one -k 21 -t 32 -o assmbly-chr.csv
