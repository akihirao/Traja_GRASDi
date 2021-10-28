#!/bin/bash
#Pipe.05.GenotypeGVCF.ref2.unplaced_mt.sh
#by HIRAO Akira

set -exuo pipefail

SCRIPT_DIR=$(cd $(dirname $0)  && pwd)

#no_thread=128

reference_folder=/home/akihirao/work/Traja/RefGenome/RefGenome_v4
main_folder=/home/akihirao/work/Traja/Traja_GRASDi



target_ID=Traja_GRASDi_all_ref2
output_folder=$main_folder/vcf_out_ref2
lab_under_bar="_"
mkdir -p $output_folder



cd $main_folder/gDB


while read chr; do

	genomicsDB_name=genomicsDB.$target_ID$lab_under_bar$chr

	gatk GenotypeGVCFs\
	 -R $reference_folder/agi.2.0.fa -V gendb://$genomicsDB_name\
	 -O $output_folder/$target_ID.$chr.vcf.gz

done < $SCRIPT_DIR/unplaced_mt.list


cd $SCRIPT_DIR
