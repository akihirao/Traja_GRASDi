#!/bin/bash
#Pipe.06.GenotypeGVCF.sh
#by HIRAO Akira

set -exuo pipefail

CURRENT_DIR=$(cd $(dirname $0)  && pwd)

no_threads=48


#agi.2.0.rev2 (agi.2.0: reference genome; rev2: pair-end merge reads)
code_ID="agi.2.0.rev2"

reference_fa=agi.2.0.fa
reference_folder=/home/$USER/work/Traja/RefGenome/RefGenome_v4
main_folder=/home/$USER/work/Traja/Traja_GRASDi
script_folder=$main_folder/Scripts

#set path to gatk ver.4.2.0.0
gatk_folder=/home/$USER/local/gatk-4.2.0.0


target_ID=Traja_GRASDi_ref2_rev2
output_folder=$main_folder/vcf_out
lab_under_bar="_"
mkdir -p $output_folder


cd $main_folder/gDB


while read chr; do

	genomicsDB_name=genomicsDB.$target_ID$lab_under_bar$chr

	$gatk_folder/gatk GenotypeGVCFs\
	 -R $reference_folder/$reference_fa -V gendb://$genomicsDB_name\
	 --include-non-variant-sites\
	 -O $output_folder/$target_ID.nonVar.$chr.vcf.gz

#done < $script_folder/Traja.agi.2.0.Chr2.list
done < $script_folder/Traja.agi.2.0.Chr.list

cd $CURRENT_DIR


