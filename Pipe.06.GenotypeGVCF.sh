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
main_folder=/mnt/WD20/Traja/Traja_GRASDi
script_folder=$main_folder/Scripts

#gatk v.4.3.0.0
module load gatk4/4.3.0.0


target_ID=Traja_GRASDi_ref2_rev2
vcf_folder=$main_folder/vcf_out
lab_under_bar="_"
mkdir -p $vcf_folder


cd $main_folder/gDB


while read chr; do

	genomicsDB_name=genomicsDB.$target_ID$lab_under_bar$chr

	gatk GenotypeGVCFs\
	 -R $reference_folder/$reference_fa\
	 -V gendb://$genomicsDB_name\
	 --include-non-variant-sites\
	 -O $vcf_folder/$target_ID.$chr.vcf.gz

done < $script_folder/Traja.agi.2.0.Chr.list


cd $CURRENT_DIR

module unload gatk4

