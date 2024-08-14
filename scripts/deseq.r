#Description: Using gene counts and metadata from RNA-seq experiment to perform deseq analysis. Equally cut-off gene counts less than 60, this is because gene with few reads mapping will have very large variations in fold change. though low amount of reads can either be signal of a lowly transcribed genes which maybe significant. However, there is a big chance that it's just some fluctuation of noise signal.

library(DESeq2)

# Directories
col_data <- "../data/reference/metadata.csv"
counts_data <- "../data/reference/fcount_filtered.csv"
output_file <- "../results/featureCounts/dseq_results.txt"

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

cat("Results saved to", output_file, "\n")
