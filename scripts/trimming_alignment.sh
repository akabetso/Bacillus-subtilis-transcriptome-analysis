# Directories
DATA_DIR="../data"
RESULTS_DIR="../results"
LOG_DIR="../logs"

mkdir -p $RESULTS_DIR/cutadapt
mkdir -p $DATA_DIR/reference/index
mkdir -p $RESULTS_DIR/alignment

echo "Trimming T0 reads with cutdapt..."
cutadapt -u 8 -U 8 -q 33,33 --trim-n -m 20 -o $RESULTS_DIR/cutadapt/Bacillus_infection_T0_R1_trimmed.fq.gz -p $RESULTS_DIR/cutadapt/Bacillus_infection_T0_R2_trimmed.fq.gz $DATA_DIR/fastq/Bacillus_infection_T0_R1.fq.gz $DATA_DIR/fastq/Bacillus_infection_T0_R2.fq.gz > $LOG_DIR/trimmed.log 2>&1
echo "Trimming T10 reads with cutdapt..."
cutadapt -u 8 -U 8 -q 33,33 --trim-n -m 20 -o $RESULTS_DIR/cutadapt/Bacillus_infection_T10_R1_trimmed.fq.gz -p $RESULTS_DIR/cutadapt/Bacillus_infection_T10_R2_trimmed.fq.gz $DATA_DIR/fastq/Bacillus_infection_T10_R1.fq.gz $DATA_DIR/fastq/Bacillus_infection_T10_R2.fq.gz >> $LOG_DIR/trimmed.log 2>&1

echo "Trimming completed. Check $RESULTS_DIR for output files and $LOG_DIR for logs."

echo "Lunching alignment, bowtie2 algorithm chosen for short reads suitability..."

echo "Indexing the fasta..."
bowtie2-build $DATA_DIR/reference/YB886.fa $DATA_DIR/reference/index/YB886 > $LOG_DIR/indexed.log 2>&1
echo "Indexing completed."

echo "Mapping the reads at To..."
bowtie2 --very-sensitive --maxins 1000 -x $DATA_DIR/reference/index/YB886 -1 $RESULTS_DIR/cutadapt/Bacillus_infection_T0_R1_trimmed.fq.gz -2 $RESULTS_DIR/cutadapt/Bacillus_infection_T0_R2_trimmed.fq.gz -S $RESULTS_DIR/alignment/T0.sam > $LOG_DIR/aligned.log 2>&1

echo "Mapping the reads at T10..."
bowtie2 --very-sensitive --maxins 1000 -x $DATA_DIR/reference/index/YB886 -1 $RESULTS_DIR/cutadapt/Bacillus_infection_T10_R1_trimmed.fq.gz -2 $RESULTS_DIR/cutadapt/Bacillus_infection_T10_R2_trimmed.fq.gz -S $RESULTS_DIR/alignment/T10.sam >> $LOG_DIR/aligned.log 2>&1
echo "Mapping completed."
