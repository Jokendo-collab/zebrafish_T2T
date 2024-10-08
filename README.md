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
# Gap filling in zebrafish
I did not use a script to do this but I can tell you how to do it in more detail:
- [ ] find the coordinates of the gaps (Ns) in the current zebrafish reference
- [ ] using these coordinates, create a BED file of the sequences flanking these gaps (we chose 100kb on either side)
- [ ] use bedtools getfasta to extract the gap-flanking sequences from the zebrafish reference
- [ ] map these gap-flanking sequences to your T2T assembly with winnowmap
- [ ] for a given gap, find the two flanking sequence alignments in the PAF file
- [ ] Use these coordinates to define the coordinates of your gap-filling sequence
- [ ] visualization `cut -f1,2 f11_filledgaps.fasta.fai | awk '{sub(/:.*/,"",$1)} 1' | awk -v OFS="\t" '{ print $1, $2}' | sort | uniq -c | awk -v OFS="\t" '{ print $2, $1, $3}' > filled_gaps_f11.txt`

## Three strategy assembly
- [ ] Run the standard verkko assembly using F2 ONT and PacBio data: It will give us the assembly blocks that are phased from HiFi and ONT alone
- [ ] Build strain specific k-mers, you'd need to merge each set of 3 strains and subtract that merge from the excluded one as shown below
```bash
# AB only
meryl output AB.only.meryl difference [ difference [ difference AB.k21.meryl TL.k21.meryl ] TU.k21.meryl ] WIK.k21.meryl

# TL only
meryl output TL.only.meryl difference [ difference [ difference TL.k21.meryl AB.k21.meryl ] TU.k21.meryl ] WIK.k21.meryl

# TU only
meryl output TU.only.meryl difference [ difference [ difference TU.k21.meryl WIK.k21.meryl ] AB.k21.meryl ] TL.k21.meryl

# WIK only
meryl output WIK.only.meryl difference [ difference [ difference WIK.k21.meryl TU.k21.meryl ] AB.k21.meryl ] TL.k21.meryl

```      
- [ ] Exract homopolymer compressed [HPC] sequences from GFA: `awk '/^S/{print ">"$2; printf "%s", $3 | "fold -w 80"; close("fold -w 80"); print ""}' assembly.homopolymer-compressed.gfa > assembly.homopolymer-compressed.fasta`

- [ ] Or ` verkko_asm]$ cat assembly.homopolymer-compressed.gfa | awk '{if (match($1, "^S")) { print ">"$2; print $3}}' | fold -c > assembly.homopolymer-compressed.fasta`
- [ ] Then you can run `meryl to count` each strain specific k-mer in the contigs and merge them into a single file
```bash
meryl-lookup -existence -sequence assembly.homopolymer-compressed.fasta -mers AB.only.meryl TU.only.meryl  TL.only.meryl  WIK.only.meryl -o f2_contigKemrs.txt
```
- [ ] Add nodes having 90% coverage per marker (From individual strain)
```bash
cat compressedMeryls/f2_contigKemrs.txt | sort -nk2,2 | awk '{SUM=$4+$6+$8+$10; tag=$4":"$6":"$8":"$10; if (SUM == 0) {NAME="UNKNOWN"; color="#AAAAAA";} else if ($4/SUM > 0.9) {NAME="AB"; color="#d7191c";} else if ($6/SUM > 0.9) {NAME="TU"; color="fdae61"; } else if ($8/SUM>0.9) {NAME="TL"; color="#abdda4"; } else if ($10/SUM>0.9) { NAME="WIK"; color="#2b83ba"; } else { NAME="MIXED"; color="#FFFF00"; } print $1"\t"$2"\t"NAME"\t"color"\t"tag; }' >> compressedMeryls/f2_contigKemrs.bandage.csv
```

# Analysis procedure to identify strain-specific variants in zebrafish 
- [ ] Call F0 variants using deep variant (Use sarek workflow )
- [ ] Merge the four strains variants into a multiVCF file using bcftools merge 
- [ ] Annotate the vcf file using gatk annotate by using Samplelist annotation flag
- [ ] Extract variants unique to a strain using grep ; Extract individual samples using ; `bcftools view -s AB_AB_strain  -O v -o AB_variants.vcf multisample.vcf`
- [ ] Convert strain specific variant to bed: `awk '! /\#/‘ TU.vcf | awk '{if(length($4) > length($5)) print $1"\t"($2-1)"\t"($2+length($4)-1); else print $1"\t"($2-1)"\t"($2+length($5)-1)}' > TU_variant.bed`
- [ ] Estract features from GTF to BED file: `cat GRCz11_annotation_genomic.gtf | convert2bed -i GTF -o BED --do-not-sort  > GRCz11_ncbi_GTF.bed`
- [ ] Intersect variants bedfile with transcripts bed file: `bedtools intersect -a variants.bed -b grcz11.bed -wa -wb > intersected_variants.bed`
- [ ] Extract RNA reads overlapping with variant positions:  `bedtools intersect -a sorted.bam -b intersected_variants.bed > reads_overlapping_variants.bam`
- [ ] Quantify transcripts using featureCounts: `featureCounts -a gencode_annotation.gtf -o counts.txt -R BAM recalibrated.bam`
- [ ] Visualize in IGV

## Haplotype blocks analysis
- [ ] Load plink version 1.9 ; `module load plink/1.9`
- [ ] Generate (fam, bed, and ped file) : `plink --vcf merged_top_contigs.vcf.gz  --allow-extra-chr --out myplink` | `plink2 --vcf g3.vcf.gz --make-bed --out plink_g3_output --set-missing-var-ids @:# --allow-no-sex`
- [ ] Identify haploblocks: `plink --bfile myplink --blocks no-pheno-req --out haplotype_blocks  --allow-extra-chr` | `plink --bfile plink_g3_output --blocks no-pheno-req --out block_g3_output --blocks-inform-frac 0.95 --allow-extra-chr`
- [ ] Generate LD matrix: `plink --r2 --bfile myplink --ld-window-r2 0.8 --out snp_ld --allow-extra-chr`
- [ ] Modify variants ID: `plink2 --bfile input --set-all-var-ids @:\# --make-bed --out output`
- [ ] `Rscript eQTLHap/eQTLHap.R --vcf -f snp2.vcf -g hapeqtl.txt -b block_g3_output.blocks.det -o test -w 1000 -a H --minIndividuals 2 --customBlocks` : block analysis
- [ ] `Rscript eQTLHap/eQTLHap.R --vcf -f snp11.vcf -g hpgene.txt -b block_g3_output.blocks.det -o TL -w 1000000 -a SGH --minIndividuals 6 --chrm 4 `

## Filtering node lengths
`cat compressed.mashmap.out | sed s/id:f://g |awk '{if ($6 ==4 && $(NF-1) > 0.97 && $4-$3 > 50000) print $1}'|sort |uniq -c|awk '{if ($1 > 1) print $NF}'`

      
