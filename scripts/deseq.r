#Description: Using gene counts and metadata from RNA-seq experiment to perform deseq analysis. Equally cut-off gene counts less than 60, this is because gene with few reads mapping will have very large variations in fold change. though low amount of reads can either be signal of a lowly transcribed genes which maybe significant. However, there is a big chance that it's just some fluctuation of noise signal.

library(DESeq2)
library(ggplot2)

# Directories
col_data <- "../data/reference/metadata.csv"
counts_data <- "../data/reference/fcount_filtered.csv"
output_file <- "../results/featureCounts/dseq_results.txt"
output_plot <- "../results/featureCounts"

# Load the count data
countData <- read.csv(counts_data, row.names = 1)
# Convert to integers (if needed)
countData <- round(countData)

# Load the metadata
colData <- read.csv(col_data, row.names = 1)

# Set the design formula for DESeq2
design <- "Time + Replicates"
design <- as.formula(paste("~", design))

# Create DESeq2 dataset object
dds <- DESeqDataSetFromMatrix(countData = countData, colData = colData, design = design)

# Remove genes with <= 60 counts in all samples
dds <- dds[rowSums(counts(dds)) > 60, ]

# Run DESeq2 Analysis
dds <- DESeq(dds)
res <- results(dds)

# Write results to file
write.table(res, file = output_file, sep = "\t", quote = FALSE, col.names = NA)

# Generate and save plots
pdf(file.path(output_plot, "MA_plot.pdf"))
plotMA(res, main="MA Plot")
dev.off()

volcano_data <- as.data.frame(res)
volcano_data$significant <- volcano_data$padj < 0.05

pdf(file.path(output_plot, "Volcano_plot.pdf"))
ggplot(volcano_data, aes(x=log2FoldChange, y=-log10(padj), color=significant)) +
  geom_point() +
  theme_minimal() +
  labs(title="Volcano Plot", x="Log2 Fold Change", y="-Log10 Adjusted p-value")
dev.off()

vsd <- vst(dds, blind = FALSE)
pca_data <- plotPCA(vsd, intgroup = c("Time", "Replicates"), returnData = TRUE)

pdf(file.path(output_plot, "PCA_plot.pdf"))
ggplot(pca_data, aes(PC1, PC2, color = Time)) +  # Use 'Time' for color
  geom_point(size = 3) +
  theme_minimal() +
  labs(title = "PCA Plot", x = "PC1", y = "PC2")
dev.off()

cat("Results and plots saved successfully to", output_plot, "\n")

