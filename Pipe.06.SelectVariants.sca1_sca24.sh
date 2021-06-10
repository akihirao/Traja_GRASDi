#!/bin/bash
#Pipe.06.SelectVariants.sca1_sca24.sh
#by HIRAO Akira

set -exuo pipefail

SCRIPT_DIR=$(cd $(dirname $0)  && pwd)

no_thread=64

reference_folder=/home/akihirao/work/Traja/RefGenome/RefGenome_v2
main_folder=/home/akihirao/work/Traja/Traja_GRASDi

target_ID=Traja_GRASDi
work_folder=$main_folder/vcf_out
mkdir -p $work_folder


cd $work_folder

#----------------------------------------------------------------------------------
#Spliting SNPv
gatk SelectVariants\
 -R $reference_folder/agi1.2.fa\
 -V $work_folder/$target_ID.sca1_sca24.vcf.gz\
 -select-type SNP\
 --restrict-alleles-to BIALLELIC\
 -O $work_folder/$target_ID.sca1_sca24.snp.vcf.gz

#Spliting INDEL (only biallelic)
gatk SelectVariants\
 -R $reference_folder/agi1.2.fa\
 -V $work_folder/$target_ID.sca1_sca24.vcf.gz\
 -select-type INDEL\
 --restrict-alleles-to BIALLELIC\
 -O $work_folder/$target_ID.sca1_sca24.indel.vcf.gz
#----------------------------------------------------------------------------------


cd $SCRIPT_DIR
