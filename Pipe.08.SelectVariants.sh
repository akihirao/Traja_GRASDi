#!/bin/bash
#Pipe.08.SelectVariants.sh
#by HIRAO Akira

set -exuo pipefail

SCRIPT_DIR=$(cd $(dirname $0)  && pwd)

no_threads=64

#input your account name
user_name=akihirao

reference_fa=agi.2.0.fa
reference_folder=/home/$user_name/work/Traja/RefGenome/RefGenome_v4
main_folder=/home/$user_name/work/Traja/Traja_GRASDi

#set path to gatk ver.4.2.0.0
gatk_folder=/home/$user_name/local/gakt-4.2.0.0


target_ID=Traja_GRASDi_ref2_rev1
work_folder=$main_folder/vcf_out_ref2_rev1
mkdir -p $work_folder


cd $work_folder

#----------------------------------------------------------------------------------
#Spliting SNPv (only biallelic)
$gatk_folder/gatk SelectVariants\
 -R $reference_folder/$reference_fa\
 -V $work_folder/$target_ID.sca_all.vcf.gz\
 -select-type SNP\
 --restrict-alleles-to BIALLELIC\
 -O $work_folder/$target_ID.sca_all.snp.vcf.gz

#Spliting INDEL (only biallelic)
$gatk_folder/gatk SelectVariants\
 -R $reference_folder/$reference_fa\
 -V $work_folder/$target_ID.sca_all.vcf.gz\
 -select-type INDEL\
 --restrict-alleles-to BIALLELIC\
 -O $work_folder/$target_ID.sca_all.indel.vcf.gz
#----------------------------------------------------------------------------------

cd $SCRIPT_DIR

