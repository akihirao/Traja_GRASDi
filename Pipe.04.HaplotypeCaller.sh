#!/bin/bash
#Pipe.04.HaplotypeCaller.sh
#by HIRAO Akira

set -exuo pipefail

CURRENT_DIR=$(cd $(dirname $0)  && pwd)

no_threads=48

#input your account name
user_name=akihirao

#agi.2.0.rev2 (agi.2.0: reference genome; rev2: pair-end merge reads)
code_ID="agi.2.0.rev2"

reference_fa=agi.2.0.fa
reference_folder=/home/$user_name/work/Traja/RefGenome/RefGenome_v4
main_folder=/home/$user_name/work/Traja/Traja_GRASDi
script_folder=$main_folder/Scripts

#set path to gatk ver.4.2.0.0
gatk_folder=/home/$user_name/local/gatk-4.2.0.0


while read sample; do

	work_folder=$main_folder/bwa_out/$sample
	cd $work_folder

	$gatk_folder/gatk HaplotypeCaller\
	 -R $reference_folder/$reference_fa\
	 -I $sample.$code_ID.filteredDup.bam\
	 --emit-ref-confidence GVCF\
	 --bam-output $sample.$code_ID.hpcall.bam\
	 --native-pair-hmm-threads $no_threads\
	 -O $sample.$code_ID.g.vcf.gz

#done < $script_folder/sample_ID.A0001_A0646.list #list of MIDs
done < $script_folder/sample_ID.test.list  #list of MIDs


cd $CURRENT_DIR

