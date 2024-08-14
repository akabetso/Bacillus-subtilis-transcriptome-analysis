#Clean extract only the required column to match that of metadata as requested by deseq2

# Directories
LOG_DIR="../logs"
echo "cleaning counts..."
awk '{print $1"\t"$7"\t"$8}' $LOG_DIR/featureCounts.txt > $LOG_DIR/cleaned_fcounts.txt 2>&1
sed -i '1d' $LOG_DIR/cleaned_fcounts.txt
echo "completed"
