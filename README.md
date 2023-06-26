# Telomere-to-telomere consortium Zebrafish project
We have devised two separate strategies for assembling the zebrafish genome “telomere-to-telomere” (T2T): The first strategy uses homozygous TU fish generated by heat shock disruption of mitosis I. Cell lines were established for two HS diploid fish and then genomic DNA was isolated both from the adult tissues as well as the cultured fibroblasts. DNA from the tissue was used for **PacBio HiFi** sequencing and the fibroblast DNA was used for **Oxford Nanopore sequencing (ONT)**. We will perform de novo assembly using either the **Verkko** or **HiFiasm** genome assemblers. The second strategy we termed the **“3 generations”** approach. One fish from each of the 4 most commonly used zebrafish lab lines: **TU, AB, WIK, and TL** were used as the **4 “grandparents”** and were short read sequenced to document all unique, identifying SNV for each parent. One fish from each of the 2 grandparent pairings was used to generate pools of the 3rd generation offspring. The pooled genomic DNA from these offspring was used for both **PacBio HiFi and ONT sequence**. The SNV data from the grandparents is then used to separate all the reads into haplotype bins and all 4 haplotypes are resolved simultaneously using the Verkko assembler.

## DNA extraction and sequencing
This information is needed

## Genome assembly
We used the two widely used genome assemblers; [Verkko](https://github.com/marbl/verkko) and [HiFiasm](https://github.com/chhylp123/hifiasm) to do the assembly. 

