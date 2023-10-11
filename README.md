# Zebrafish pangenome
We have devised two separate strategies for assembling the zebrafish genome “telomere-to-telomere” (T2T): The first strategy uses homozygous TU fish generated by heat shock disruption of mitosis I. Cell lines were established for two HS diploid fish and then genomic DNA was isolated both from the adult tissues as well as the cultured fibroblasts. DNA from the tissue was used for **PacBio HiFi** sequencing and the fibroblast DNA was used for **Oxford Nanopore sequencing (ONT)**. We performed *de novo* assembly using **Verkko** genome assembler. The second strategy we termed the **“3 generations”** approach. One fish from each of the 4 most commonly used zebrafish laboratory strains: **TU, AB, WIK, and TL** were used as the **4 “grandparents”** and were short read sequenced to document all unique, identifying structural nucleotide variants [SNV] for each parent. One fish from each of the 2 grandparent pairings was used to generate pools of the 3rd generation offspring. The pooled genomic DNA from these offspring was used for both **PacBio HiFi and ONT sequence**. The SNV data from the grandparents is then used to separate all the reads into haplotype bins and all 4 haplotypes are resolved simultaneously using the Verkko assembler.

## DNA extraction and sequencing
To be added

## Proposed analysis plan
### Genome assembly
#### To do:
- [x] Run [Verkko](https://github.com/marbl/verkko) assembler to assemble the genomes **_de nove_**.  
- [x] Assembly quality assessments
- [x] Synteny analysis: visualize filled gaps in the GRCz11 reference genome

### Gene annotation

### Methylation pattern analysis

### Repeat annotation

### Variant calling and analysis

### Centromere analysis and annotation(s)
- [ ] Train [dna-nn](https://github.com/Jokendo-collab/dna-nn) to train the classification model
- [ ] Extract aplha satellite regions in a bed file `dna-brnn -Ai models/attcc-alpha.knm -t16 seq.fa > seq.bed`
- [ ] Extract the centromere sequences from the T2T assembly: `bedtools getfasta -fi zebrafish_genome.fasta -bed potential_centromeres.gff -fo centromeric_sequences.fasta`
- [ ] Create a sequence logo plot to visualize the different bases:
```bash
# Load necessary libraries
library(ggseqlogo)

# Define paths and filenames
fasta_file <- "centromeric_sequences.fasta"  # Path to the extracted centromere sequences in FASTA format
output_plot <- "centromere_sequence_logo.png"  # Output file for the sequence logo plot

# Load the centromere sequences
sequences <- Biostrings::readDNAStringSet(fasta_file)

# Create a sequence logo plot
seq_logo <- ggseqlogo(sequences)

# Save the plot to an image file (e.g., PNG)
ggsave(output_plot, seq_logo)

cat("Centromere sequence logo plot saved to", output_plot, "\n")

```

