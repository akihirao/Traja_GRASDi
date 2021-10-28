#!/bin/bash
#Pipe.03.HaplotypeCaller.sh
#by HIRAO Akira

set -exuo pipefail

SCRIPT_DIR=$(cd $(dirname $0)  && pwd)

no_thread=64

reference_folder=/home/akihirao/work/Traja/RefGenome/RefGenome_v4
main_folder=/home/akihirao/work/Traja/Traja_GRASDi


while read sample; do

	work_folder=$main_folder/bwa_out/$sample
	cd $work_folder

	gatk HaplotypeCaller\
	 -R $reference_folder/agi.2.0.fa\
	 -I $sample.agi.2.0.filteredDup.bam\
	 --emit-ref-confidence GVCF\
	 --bam-output $sample.agi.2.0.hard.filtered.hpcall.bam\
	 --native-pair-hmm-threads $no_thread\
	 -O $sample.agi.2.0.hard.filtered.g.vcf.gz

done < $SCRIPT_DIR/sample_ID.A0001_A0576.list #list of MIDs
#done < $SCRIPT_DIR/sample_ID.A0001_A0646.list  #list of MIDs


cd $SCRIPT_DIR
