#!/bin/bash
#Tratra.02.RemoveMultipleMappedReads.sh
#by HIRAO Akira

##This pipeline for handling Tratra WG data omits the pre-processes of duplication markup and BQSR

set -exuo pipefail

SCRIPT_DIR=$(cd $(dirname $0) && pwd)

no_thread=128

reference_folder=/home/akihirao/work/Traja/RefGenome/RefGenome_v3
main_folder=/home/akihirao/work/Traja/Tratra

#samtools 1.12-12-g38139f7
#Using htslib 1.12-10-gc3ba302
#gatk 4.2.0.0


#Checking for gatk reference index (*.dict)
if [ ! -e $reference_folder/agi1.2.dict ]; then
	gatk CreateSequenceDictionary -R $reference_folder/agi1.2.fa -O $reference_folder/agi1.2.dict
fi


cd $main_folder

#unique alignment: MAPQ = 50; two alignments: MAPQ = 3, more than three alignment: MAPQ = 0
#see detailed in http://yuifu.github.io/remove-multi-reads/ (in Japanese)
samtools view -@ $no_thread -b -q 4 Tratra.WG.bam > Tratra.WG.filtered.bam
samtools index -@ $no_thread Tratra.WG.filtered.bam

cd $SCRIPT_DIR