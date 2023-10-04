#!/bin/bash
#SBATCH --partition=norm
#SBATCH --cpus-per-task=32
#SBATCH --mem=232g
#SBATCH --ntasks-per-core=1
#SBATCH --time=96:00:00
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=javan.okendo@nih.gov
#SBATCH --job-name=ZF_jellyfish

# Load the module
module load jellyfish

cd /data/okendojo/zebrafish/data/G3/jellyFish

#Count kmers using jellyfish
jellyfish count  -m 21 -s 2000M -t 32  <(zcat 19412527_R1.fq.gz 19412527_R2.fq.gz 19412535_R1.fq.gz 19412535_R2.fq.gz 19412539_R1.fq.gz 19412539_R2.fq.gz 19412541_R1.fq.gz 19412541_R2.fq.gz) -o mer_counts2.jf

#Export the kmer count histogram
jellyfish histo -t 32 mer_counts2.jf > mer_counts2.histo
	


