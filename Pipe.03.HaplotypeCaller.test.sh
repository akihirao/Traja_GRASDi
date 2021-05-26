#!/bin/bash
#Pipe.03.HaplotypeCaller.sh
#by HIRAO Akira

set -exuo pipefail

SCRIPT_DIR=$(cd $(dirname $0)  && pwd)

no_thread=64

reference_folder=/home/akihirao/work/Traja/RefGenome/RefGenome_v2
main_folder=/home/akihirao/work/Traja/Traja_GRASDi


while read sample; do

	work_folder=$main_folder/bwa_out/$sample
	cd $work_folder

	gatk HaplotypeCaller\
	 -R $reference_folder/agi1.2.fa\
	 -I $sample.agi1.2.filtered.bam\
	 --emit-ref-confidence GVCF\
	 --bam-output $sample.agi1.2.hpcall.bam\
	 --native-pair-hmm-threads $no_thread\
	 -O $sample.agi1.2.g.vcf.gz

done < $SCRIPT_DIR/sample_ID.test.remain.list  #list of MIDs
#done < $SCRIPT_DIR/sample_ID.list  #list of MIDs

cd $SCRIPT_DIR
