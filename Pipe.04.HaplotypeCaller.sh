#!/bin/bash
#Pipe.04.HaplotypeCaller.sh
#by HIRAO Akira

set -exuo pipefail

SCRIPT_DIR=$(cd $(dirname $0)  && pwd)

no_threads=64

#input your account name
user_name=akihirao

reference_fa=agi.2.0.fa
reference_folder=/home/$user_name/work/Traja/RefGenome/RefGenome_v4
main_folder=/home/$user_name/work/Traja/Traja_GRASDi

#set path to gatk ver.4.2.0.0
gatk_folder=/home/$user_name/local/gatk-4.2.0.0


while read sample; do

	work_folder=$main_folder/bwa_out/$sample
	cd $work_folder

	$gatk_folder/gatk HaplotypeCaller\
	 -R $reference_folder/$reference_fa\
	 -I $sample.agi.2.0.rev1.filteredDup.bam\
	 --emit-ref-confidence GVCF\
	 --bam-output $sample.agi.2.0.rev1.hpcall.bam\
	 --native-pair-hmm-threads $no_threads\
	 -O $sample.agi.2.0.rev1.g.vcf.gz

done < $SCRIPT_DIR/sample_ID.A0001_A0646.list #list of MIDs
#done < $SCRIPT_DIR/sample_ID.test.list  #list of MIDs


cd $SCRIPT_DIR

