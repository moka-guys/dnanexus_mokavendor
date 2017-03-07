#!/bin/bash

# The following line causes bash to exit at any point if there is any error
# and to output each line as it is executed -- useful for debugging
set -e -x -o pipefail

# Calculate 90% of memory size, for java
mem_in_mb=`head -n1 /proc/meminfo | awk '{print int($2*0.9/1024)}'`
java="java -Xmx${mem_in_mb}m"


#get the filename
name=`dx describe "${sorted_bam}" --name`
#remove .bam
name="${name%.bam}"

# download input bam and bed files
dx download "$sorted_bam" -o "$name.bam"
dx download "$vendor_exome_bedfile"

#give .sh script permissions to run
chmod +x /usr/bin/reconstruct-human-genome.sh 
# Fetch / reconstruct genome, and optionally index it
genome=`reconstruct-human-genome.sh "$name.bam"`
if [ ! -e genome.fa.fai ]; then
  samtools faidx genome.fa
fi

# Fetch and prepare regions
#appdata=project-B6JG85Z2J35vb6Z7pQ9Q02j8
targets=${vendor_exome_bedfile_prefix}_${genome}_targets
#dx download "$appdata:/vendor_exomes/$targets.bed" 


samtools view -H "$name.bam" | grep '^@SQ' > $targets.picard

#recreate the vendor bedfile format from mokabed files
cat $vendor_exome_bedfile_prefix.bed | grep -v '^#' | sed 's/chr//' | awk -F '\t' '{print $1,$2,$3}' >  tidied.bed

awk '{print $1 "\t" $2+1 "\t" $3 "\t+\t" $1 ":" $2+1 "-" $3}' < tidied.bed >> $targets.picard

#head tidied.bed
#head $vendor_exome_bedfile_prefix.bed
#head $targets.picard -n 100

#
# Run Picard CalculateHsMetrics
#
opts="VALIDATION_STRINGENCY=$validation_stringency"
if [ "$advanced_options" != "" ]; then
  opts="$advanced_options"
fi
$java -jar /CalculateHsMetrics.jar BI=$targets.picard TI=$targets.picard I="$name.bam" O=hsmetrics.tsv R=genome.fa PER_TARGET_COVERAGE=pertarget_coverage.tsv $opts

#
# Upload results
#
name=`dx describe "${sorted_bam}" --name`
name="${name%.bam}"

# made folders for output
mkdir -p ~/out/hsmetrics_tsv/QC/ ~/out/pertarget_coverage_tsv/QC/ ~/out/bedfile/


#move results to folders for dx upload all outputs
mv hsmetrics.tsv ~/out/hsmetrics_tsv/QC/"$name.hsmetrics.tsv"
mv pertarget_coverage.tsv ~/out/pertarget_coverage_tsv/QC/"$name.pertarget_coverage.tsv"
#mv $vendor_exome_bedfile_prefix.bed ~/out/bedfile/$vendor_exome_bedfile_prefix.bed 

dx-upload-all-outputs --parallel

