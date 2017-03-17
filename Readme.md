# Vendor Human Exome Selection Metrics v1.1.1

## What does this app do?

This app used Picard CalculateHsMetrics to calculate mappings metrics. 

This metric assesses performance of the capture kit using the coverage across all targets in the kit.

A routine use of the output of this app is within MultiQC to perform run-wide QC.


## What data are required for this app to run?

This app requires:
* A coordinate-sorted BAM file (`*.bam`) with human mappings. 
* A BED file defining the regions designed to be captured. 
 * BED files can be found in 001_ToolsReferenceData:Data/BED.
 * BED files for custom panels are created using the MokaBED app, using a list of gene symbols or accessions.
 * BED files for WES samples can be found in the public project 'Apps Data'

The app automatically detects the reference genome (b37 or hg19) based on the BAM file header, and uses the appropriate target coordinates.


## What does this app output?

This app outputs two files:

* A hybrid selection metrics file (`*.hsmetrics.tsv`), containing general statistics about the enrichment process. Detailed information about the metrics reported in this file can be found at the following page:

http://picard.sourceforge.net/picard-metric-definitions.shtml#HsMetrics

* A per-target coverage file (`*.pertarget_coverage.tsv`), containing the GC content and average coverage of each target in the kit.

There is no particular rule of thumb regarding interpretation of these metrics. We encourage you to have a look at the following notes, published by the Broad Institute (slides 9 through 13, "Interpreting HS Metrics"), for some helpful tips:

http://www.broadinstitute.org/files/shared/mpg/nextgen2010/nextgen_cibulskis.pdf

## How does this app work?

This app runs CalculateHsMetrics from the Picard suite of tools. For more information, consult the manual at:

http://picard.sourceforge.net/command-line-overview.shtml#CalculateHsMetrics

NOTE: This app only uses the coordinates of enrichment targets, and provides those to Picard as both the "targets" and the "baits" inputs. As a result, certain statistics in the output (designed for the cases where baits do not equal targets) may be less informative; for example, the "BAIT_DESIGN_EFFICIENCY" will always be "1.0".


## Modifications
The output are saved in a sub folder called QC/
