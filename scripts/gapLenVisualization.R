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
