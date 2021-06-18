#!/bin/bash
#Pipe.03.HaplotypeCaller.single.A0454_A0500_plus_A0591_A0646.sh
#by HIRAO Akira

set -exuo pipefail

SCRIPT_DIR=$(cd $(dirname $0)  && pwd)

no_thread=128

reference_folder=/home/akihirao/work/Traja/RefGenome/RefGenome_v2
main_folder=/home/akihirao/work/Traja/Traja_GRASDi


while read sample; do

	work_folder=$main_folder/bwa_out/$sample
	cd $work_folder

	gatk HaplotypeCaller\
	 -R $reference_folder/agi1.2.fa\
	 -I $sample.agi1.2.filtered.bam\
	 --native-pair-hmm-threads $no_thread\
	 -O $sample.agi1.2.single.vcf.gz 

done < $SCRIPT_DIR/sample_ID.A0454_A0500_plus_A0591_A0646.list  #list of MIDs
#done < $SCRIPT_DIR/sample_ID.list  #list of MIDs

cd $SCRIPT_DIR