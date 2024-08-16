# Bacillus subtilis Contamination by Phage SPP1 differential gene analysis

Data and workflow of this work was obtain and reproduced with the permision of Amaury Bignaud : https://github.com/ABignaud/Transcriptomics_SupBioTech_2023/tree/main

For the analysis we will use data from Bacillus subtilis culture infected by its phage SPP1 RNA-seq libraries. The reads are subsampled to accelerate the quality check. The reference genome from this library is the YB886 strain from Bacillus subtilis and its phage SPP1.

Workflow:

- **Assessing sequencing quality**: Assess sequencing data quality to detect problems before analysis. Crucial for accurate results, can help fix issues. Using scripting but direct  terminal tools are possible.
	- **tools**:
		- fastqc is mostly used to control the quality of high throughput sequence data like degradation quality over the duration of long runs or simply observing GC content indicating problems with the library like specific contaminant or as well cross-checking over-sequencing vs technical erros for acurate results..

		- fastqscreen checks the content of your sequence data. It verifies that your sequences are from the expected organism and not contaminated, this process is different from checking the quality of the sequence themselves.

		- multiqc can be used to make a nice report.

- **Sequence alignment**: Here, the goal is to align sequences or reads on reference genome to generate alignment tracks and to visualize transcription or transcribe genes.
	- **tools**:
		- cutadapt for trimming contaminated bases. Here, the fastqc report presented some adaptors sequences at the begining reads, so we trimmed 8bp.

		- samtools for processing and visualising the output file of our allign reads.

		- bowtie2 for aligning the reads on the reference genome. output to sam file. generally, it's advised to used local alignment mode alowing the edged of reads not to be mapped by the aligner because the RNA-seq generally have some splicing which will introduce issue with the alignment. This isn't true with bacteria so we used end-to-end mode.

		- deeptools for generating the transcription tracks. output bam files which will later be sorted. We further visualize bamcoverage files with IGV, in our case, there is no uniformity which is okay since it's rna-seq and not DNA coverage. We equally observed stranded files with 2-3% of antisens reads.  

- **Differential Gene Expression analysis**: Analyze RNA-seq data to compare gene expression across different time points(0, 8, 13, 25) of a bacterial infection. 

	- **Computing gene counts**: count reads mapping to genes, we need precise gene locations. We ran prokka on the Bacillus subtilis strain fasta file to annotate its genome.we used the .gff output file. The gff file contains gene information like gene ID, framework, starting and ending points, CDS ...

	- **Running feature counts**: Finally we count the reads mapping to genomic features. The featureCounts outputed in .txt format containing gene id, framework, strands, starting and ending points and most importantly the samples which represents the reads counts in each sample or condition.

	- **Gene expression**: We used the gene counts table and metadata or library description file to parse on to DESeq2. DESeq2 stores and manipulate count data for differential gene expression analysis. We factored our experimental design to consider different level of the samples.

		- histograms (p-value|adjusted p-value): the p-value shows that there are no significant difference between genes with high p-value. Howerver we observe a significant difference between the low p-value genes and the hight p-value genes. the adjusted p-value on the other hand shows only a small subset of genes remain significant after adjusted p-values with a peak at 0.05. but this is a normal step to prevent false positive ensuring that the portion of significant genes identified are truly significant.

		- Dispersion plot represents the average expression level  of genes across samples after normalisation with highly expressed genes on the right and lowly expressed genes to the left in the x-axis and variability in genes across replicates in the y-axis, lower dispersion suggest more consistency. In our case, the fited redline and blue estimates indicates that the model is effectively stabilizing variance especially for genes with low counts.This stabilization of variance is critical for the accurate identification of differentially expressed genes, ensuring that our findings are robust and reliable. 

		- PCA plot reduces the dimensionality of our dataset for easier representation. It shows that there is less variance between replicates and more variance between the different time points.This is somewhat reasuring because we will see actual differnce in our samples and that the phage infection is impacting the bacterial. 

		- MA plot or mean average plot is presented accross the replicates and time points. with the mean average count un the x-axis and logfold change on the y-axis between two experiments. The p-value depending on the variance between two conditions determines the significant genes. thus high p-value or insignificant dots|genes can be due to either no variance between two conditions or a high variance inside one condition if the replicates are perfect. basically there shouldn't be any overlap between blue|grey dots. Replicates seems ok for both conditons as there are no huge overlap between significant|insignificant dots.

		- Volcano plot represents fold change depending on the p-value. It seperates differentially expressed genes from the others. We observed the log fold change and the variation of the log fold change. Here we plot volcano accross replicates and different time points. Will modify the plot later on to show more large fold change but not significant, generally this represents noise. Equally show significant but small fold change and significant and huge fold change. Presently we observe genes deferentially expressed accross time points but zero genes diffentially expressed accross replicates.

		- The gene expression results are saved in [featureCounts](https://github.com/akabetso/E-Coli-transcriptome-analysis/tree/master/results/featureCounts).

## Conclusion on Bacillus subtilis Contamination by Phage SPP1

Our analysis aimed to identify the impact of **Phage SPP1** contamination on **Bacillus subtilis** by evaluating gene expression patterns over different time points and between replicates.

### 1. PCA Analysis:
The PCA plot indicated that there is **no significant variance between replicates**. This consistency among replicates demonstrates that the experimental conditions were stable and reproducible. However, there was **significant variance between time points**, suggesting that gene expression in *Bacillus subtilis* changes notably over time in response to the phage contamination.

### 2. Volcano and MA Plots:
The **volcano plots** revealed that **no genes were differentially expressed between replicates**, further confirming the consistency seen in the PCA analysis. However, several genes were significantly differentially expressed at different time points. These time-dependent changes in gene expression suggest a dynamic response of *Bacillus subtilis* to the phage over time, potentially reflecting stages of the infection process or bacterial defense mechanisms.

The **MA plots** corroborated these findings, showing a clear difference in gene expression levels across time points but not between replicates.

### 3. Histograms:
The **histogram of p-values** showed a uniform distribution with a peak at low p-values, indicating the presence of genuinely differentially expressed genes. This is a strong indicator that some genes indeed respond to the phage contamination over time.

The **histogram of adjusted p-values** highlighted that most genes do not pass the threshold for significance after adjustment, which is expected given the conservative nature of multiple testing corrections. However, the presence of low adjusted p-values still points to a subset of genes that are significantly impacted by phage SPP1 over time.

### 4. Dispersion Plot:
The **dispersion plot** provided insight into the variability of gene expression. The trend in the dispersion values showed that genes with low expression levels had higher variability, which is typical in RNA-Seq data. The fitted and shrunk dispersion estimates demonstrate that the statistical model effectively accounts for this variability, ensuring reliable detection of differentially expressed genes.

## Overall Conclusion:
The analysis strongly indicates that **Phage SPP1** contamination leads to **significant changes in the gene expression of *Bacillus subtilis* over time**. These changes are not due to random experimental noise, as evidenced by the lack of differential expression between replicates. Instead, they reflect a biological response to phage infection, with certain genes being upregulated or downregulated at specific time points. The observed gene expression changes likely represent the bacterial defense mechanisms or the phage replication process. This finding suggests that phage SPP1 has a time-dependent impact on *Bacillus subtilis*, which could be crucial for understanding the interaction between the bacterium and its phage, as well as for developing strategies to mitigate contamination.


## What's next: 
	- Gene set enrichment analysis
	- Bibliography research to explain genes of interest
	- Mutating genes to observe impacts
