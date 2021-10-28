#!/bin/bash
#Pipe.02.RemoveMultipleMappedReads.sh
#by HIRAO Akira

##This pipeline for handling GARS-Di data omits the pre-processes of duplication markup and BQSR

set -exuo pipefail

SCRIPT_DIR=$(cd $(dirname $0) && pwd)

no_thread=64

reference_folder=/home/akihirao/work/Traja/RefGenome/RefGenome_v4
main_folder=/home/akihirao/work/Traja/Traja_GRASDi


#samtools 1.12-12-g38139f7
#Using htslib 1.12-10-gc3ba302
#gatk 4.2.0.0


while read sample; do

	work_folder=$main_folder/bwa_out/$sample
	cd $work_folder

	#unique alignment: MAPQ = 50; two alignments: MAPQ = 3, more than three alignment: MAPQ = 0
	#see detailed in http://yuifu.github.io/remove-multi-reads/ (in Japanese)
	samtools view -@ $no_thread -b -q 4 $sample.agi.2.0.hard.filtered.bam > $sample.agi.2.0.filteredDup.bam
	samtools index -@ $no_thread $sample.agi.2.0.filteredDup.bam

done < $SCRIPT_DIR/sample_ID.A0001_A0646.list  #list of MIDs
#done < $SCRIPT_DIR/sample_ID.test.list

cd $SCRIPT_DIR

