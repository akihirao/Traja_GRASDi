#!/bin/bash
#Pipe.07.SelectVariants.HardFiltered.sh
#by HIRAO Akira

set -exuo pipefail

SCRIPT_DIR=$(cd $(dirname $0)  && pwd)

no_thread=64

reference_folder=/home/akihirao/work/Traja/RefGenome/RefGenome_v4
main_folder=/home/akihirao/work/Traja/Traja_GRASDi

target_ID=Traja_GRASDi_ref2_HardFiltered
work_folder=$main_folder/vcf_out_ref2_HardFiltered
mkdir -p $work_folder


cd $work_folder

#----------------------------------------------------------------------------------
#Spliting SNPv (only biallelic)
gatk SelectVariants\
 -R $reference_folder/agi.2.0.fa\
 -V $work_folder/$target_ID.sca_all.vcf.gz\
 -select-type SNP\
 --restrict-alleles-to BIALLELIC\
 -O $work_folder/$target_ID.sca_all.snp.vcf.gz

#Spliting INDEL (only biallelic)
gatk SelectVariants\
 -R $reference_folder/agi.2.0.fa\
 -V $work_folder/$target_ID.sca_all.vcf.gz\
 -select-type INDEL\
 --restrict-alleles-to BIALLELIC\
 -O $work_folder/$target_ID.sca_all.indel.vcf.gz
#----------------------------------------------------------------------------------

cd $SCRIPT_DIR

