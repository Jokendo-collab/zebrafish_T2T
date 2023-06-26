#!/bin/bash
#SBATCH --partition=norm
#SBATCH --cpus-per-task=32
#SBATCH --mem=120g
#SBATCH --ntasks-per-core=1
#SBATCH --time=240:00:00
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=javan.okendo@nih.gov
#SBATCH --job-name=pauve

cd /data/okendojo/zebrafish/data/fish11

module load python


ont=/data/okendojo/zebrafish/data/fish11/ont/fastq_pass/fish11ont.fastq.gz

pauvre marginplot --plot_maxlen 4000 --title "Fish11 ONT read quality" --plot_maxqual 25 --lengthbin 50 --fileform pdf png --qualbin 0.5 --fastq ${ont}
  
