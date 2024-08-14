#Description: run prokka on reference genome. This will annotate the Bacillus subtilis genes and their expression levels in response to phage infection, will help to identify which genes are being expressed in RNA-seq data and allow for differencial expression analysis accross different point. Equally run prokka on phage genome for the same reasons.

#Directories
DATA_DIR="../data"
RESULTS_DIR="../results"
LOG_DIR="../logs"

mkdir -p $RESULTS_DIR/bacillus_annotation
mkdir -p $RESULTS_DIR/phage_annotation
mkdir -p $RESULTS_DIR/featureCounts


echo "Bacillus genome annotation..."
prokka --outdir $RESULTS_DIR/bacillus_annotation --prefix YB886 --force $DATA_DIR/reference/YB886.fa > $LOG_DIR/bacillus_annotaton.log 2>&1
echo "Phage genome annotation..."
prokka --outdir $RESULTS_DIR/phage_annotation --prefix SPP1 --force $DATA_DIR/reference/SPP1.fa > $LOG_DIR/phage_annotation.log 2>&1
echo "End of annotation"

#featureCounts: The first step for a differential gene expression analysis is to count the numbers of reads/fragments mapping on a gene. the genome annotation performed above provides genes positions needed for this process.

echo "Computing genes counts..."
featureCounts \
    -p \
    -O \
    -s 1 \
    -t CDS \
    --ignoreDup \
    -T 1 \
    -G $DATA_DIR/reference/YB886.fa \
    -a $RESULTS_DIR/bacillus_annotation/YB886.gff \
    -g ID \
    -o $RESULTS_DIR/featureCounts/tmp_counts.txt \
    $RESULTS_DIR/alignment/T0_sorted.bam $RESULTS_DIR/alignment/T10_sorted.bam > $LOG_DIR/featureCounts.log 2>&1
# The following commands are just making a nicer table header.
FILE_PATH=$RESULTS_DIR/alignment/
sed -i "s|$FILE_PATH||g" $RESULTS_DIR/featureCounts/tmp_counts.txt
sed 's/_sorted.bam//g' $RESULTS_DIR/featureCounts/tmp_counts.txt > $LOG_DIR/featureCounts.txt 2>&1
rm $RESULTS_DIR/featureCounts/tmp_counts.txt
echo "End of computing genes counts."

