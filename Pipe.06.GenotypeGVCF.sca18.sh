#!/bin/bash
#Pipe.06.GenotypeGVCF.sh
#by HIRAO Akira

set -exuo pipefail

SCRIPT_DIR=$(cd $(dirname $0)  && pwd)

no_threads=64

reference_fa=agi.2.0.fa
reference_folder=/home/akihirao/work/Traja/RefGenome/RefGenome_v4
main_folder=/home/akihirao/work/Traja/Traja_GRASDi



target_ID=Traja_GRASDi_ref2_rev1
output_folder=$main_folder/vcf_out_ref2_rev1
lab_under_bar="_"
mkdir -p $output_folder



cd $main_folder/gDB


while read chr; do

	genomicsDB_name=genomicsDB.$target_ID$lab_under_bar$chr

	gatk GenotypeGVCFs\
	 --genomicsdb-shared-posixfs-optimizations TRUE\
	 -R $reference_folder/$reference_fa -V gendb://$genomicsDB_name\
	 -O $output_folder/$target_ID.$chr.vcf.gz

done < $SCRIPT_DIR/Traja.agi.2.0.sca18.list


cd $SCRIPT_DIR


