#!/bin/bash
#Check.MappedReads.flagstats.sh
#by HIRAO Akira


set -exuo pipefail

CURRENT_DIR=$(cd $(dirname $0) && pwd)

no_threads=48

reference_folder=/home/akihirao/work/Traja/RefGenome/RefGenome_v4
main_folder=/home/akihirao/work/Traja/Traja_GRASDi
script_folder=$main_folder/Scripts

code_ID="agi.2.0.rev2"

#samtools 1.12-12-g38139f7
#Using htslib 1.12-10-gc3ba302
#gatk 4.2.0.0

echo -n >| $script_folder/CheckOutMappedReads.raw.bam.txt
echo -n >| $script_folder/CheckOutMappedReads.filtered.bam.txt


while read sample; do

	work_folder=$main_folder/bwa_out/$sample
	cd $work_folder

	echo $sample.$code_ID.bam >> $script_folder/CheckOutMappedReads.raw.bam.txt
	samtools flagstats --threads $no_threads $sample.$code_ID.rev2.bam >> $script_folder/CheckOutMappedReads.raw.bam.txt
	echo $sample.$code_ID.filteredDup.bam >> $script_folder/CheckOutMappedReads.filtered.bam.txt
	samtools flagstats --threads $no_threads $sample.$code_ID.rev2.filteredDup.bam >> $script_folder/CheckOutMappedReads.filtered.bam.txt

done < $script_folder/sample_ID.A0001_A0646.list	


cd $script_folder

perl BamReadSummaryFromSamflagship.pl < CheckOutMappedReads.raw.bam.txt > Summary.MappedReads.raw.bam.csv

perl BamReadSummaryFromSamflagship.pl < CheckOutMappedReads.filtered.bam.txt > Summary.MappedReads.filtered.bam.csv

cd $CURRENT_DIR

