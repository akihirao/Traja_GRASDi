#!/bin/bash
#Pipe.06.GenotypeGVCF.sh
#by HIRAO Akira

set -exuo pipefail

CURRENT_DIR=$(cd $(dirname $0)  && pwd)

no_threads=24


#aji.3.0 (aji.3.0: reference genome) 
code_ID="aji.3.0"

#aji.3.0.fa: the reference genoeme provided by Dr. Fujiwara @2023/2/13
reference_fa=aji.3.0.fa
reference_fa_head=aji.3.0
reference_folder=/home/$USER/work/Traja/RefGenome/RefGenome_v5
main_folder=/mnt/WD20/Traja/Traja_GRASDi
script_folder=$main_folder/Scripts

#gatk v.4.3.0.0
module load gatk4/4.3.0.0


target_ID=Traja_GRASDi_ref3
vcf_folder=$main_folder/vcf_out
lab_under_bar="_"
mkdir -p $vcf_folder


cd $main_folder/gDB


while read chr; do

	genomicsDB_name=genomicsDB.$target_ID$lab_under_bar$chr

	gatk GenotypeGVCFs\
	 -R $reference_folder/$reference_fa\
	 -V gendb://$genomicsDB_name\
	 -O $vcf_folder/$target_ID.$chr.vcf.gz

done < $script_folder/Traja.aji.3.0.Chr15.list


cd $CURRENT_DIR

module unload gatk4/4.3.0.0


