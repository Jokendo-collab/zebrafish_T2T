#!/bin/bash
#SBATCH --partition=norm
#SBATCH --cpus-per-task=32
#SBATCH --mem=80g
#SBATCH --ntasks-per-core=1
#SBATCH --time=05:00:00
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=javan.okendo@nih.gov
#SBATCH --job-name=adapterblast

#Load the required modules
module load blast

#======================
###paradisefish genome annotation##
#=====================
#1. Run functional annotation

cd /data/okendojo/zebrafish/data/fish11/blast

#prepare the uniprot database
#makeblastdb -in assembly.fasta

query=adapter.fa

db=db/assembly.fasta


blastn -query ../f11vkcleanedata/assembly.fasta -db ${db} -evalue 1e-6 -max_hsps 1 -max_target_seqs 1 -num_threads 32 -outfmt 6 -out blastn.out
