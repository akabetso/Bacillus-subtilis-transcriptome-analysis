#The sam file is quite heavy, as for the fastq it's more easier woriking with compressed files. We will at the same time filter the mapping reads, sort them and index them using samtools. The bam file is the compressed version of sam.

# Directories
DATA_DIR="../data"
RESULTS_DIR="../results"
LOG_DIR="../logs"

mkdir -p $RESULTS_DIR/tracks

echo "Processing sam files at T0"
echo "Processing sam files at T0" > $LOG_DIR/sort_filter.log 2>&1
echo "Sort and compressed the sam file..."
samtools sort -n -O BAM $RESULTS_DIR/alignment/T0.sam -o T0_tmp1.bam >> $LOG_DIR/sort_filter.log 2>&1
echo "Sorting and compression completed"
echo "Extracting only pairs with both reads mapped..."
samtools fixmate --output-fmt bam T0_tmp1.bam T0_tmp2.bam >> $LOG_DIR/sort_filter.log 2>&1
echo "Pairs with both reads mapped extraction completed"
echo "Filter reads with low mapping quality..."
samtools view --output-fmt bam -f 2 -q 30 -1 -b T0_tmp2.bam -o T0_tmp1.bam >> $LOG_DIR/sort_filter.log 2>&1
echo "Low quality mapping filtered"
echo "Sorting the resulting reads..."
samtools sort --output-fmt bam -l 9 T0_tmp1.bam -o $RESULTS_DIR/alignment/T0_sorted.bam >> $LOG_DIR/sort_filter.log 2>&1
echo "sorting completed"
echo "Indexing the reads..."
samtools index $RESULTS_DIR/alignment/T0_sorted.bam >> $LOG_DIR/sort_filter.log 2>&1
echo "Indexing completed"
echo "Removing the sam files and the temporary files..."
rm $RESULTS_DIR/alignment/T0.sam T0_tmp1.bam T0_tmp2.bam >> $LOG_DIR/sort_filter.log 2>&1
echo "process completed at T0"

echo "Processing sam files at T10"
echo "Processing sam files at T10" >> $LOG_DIR/sort_filter.log 2>&1
echo "Sort and compressed the sam file..."
samtools sort -n -O BAM $RESULTS_DIR/alignment/T10.sam -o T10_tmp1.bam >> $LOG_DIR/sort_filter.log 2>&1
echo "Sorting and compression completed"
echo "Extracting only pairs with both reads mapped..."
samtools fixmate --output-fmt bam T10_tmp1.bam T10_tmp2.bam >> $LOG_DIR/sort_filter.log 2>&1
echo "Pairs with both reads mapped extraction completed"
echo "Filter reads with low mapping quality..."
samtools view --output-fmt bam -f 2 -q 30 -1 -b T10_tmp2.bam -o T10_tmp1.bam >> $LOG_DIR/sort_filter.log 2>&1
echo "Low quality mapping filtered"
echo "Sorting the resulting reads..."
samtools sort --output-fmt bam -l 9 T10_tmp1.bam -o $RESULTS_DIR/alignment/T10_sorted.bam >> $LOG_DIR/sort_filter.log 2>&1
echo "sorting completed"
echo "Indexing the reads..."
samtools index $RESULTS_DIR/alignment/T10_sorted.bam >> $LOG_DIR/sort_filter.log 2>&1
echo "Indexing completed"
echo "Removing the sam files and the temporary files..."
rm $RESULTS_DIR/alignment/T10.sam T10_tmp1.bam T10_tmp2.bam >> $LOG_DIR/sort_filter.log 2>&1
echo "process completed at T10"



#GENERATING TRANSCRIPTION TRACKS 
echo "Generating transcription tracts at T0"
bamCoverage --bam $RESULTS_DIR/alignment/T0_sorted.bam --outFileName $RESULTS_DIR/tracks/T0_unstranded.bw --binSize 1 --normalizeUsing CPM --extendReads --ignoreDuplicates > $LOG_DIR/transcription_tracks.log 2>&1

bamCoverage --bam $RESULTS_DIR/alignment/T0_sorted.bam --outFileName $RESULTS_DIR/tracks/T0_forward.bw --binSize 1 --normalizeUsing CPM --extendReads --filterRNAstrand forward --ignoreDuplicates >> $LOG_DIR/transcription_tracks.log 2>&1

bamCoverage --bam $RESULTS_DIR/alignment/T0_sorted.bam --outFileName $RESULTS_DIR/tracks/T0_reverse.bw --binSize 1 --normalizeUsing CPM --extendReads --filterRNAstrand reverse --ignoreDuplicates >> $LOG_DIR/transcription_tracks.log 2>&1

echo "Generating transcription tracts at T10"
bamCoverage --bam $RESULTS_DIR/alignment/T10_sorted.bam --outFileName $RESULTS_DIR/tracks/T10_unstranded.bw --binSize 1 --normalizeUsing CPM --extendReads --ignoreDuplicates >> $LOG_DIR/transcription_tracks.log 2>&1

bamCoverage --bam $RESULTS_DIR/alignment/T10_sorted.bam --outFileName $RESULTS_DIR/tracks/T10_forward.bw --binSize 1 --normalizeUsing CPM --extendReads --filterRNAstrand forward --ignoreDuplicates >> $LOG_DIR/transcription_tracks.log 2>&1

bamCoverage --bam $RESULTS_DIR/alignment/T10_sorted.bam --outFileName $RESULTS_DIR/tracks/T10_reverse.bw --binSize 1 --normalizeUsing CPM --extendReads --filterRNAstrand reverse --ignoreDuplicates >> $LOG_DIR/transcription_tracks.log 2>&1
echo "Transcriptin tracks generation completed"
