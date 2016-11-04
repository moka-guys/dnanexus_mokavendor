#!/bin/bash

# The following line causes bash to exit at any point if there is any error
# and to output each line as it is executed -- useful for debugging
set -e -x -o pipefail

# Calculate 90% of memory size, for java
mem_in_mb=`head -n1 /proc/meminfo | awk '{print int($2*0.9/1024)}'`
java="java -Xmx${mem_in_mb}m"

#
# Fetch mappings
#
name=`dx describe "${sorted_bam}" --name`
name="${name%.bam}"
#dx download "$sorted_bam" -o input.bam
dx download "$sorted_bam" -o "$name.bam"

#
# Fetch / reconstruct genome, and optionally index it
#
genome=`reconstruct-human-genome.sh "$name.bam"`
if [ ! -e genome.fa.fai ]; then
  samtools faidx genome.fa
fi

#
# Fetch and prepare regions
#
appdata=project-B6JG85Z2J35vb6Z7pQ9Q02j8
targets=${vendor_exome}_${genome}_targets
dx download "$appdata:/vendor_exomes/$targets.bed" 
samtools view -H "$name.bam" | grep '^@SQ' > $targets.picard
awk '{print $1 "\t" $2+1 "\t" $3 "\t+\t" $1 ":" $2+1 "-" $3}' < $targets.bed >> $targets.picard

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

file_id=`dx upload hsmetrics.tsv -o "$name.hsmetrics.tsv" --brief`
dx-jobutil-add-output "hsmetrics_tsv" "$file_id"
file_id=`dx upload pertarget_coverage.tsv -o "$name.pertarget_coverage.tsv" --brief`
dx-jobutil-add-output "pertarget_coverage_tsv" "$file_id"
