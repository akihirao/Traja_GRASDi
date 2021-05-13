#!/bin/bash
#Pipe.02.RemoveMultipleMappedReads.sh
#by HIRAO Akira

##This pipeline for handling GARS-Di data omits the pre-processes of duplication markup and BQSR

set -exuo pipefail

SCRIPT_DIR=$(cd $(dirname $0) && pwd)

no_thread=16

reference_folder=/home/akihirao/work/Traja/RefGenome/RefGenome_v1
main_folder=/home/akihirao/work/Traja/Traja_GRASDi

#samtools 1.12-12-g38139f7
#Using htslib 1.12-10-gc3ba302
#gatk 4.2.0.0


#Checking for gatk reference index (*.dict)
if [ ! -e $reference_folder/agi1.dict ]; then
	gatk CreateSequenceDictionary -R $reference_folder/agi1.fa -O $reference_folder/agi1.dict
fi


while read sample; do

	work_folder=$main_folder/bwa_out/$sample
	cd $work_folder

	#unique alignment: MAPQ = 50; two alignments: MAPQ = 3, more than three alignment: MAPQ = 0
	#see detailed in http://yuifu.github.io/remove-multi-reads/ (in Japanese)
	samtools view -@ $no_thread -b -q 4 $sample.agi1.bam > $sample.agi1.filtered.bam
	samtools index -@ $no_thread $sample.agi1.filtered.bam

done < $SCRIPT_DIR/sample_ID.test.list  #list of MIDs
#done < $SCRIPT_DIR/sample_ID.list  #list of MIDs

cd $SCRIPT_DIR

