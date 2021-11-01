#!/bin/bash
#Check.MappedReads.flagstats.sh
#by HIRAO Akira


set -exuo pipefail

SCRIPT_DIR=$(cd $(dirname $0) && pwd)

no_thread=64

reference_folder=/home/akihirao/work/Traja/RefGenome/RefGenome_v4
main_folder=/home/akihirao/work/Traja/Traja_GRASDi

#samtools 1.12-12-g38139f7
#Using htslib 1.12-10-gc3ba302
#gatk 4.2.0.0

echo -n >| CheckOutMappedReads.raw.bam.txt
echo -n >| CheckOutMappedReads.filtered.bam.txt


while read sample; do

	work_folder=$main_folder/bwa_out/$sample
	cd $work_folder

	echo $sample.agi.2.0.hard.filtered.bam >> $SCRIPT_DIR/CheckOutMappedReads.raw.bam.txt
	samtools flagstats --threads $no_thread $sample.agi.2.0.hard.filtered.bam >> $SCRIPT_DIR/CheckOutMappedReads.raw.bam.txt
	echo $sample.agi.2.0.filteredDup.bam >> $SCRIPT_DIR/CheckOutMappedReads.filtered.bam.txt
	samtools flagstats --threads $no_thread $sample.agi.2.0.filteredDup.bam >> $SCRIPT_DIR/CheckOutMappedReads.filtered.bam.txt

done < $SCRIPT_DIR/sample_ID.A0001_A0646.list	
#done < $SCRIPT_DIR/sample_ID.test.list  #list of MIDs

cd $SCRIPT_DIR

perl BamReadSummaryFromSamflagship.pl < CheckOutMappedReads.raw.bam.txt > Summary.MappedReads.raw.bam.csv

perl BamReadSummaryFromSamflagship.pl < CheckOutMappedReads.filtered.bam.txt > Summary.MappedReads.filtered.bam.csv


