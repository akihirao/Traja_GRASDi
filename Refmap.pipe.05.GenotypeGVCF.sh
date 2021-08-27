#!/bin/bash
#Refmap.pipe.05.GenotypeGVCF.sh
#by HIRAO Akira

set -exuo pipefail

SCRIPT_DIR=$(cd $(dirname $0)  && pwd)

no_thread=64

reference_folder=/home/akihirao/work/Traja/RefGenome/RefGenome_v4
main_folder=/home/akihirao/work/Traja/Traja_GRASDi
work_folder=/home/akihirao/work/Traja/Traja_GRASDi/stacks_work

target_ID=Traja_GRASDi_2nd_ref2
output_folder=$work_folder/vcf_out_gatk
lab_under_bar="_"
mkdir -p $output_folder



cd $work_folder/gDB


while read chr; do

	genomicsDB_name=genomicsDB.$target_ID$lab_under_bar$chr

	gatk GenotypeGVCFs\
	 -R $reference_folder/agi.2.0.fa -V gendb://$genomicsDB_name\
	 -O $output_folder/$target_ID.$chr.vcf.gz

done < $SCRIPT_DIR/Traja.agi.2.0.Chr.list

cd $SCRIPT_DIR

