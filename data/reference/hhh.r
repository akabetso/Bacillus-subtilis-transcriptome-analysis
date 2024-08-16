# Set up a 2x3 grid layout for the plots
par(mfrow = c(2, 3), mar = c(4, 4, 4, 2))  # Adjust margins as needed

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

# Leave the sixth plot empty or add a legend or summary plot if desired
plot.new()
text(0.5, 0.5, "             ", cex = 1.5)
