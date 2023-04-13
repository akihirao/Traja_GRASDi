#!/bin/bash
#Pipe.08.SelectVariants.sh
#by HIRAO Akira

set -exuo pipefail

CURRENT_DIR=$(cd $(dirname $0)  && pwd)

no_threads=8


#aji.3.1 (aji.3.1: reference genome); fasta header name = scax
code_ID="aji.3.1"

#aji.3.1.fa: the reference genoeme provided by Dr. Fujiwara @2023/2/13
reference_fa=aji.3.1.fa
reference_fa_head=aji.3.1
reference_folder=/home/$USER/work/Traja/RefGenome/RefGenome_v5.1
main_folder=/mnt/WD20/Traja/Traja_GRASDi
script_folder=$main_folder/Scripts

#gatk v.4.3.0.0
module load gatk4/4.3.0.0


target_ID=Traja_GRASDi_ref31
work_folder=$main_folder/vcf_out
mkdir -p $work_folder


cd $work_folder

#----------------------------------------------------------------------------------
#Extracting SNPs (only biallelic)
gatk SelectVariants\
 -R $reference_folder/$reference_fa\
 -V $work_folder/$target_ID.sca_all.vcf.gz\
 -select-type SNP\
 --restrict-alleles-to BIALLELIC\
 -O $work_folder/$target_ID.sca_all.snp.vcf.gz

#Extracting INDELs (only biallelic)
gatk SelectVariants\
 -R $reference_folder/$reference_fa\
 -V $work_folder/$target_ID.sca_all.vcf.gz\
 -select-type INDEL\
 --restrict-alleles-to BIALLELIC\
 -O $work_folder/$target_ID.sca_all.indel.vcf.gz


#----------------------------------------------------------------------------------

cd $CURRENT_DIR

module unload gatk4/4.3.0.0

