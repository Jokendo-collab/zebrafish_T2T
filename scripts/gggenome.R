
setwd("/Users/okendojo/Downloads/custome_verkko/gapfilling")
library(tidyverse)
library(gggenomes)
library(IRanges)

#seqs
Zfish_seq = read_seqs("combinedfasta.fasta")

PAR_links <- read_paf('combined_t2t_grcz_alignment.paf')
PAR_links <- subset(PAR_links, map_quality==60)
PAR_links <- subset(PAR_links, map_length>100000) 
# Feats
PAR_gaps <- read_table('n_gaps.bed',
                       col_names = c('seq_id', 'start', 'end'), 
                       col_types = list('c','i','i'))

PAR_tel <- read_table('telo.bed',
                      col_names = c('seq_id', 'start', 'end'), 
                      col_types = list('c','i','i'))
# Plot
PAR_plot <- gggenomes(seqs = Zfish_seq, links = PAR_links,
                      feats = list(PAR_gaps, PAR_tel))

PAR_plot + geom_seq() + 
  geom_bin_label() +
  geom_link() +
  geom_feat(data = feats(PAR_gaps), colour='red') +
  geom_feat(data = feats(PAR_tel), colour='blue')
  