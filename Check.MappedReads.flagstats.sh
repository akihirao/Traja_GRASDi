#!/bin/bash
#Check.MappedReads.flagstats.sh
#by HIRAO Akira


set -exuo pipefail

SCRIPT_DIR=$(cd $(dirname $0) && pwd)

no_thread=64

reference_folder=/home/akihirao/work/Traja/RefGenome/RefGenome_v2
main_folder=/home/akihirao/work/Traja/Traja_GRASDi

#samtools 1.12-12-g38139f7
#Using htslib 1.12-10-gc3ba302
#gatk 4.2.0.0

echo -n >| CheckOutMappedReads.raw.bam.txt
echo -n >| CheckOutMappedReads.filtered.bam.txt


while read sample; do

	work_folder=$main_folder/bwa_out/$sample
	cd $work_folder

	echo $sample.agi1.2.bam >> $SCRIPT_DIR/CheckOutMappedReads.raw.bam.txt
	samtools flagstats --threads $no_thread $sample.agi1.2.bam >> $SCRIPT_DIR/CheckOutMappedReads.raw.bam.txt
	echo $sample.agi1.2.filtered.bam >> $SCRIPT_DIR/CheckOutMappedReads.filtered.bam.txt
	samtools flagstats --threads $no_thread $sample.agi1.2.filtered.bam >> $SCRIPT_DIR/CheckOutMappedReads.filtered.bam.txt

done < $SCRIPT_DIR/sample_ID.2nd.list  #list of MIDs

cd $SCRIPT_DIR

