#!/bin/bash
#Pipe.03.RemoveMultipleMappedReads.sh
#by HIRAO Akira

##This pipeline for handling GARS-Di data omits the pre-processes of duplication markup and BQSR

set -exuo pipefail

CURRENT_DIR=$(cd $(dirname $0) && pwd)

no_threads=48


#agi.2.0.rev2 (agi.2.0: reference genome; rev2: pair-end merge reads)
code_ID="agi.2.0.rev2"

reference_fa=agi.2.0.fa
reference_folder=/home/$USER/work/Traja/RefGenome/RefGenome_v4
main_folder=/home/$USER/work/Traja/Traja_GRASDi
script_folder=$main_folder/Scripts

#samtools 1.12-12-g38139f7
#Using htslib 1.12-10-gc3ba302
#gatk 4.2.0.0

#set path to gatk ver.4.2.0.0
gatk_folder=/home/$USER/local/gatk-4.2.0.0


while read sample; do

	work_folder=$main_folder/bwa_out/$sample
	cd $work_folder

	#unique alignment: MAPQ = 50; two alignments: MAPQ = 3, more than three alignment: MAPQ = 0
	#see detailed in http://yuifu.github.io/remove-multi-reads/ (in Japanese)
	samtools view -@ $no_threads -b -q 4 $sample.$code_ID.bam > $sample.$code_ID.filteredDup.bam
	samtools index -@ $no_threads $sample.$code_ID.filteredDup.bam

done < $script_folder/sample_ID.A0001_A0646.list  #list of MIDs


cd $CURRENT_DIR

