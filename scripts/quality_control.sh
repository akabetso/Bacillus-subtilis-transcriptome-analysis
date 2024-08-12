#!/bin/bash
# A script to perform quality control on RNA-Seq data using FastQC and FastQ Screen

source /home/akabetso/miniconda3/bin/activate myenv

# Directories
DATA_DIR="../data"
RESULTS_DIR="../results/fastq"
LOG_DIR="../logs"

# Create results and log directories if they don't exist
mkdir -p $RESULTS_DIR
mkdir -p $LOG_DIR

# Run FastQC
echo "Running FastQC, first read forward read..."
fastqc --outdir RESULTS_DIR $DATA_DIR/fastq/Bacillus_infection_T0_R1.fq.gz > $LOG_DIR/fastqc.log 2>&1
echo "Running FastQC, first read reverse read..."
fastqc --outdir RESULTS_DIR $DATA_DIR/fastq/Bacillus_infection_T0_R2.fq.gz >> $LOG_DIR/fastqc.log 2>&1
echo "Running FastQC, secong read forward read..."
fastqc --outdir RESULTS_DIR $DATA_DIR/fastq/Bacillus_infection_T10_R1.fq.gz >> $LOG_DIR/fastqc.log 2>&1 
echo "Running FastQC, second read reverse read..."
fastqc --outdir RESULTS_DIR $DATA_DIR/fastq/Bacillus_infection_T10_R2.fq.gz >> $LOG_DIR/fastqc.log 2>&1

RESULTS_DIR="../results/fastq_screen"
# Run FastQ Screen
echo "Running FastQ Screen..."
fastq_screen --outdir RESULTS_DIR --conf ../data/reference/fastq_screen.conf --force $DATA_DIR/fastq/Bacillus_infection_T0_R1.fq.gz $DATA_DIR/fastq/Bacillus_infection_T0_R2.fq.gz $DATA_DIR/fastq/Bacillus_infection_T10_R1.fq.gz $DATA_DIR/fastq/Bacillus_infection_T10_R2.fq.gz > $LOG_DIR/fastq_screen.log 2>&1 


echo "Quality control complete. Check $RESULTS_DIR for output files and $LOG_DIR for logs."
