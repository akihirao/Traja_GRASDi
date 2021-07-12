#!/bin/bash
#Pipe.05.GenotypeGVCF.2019.2020.Year.Class.sca17_sca20.sh
#by HIRAO Akira

set -exuo pipefail

SCRIPT_DIR=$(cd $(dirname $0)  && pwd)

#no_thread=128

reference_folder=/home/akihirao/work/Traja/RefGenome/RefGenome_v2
main_folder=/home/akihirao/work/Traja/Traja_GRASDi



target_ID=Traja_GRASDi_2019_2020
output_folder=$main_folder/vcf_out_2019_2020
lab_under_bar="_"
mkdir -p $output_folder



cd $main_folder/gDB


while read chr; do

	genomicsDB_name=genomicsDB.$target_ID$lab_under_bar$chr

	gatk GenotypeGVCFs\
	 -R $reference_folder/agi1.2.fa -V gendb://$genomicsDB_name\
	 -O $output_folder/$target_ID.$chr.vcf.gz

done < $SCRIPT_DIR/sca17_sca20.list


cd $SCRIPT_DIR
