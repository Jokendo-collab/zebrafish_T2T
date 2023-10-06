# Load necessary libraries
library(ggplot2)
library(dplyr)
library(readr)
library(cowplot)

# Load the BED file containing gap coordinates (replace with your data)
bed_file <- "n_gaps.bed"

# Read the BED file into a data frame
gap_data <- read_delim(bed_file, delim = "\t", col_names = c("Chromosome", "Start", "End"))

# Calculate gap lengths
gap_data <- gap_data %>% mutate(Gap_Length = End - Start)

# Summary statistics of gap lengths
summary(gap_data$Gap_Length)

# Create a histogram to visualize gap length distribution
ggplot(gap_data, aes(x = Gap_Length)) +
  geom_histogram(binwidth = 100, fill = "red", color = "black") +
  labs(
    title = "Distribution of Gap Lengths in Genome Assembly",
    x = "Gap Length",
    y = "Frequency"
  ) +
  theme_minimal()

# Visualize gap positions on chromosomes
ggplot(gap_data, aes(x = Chromosome, y = Gap_Length)) +
  geom_bar(stat = "identity", fill = "red") +
  labs(
    title = "Gaps in GRCz11",
    x = "Chromosome",
    y = "Gap Length"
  ) +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_y_continuous(limits = c(0,200000)) +
  theme(axis.text = element_text(size = 10))


# Optional: Export the gap data or plots as needed
# write.csv(gap_data, "gap_data.csv")
ggsave("gap_length_distribution.pdf", height = 6, width = 8)



library(karyoploteR)

# Define the paths to your FASTA files (genome assemblies) and BED file (syntenic regions)
fasta_file1 <- "ref_scaffold.fasta"
fasta_file2 <- "genome2.fasta"
bed_file <- "syntenic_regions.bed"

# Load the genome assemblies from the FASTA files
genome1 <- getGenome(fasta_file1)
genome2 <- getGenome(fasta_file2)

# Create a plot with two ideograms (for two genomes)
kp <- plotKaryotype(list(genome1, genome2), ideogram.plotter = NULL)

# Add syntenic regions from the BED file
addBed(kp, bed_file, col = "blue", lwd = 2)

# Customize the plot (optional)
kp <- set.karyoplot(kp, chr.padding = 0.5)

# Save the plot as an image file (e.g., PNG)
output_file <- "synteny_plot.png"
savePlot(kp, output_file)


kp <- plotKaryotype(genome="danRer11", plot.type=2, chromosomes=c("chr1", "chr2", "chr3","chr4","chr5","chr6","chr7",
                                                              "chr8","chr9","chr10","chr11","chr12","chr13","chr14",
                                                              "chr15","chr16","chr17","chr18","chr19","chr20","chr21"
                                                              ,"chr22","chr23","chr24","chr25","chrM"))










