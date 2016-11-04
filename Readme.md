# Vendor Human Exome Selection Metrics

## What does this app do?

This app calculates mappings metrics for common vendor human exome kits, with Picard CalculateHsMetrics.

## What are typical use cases for this app?

If you are using off-the-shelf human exome enrichment kits by common vendors (Agilent, Illumina, and NimbleGen), and you have
mapped your sequencing reads to a human reference genome, use this app to calculate some metrics regarding the performance of
the exome kit and the coverage for each target in the kit (based on the mappings).

## What data are required for this app to run?

This app requires a coordinate-sorted BAM file (`*.bam`) with human mappings. No other file inputs are required; the app automatically
detects the reference genome (b37 or hg19) based on the BAM file header, and uses the appropriate target coordinates.

You must choose the appropriate vendor exome to run the app. The following kits are supported:

<table>
<tr><td>Identifier</td><td>Marketing Name</td><td>Vendor Catalog ID(s)</td></tr>

<tr><td>agilent_sureselect_human_all_exon_50mb</td><td>Agilent SureSelect Human All Exon 50Mb</td><td>S02972011</td></tr>
<tr><td>agilent_sureselect_human_all_exon_v1</td><td>Agilent SureSelect Human All Exon V1</td><td>S0274956</td></tr>
<tr><td>agilent_sureselect_human_all_exon_v2</td><td>Agilent SureSelect Human All Exon V2</td><td>S0293689</td></tr>
<tr><td>agilent_sureselect_human_all_exon_v4</td><td>Agilent SureSelect Human All Exon V4</td><td>S03723314</td></tr>
<tr><td>agilent_sureselect_human_all_exon_v4_plus_utrs</td><td>Agilent SureSelect Human All Exon V4+UTRs</td><td>S03723424</td></tr>
<tr><td>agilent_sureselect_human_all_exon_v5</td><td>Agilent SureSelect Human All Exon V5</td><td>S04380110</td></tr>
<tr><td>agilent_sureselect_human_all_exon_v5_plus_utrs</td><td>Agilent SureSelect Human All Exon V5+UTRs</td><td>S04380219</td></tr>
<tr><td>agilent_sureselect_human_kinome_v1</td><td>Agilent SureSelect Human Kinome V1</td><td>S0292632</td></tr>
<tr><td>haloplex_arrhythmia_ilm</td><td>HaloPlex Arrhythmia ILM</td><td>00100-1358263563</td></tr>
<tr><td>haloplex_cancer_research_panel_ilm</td><td>HaloPlex Cancer Research Panel ILM</td><td>00100-1361547029</td></tr>
<tr><td>haloplex_cardiomyopathy_ilm</td><td>HaloPlex Cardiomyopathy ILM</td><td>00100-1358242663</td></tr>
<tr><td>haloplex_chromosome_x_ilm</td><td>HaloPlex Chromosome-X ILM</td><td>00100-1358242818</td></tr>
<tr><td>haloplex_connective_tissue_disorder_ilm</td><td>HaloPlex Connective Tissue Disorder ILM</td><td>00100-1358243605</td></tr>
<tr><td>haloplex_exome</td><td>HaloPlex Exome</td><td>00100-1360592460</td></tr>
<tr><td>haloplex_iccg_ilm</td><td>HaloPlex ICCG ILM</td><td>00100-1358263628</td></tr>
<tr><td>haloplex_noonan_syndrome_ilm</td><td>HaloPlex Noonan Syndrome ILM</td><td>00100-1358243073</td></tr>
<tr><td>illumina_nextera_exome</td><td>Illumina Nextera Exome Enrichment Kit</td><td>FC-121-1204, FC-121-1208</td></tr>
<tr><td>illumina_nextera_rapid_capture_exome</td><td>Illumina Nextera Rapid Capture Exome</td><td>FC-140-1001, FC-140-1002, FC-140-1003</td></tr>
<tr><td>illumina_nextera_rapid_capture_expanded_exome</td><td>Illumina Nextera Rapid Capture Expanded Exome</td><td>FC-140-1004, FC-140-1005, FC-140-1006</td></tr>
<tr><td>illumina_truseq_exome</td><td>Illumina TruSeq Exome Enrichment Kit</td><td>FC-121-1008, FC-121-1024, FC-121-1048, FC-121-1096, FC-121-1192, FC-121-1480, FC-121-1960</td></tr>
<tr><td>nimblegen_seqcap_ez_50mb_human_utr_design</td><td>NimbleGen SeqCap EZ Designs: 50Mb Human UTR Design</td><td>4000007100</td></tr>
<tr><td>nimblegen_seqcap_ez_comprehensive_cancer_design</td><td>NimbleGen SeqCap EZ Designs: Comprehensive Cancer Design</td><td>4000007080</td></tr>
<tr><td>nimblegen_seqcap_ez_exome_utr</td><td>NimbleGen SeqCap EZ Exome +UTR</td><td>06740294001, 06740308001</td></tr>
<tr><td>nimblegen_seqcap_ez_exome_v2</td><td>NimbleGen SeqCap EZ Exome v2.0</td><td>05860482001, 05860504001</td></tr>
<tr><td>nimblegen_seqcap_ez_exome_v3</td><td>NimbleGen SeqCap EZ Exome v3.0</td><td>06465684001, 06465692001</td></tr>
<tr><td>nimblegen_seqcap_ez_neurology_panel_design</td><td>NimbleGen SeqCap EZ Designs: Neurology Panel Design</td><td>4000007090</td></tr>
</table>

## What does this app output?

This app outputs two files:

* A hybrid selection metrics file (`*.hsmetrics.tsv`), containing general statistics about the enrichment process. Detailed information about the
metrics reported in this file can be found at the following page:

http://picard.sourceforge.net/picard-metric-definitions.shtml#HsMetrics

* A per-target coverage file (`*.pertarget_coverage.tsv`), containing the GC content and average coverage of each target in the kit.

There is no particular rule of thumb regarding interpretation of these metrics. We encourage you to have a look at the following notes, published
by the Broad Institute (slides 9 through 13, "Interpreting HS Metrics"), for some helpful tips:

http://www.broadinstitute.org/files/shared/mpg/nextgen2010/nextgen_cibulskis.pdf

## How does this app work?

This app runs CalculateHsMetrics from the Picard suite of tools. For more information, consult the manual at:

http://picard.sourceforge.net/command-line-overview.shtml#CalculateHsMetrics

NOTE: This app only uses the coordinates of enrichment targets, and provides those to Picard as both the "targets" and the
"baits" inputs. As a result, certain statistics in the output (designed for the cases where baits do not equal targets) may be
less informative; for example, the "BAIT_DESIGN_EFFICIENCY" will always be "1.0".
