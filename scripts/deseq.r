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
# Convert to integers 
countData <- round(countData)

# Load the metadata
colData <- read.csv(col_data, row.names = 1)

# Set the design formula for DESeq2
design <- "Time + Replicates"
design <- as.formula(paste("~", design))

#colData factor
colData$Time <- factor(colData$Time)
colData$Replicates <- factor(colData$Replicates)

# Create DESeq2 dataset object
dds <- DESeqDataSetFromMatrix(countData = countData, colData = colData, design = design)

# Remove genes with <= 60 counts in all samples
dds <- dds[rowSums(counts(dds)) > 60, ]

# Run DESeq2 Analysis
dds <- DESeq(dds)
res <- results(dds)
resultsNames(dds)

# Write results to file
write.table(res, file = output_file, sep = "\t", quote = FALSE, col.names = NA)

#Dispersion plot: A dispersion plot in DESeq2 is a visual tool to check the #quality of your data before comparing gene expression levels.
#It shows how much the expression of each gene varies (dispersion) compared to #its average expression level (mean). Ideally, genes with higher expression #levels should have lower variability.
pdf(file.path(output_plot, "Dispersion_plot.pdf"))
plotDispEsts(dds, main = "Dispersion plot")
dev.off()

#Histogram of pvalues and adjusted pvalues. useful to show if there are truely #signifantly expressed genes.
pdf(file.path(output_plot, "histogram_pvalue.pdf"))
hist(res$pvalue, breaks = 20, col = "grey", main = "Histogram of p-values", xlab = "p-value")
dev.off()
pdf(file.path(output_plot, "histogram_adj_pvalue.pdf"))
hist(res$padj, breaks = 20, col = "grey", main = "Histogram of Adjusted p-values", xlab = "Adjusted p-value")
dev.off()


# MA plot for Time 25 vs Time 0
res_time_25_vs_0 <- results(dds, name = "Time_25_vs_0")
pdf(file.path(output_plot, "MA_plot_time_25_vs_0.pdf"))
plotMA(res_time_25_vs_0, main="MA Plot: Time 25 vs Time 0")
dev.off()

# Similarly, we can generate plots for other time contrasts
res_time_13_vs_0 <- results(dds, name = "Time_13_vs_0")
pdf(file.path(output_plot, "MA_plot_time_13_vs_0.pdf"))
plotMA(res_time_13_vs_0, main="MA Plot: Time 13 vs Time 0")
dev.off()

res_time_8_vs_0 <- results(dds, name = "Time_8_vs_0")
pdf(file.path(output_plot, "MA_plot_time_8_vs_0.pdf"))
plotMA(res_time_8_vs_0, main="MA Plot: Time 8 vs Time 0")
dev.off()

# MA plot for Replicate 3 vs Replicate 1
res_replicate_3_vs_1 <- results(dds, name = "Replicates_3_vs_1")
pdf(file.path(output_plot, "MA_plot_replicate_3_vs_1.pdf"))
plotMA(res_replicate_3_vs_1, main="MA Plot: Replicate 3 vs Replicate 1")
dev.off()

# MA plot for Replicate 2 vs Replicate 1
res_replicate_2_vs_1 <- results(dds, name = "Replicates_2_vs_1")
pdf(file.path(output_plot, "MA_plot_replicate_2_vs_1.pdf"))
plotMA(res_replicate_2_vs_1, main="MA Plot: Replicate 2 vs Replicate 1")
dev.off()


# Perform variance stabilizing transformation (VST) for PCA
vsd <- vst(dds, blind = FALSE)

# PCA plot using both Time and Replicates
pca_data <- plotPCA(vsd, intgroup = c("Time", "Replicates"), returnData = TRUE)
percentVar <- round(100 * attr(pca_data, "percentVar"))

# Generate and save PCA plot
pdf(file.path(output_plot, "PCA_plot_time_replicates.pdf"))
ggplot(pca_data, aes(x = PC1, y = PC2, color = Time, shape = Replicates)) +
  geom_point(size = 3) +
  theme_minimal() +
  labs(title = "PCA Plot: Time and Replicates",
       x = paste0("PC1: ", percentVar[1], "% variance"),
       y = paste0("PC2: ", percentVar[2], "% variance")) +
  scale_color_manual(values = c("red", "green", "blue", "purple")) +
  scale_shape_manual(values = c(16, 17, 18)) # Different shapes for replicates
dev.off()




res_replicates_2_vs_1 <- results(dds, name = "Replicates_2_vs_1")
res_replicates_3_vs_1 <- results(dds, name = "Replicates_3_vs_1")

# Function to create a volcano plot with upregulation, downregulation, and other categories
create_volcano_plot <- function(res, title) {
  volcano_data <- as.data.frame(res)
  
  # Define significance thresholds
  log2fc_threshold <- 1  # Adjust this threshold as needed
  pval_threshold <- 0.05
  
  # Categorize genes as upregulated, downregulated, or other
  volcano_data$category <- "Not Significant"
  volcano_data$category[volcano_data$log2FoldChange >= log2fc_threshold & volcano_data$pvalue < pval_threshold] <- "Upregulated"
  volcano_data$category[volcano_data$log2FoldChange <= -log2fc_threshold & volcano_data$pvalue < pval_threshold] <- "Downregulated"
  
  # Create the plot
  ggplot(volcano_data, aes(x = log2FoldChange, y = -log10(pvalue), color = category)) +
    geom_point() +
    theme_minimal() +
    labs(title = title, x = "Log2 Fold Change", y = "-Log10 p-value") +
    scale_color_manual(values = c("Upregulated" = "red", "Downregulated" = "blue", "Not Significant" = "gray"))
}

# Generate and save volcano plots
volcano_time_8_vs_0 <- create_volcano_plot(res_time_8_vs_0, "Volcano Plot: Time 8 vs 0")
volcano_time_13_vs_0 <- create_volcano_plot(res_time_13_vs_0, "Volcano Plot: Time 13 vs 0")
volcano_time_25_vs_0 <- create_volcano_plot(res_time_25_vs_0, "Volcano Plot: Time 25 vs 0")
volcano_replicates_2_vs_1 <- create_volcano_plot(res_replicates_2_vs_1, "Volcano Plot: Replicates 2 vs 1")
volcano_replicates_3_vs_1 <- create_volcano_plot(res_replicates_3_vs_1, "Volcano Plot: Replicates 3 vs 1")

# Save plots
ggsave(file.path(output_plot, "volcano_time_8_vs_0.pdf"), volcano_time_8_vs_0)
ggsave(file.path(output_plot, "volcano_time_13_vs_0.pdf"), volcano_time_13_vs_0)
ggsave(file.path(output_plot, "volcano_time_25_vs_0.pdf"), volcano_time_25_vs_0)
ggsave(file.path(output_plot, "volcano_replicates_2_vs_1.pdf"), volcano_replicates_2_vs_1)
ggsave(file.path(output_plot, "volcano_replicates_3_vs_1.pdf"), volcano_replicates_3_vs_1)

cat("Results and plots saved successfully to", output_plot, "\n")

