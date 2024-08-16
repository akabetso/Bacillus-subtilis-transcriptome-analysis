output_plot <- "../results/featureCounts"

# Set up a 2x3 grid layout for the plots
par(mfrow = c(2, 3), mar = c(4, 4, 4, 2)) 

# Open a PDF device and output the plots
pdf(file.path(output_plot, "MA_plots_combined.pdf"), width = 14, height = 8)

# Plot 1: Time 25 vs Time 0
res_time_25_vs_0 <- results(dds, name = "Time_25_vs_0")
plotMA(res_time_25_vs_0, main = "Time 25 vs Time 0", ylim = c(-5, 5))

# Plot 2: Time 13 vs Time 0
res_time_13_vs_0 <- results(dds, name = "Time_13_vs_0")
plotMA(res_time_13_vs_0, main = "Time 13 vs Time 0", ylim = c(-5, 5))

# Plot 3: Time 8 vs Time 0
res_time_8_vs_0 <- results(dds, name = "Time_8_vs_0")
plotMA(res_time_8_vs_0, main = "Time 8 vs Time 0", ylim = c(-5, 5))

# Plot 4: Replicate 3 vs Replicate 1
res_replicate_3_vs_1 <- results(dds, name = "Replicates_3_vs_1")
plotMA(res_replicate_3_vs_1, main = "Replicate 3 vs Replicate 1", ylim = c(-5, 5))

# Plot 5: Replicate 2 vs Replicate 1
res_replicate_2_vs_1 <- results(dds, name = "Replicates_2_vs_1")
plotMA(res_replicate_2_vs_1, main = "Replicate 2 vs Replicate 1", ylim = c(-5, 5))
dev.off()
