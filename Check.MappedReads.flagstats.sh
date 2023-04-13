#!/bin/bash
#Check.MappedReads.flagstats.sh
#by HIRAO Akira


set -exuo pipefail

CURRENT_DIR=$(cd $(dirname $0) && pwd)

no_threads=24

#aji.3.0 (aji.3.0: reference genome) 
code_ID="aji.3.0"

#aji.3.0.fa: the reference genoeme provided by Dr. Fujiwara @2023/2/13
reference_fa=aji.3.0.fa
reference_fa_head=aji.3.0
reference_folder=/home/$USER/work/Traja/RefGenome/RefGenome_v5
main_folder=/mnt/WD20/Traja/Traja_GRASDi
script_folder=$main_folder/Scripts


#bwa (Version: 0.7.17-r1198-dirty)
#bwa-mem2 v2.2.1
#samtools 1.16.1
#Using htslib 1.16.1

echo -n >| $script_folder/CheckOutMappedReads.raw.bam.txt
echo -n >| $script_folder/CheckOutMappedReads.filtered.bam.txt


while read sample; do

	work_folder=$main_folder/bwa_out/$sample
	cd $work_folder

	echo $sample.$code_ID.bam >> $script_folder/CheckOutMappedReads.raw.bam.txt
	samtools flagstats --threads $no_threads $sample.$code_ID.bam >> $script_folder/CheckOutMappedReads.raw.bam.txt
	echo $sample.$code_ID.filteredDup.bam >> $script_folder/CheckOutMappedReads.filtered.bam.txt
	samtools flagstats --threads $no_threads $sample.$code_ID.filteredDup.bam >> $script_folder/CheckOutMappedReads.filtered.bam.txt

done < $script_folder/sample_ID.A0001_A0646.list	


cd $script_folder

perl BamReadSummaryFromSamflagship.pl < CheckOutMappedReads.raw.bam.txt > Summary.MappedReads.raw.bam.csv

perl BamReadSummaryFromSamflagship.pl < CheckOutMappedReads.filtered.bam.txt > Summary.MappedReads.filtered.bam.csv

cd $CURRENT_DIR

