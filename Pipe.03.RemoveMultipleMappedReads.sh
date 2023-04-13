#!/bin/bash
#Pipe.03.RemoveMultipleMappedReads.sh
#by HIRAO Akira

##This pipeline for handling GARS-Di data omits the pre-processes of duplication markup and BQSR

set -exuo pipefail

CURRENT_DIR=$(cd $(dirname $0) && pwd)

no_threads=32

#aji.3.1 (aji.3.1: reference genome); fasta header name = scax
code_ID="aji.3.1"

#aji.3.1.fa: the reference genoeme provided by Dr. Fujiwara @2023/2/13
reference_fa=aji.3.1.fa
reference_fa_head=aji.3.1
reference_folder=/home/$USER/work/Traja/RefGenome/RefGenome_v5.1
main_folder=/mnt/WD20/Traja/Traja_GRASDi
script_folder=$main_folder/Scripts

#samtools 1.16.1
#Using htslib 1.16.1

#gatk 4.3.0.0
#switch gatk ver.4.3.0.0
module load gatk4/4.3.0.0


while read sample; do

	work_folder=$main_folder/bwa_out/$sample
	cd $work_folder

	#unique alignment: MAPQ = 50; two alignments: MAPQ = 3, more than three alignment: MAPQ = 0
	#see detailed in http://yuifu.github.io/remove-multi-reads/ (in Japanese)
	samtools view -@ $no_threads -b -q 4 $sample.$code_ID.bam > $sample.$code_ID.filteredDup.bam
	samtools index -@ $no_threads $sample.$code_ID.filteredDup.bam

done < $script_folder/sample_ID.A0001_A0646.list  #list of MIDs


cd $CURRENT_DIR

module unload gatk4/4.3.0.0
