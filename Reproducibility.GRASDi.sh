#!/bin/bash
#Reproducibility.GRASDi.sh
#by HIRAO Akira

set -exuo pipefail

CURRENT_DIR=$(cd $(dirname $0)  && pwd)

no_threads=48

#input your account name
user_name=akihirao

#agi.2.0.rev2 (agi.2.0: reference genome; rev2: pair-end merge reads)
code_ID="agi.2.0.rev2"

reference_fa=agi.2.0.fa
reference_folder=/home/$user_name/work/Traja/RefGenome/RefGenome_v4
main_folder=/home/$user_name/work/Traja/Traja_GRASDi
script_folder=$main_folder/Scripts
mkdir -p $script_folder/PCA_out

#set path to gatk ver.4.2.0.0
gatk_folder=/home/$user_name/local/gatk-4.2.0.0


target_ID=Traja_GRASDi_ref2_rev2
work_folder=$main_folder/vcf_out
vcf_folder=$main_folder/vcf_out
plink_folder=$main_folder/plink_filtering

mkdir -p $plink_folder

cd $plink_folder

zcat $vcf_folder/$target_ID.nDNA.snp.50.non_singleton.vcf.gz | perl Vcf2BED_chr_start_end.pl > $vcf_folder/$target_ID.nDNA.snp.50.non_singleton.bed

#Extrac three samples by three replications
vcftools --gzvcf $vcf_folder/$target_ID.nDNA.snp.DPfilterNoCall.non_rep.P99.vcf.gz\
 --keep rep_sample_ID.list --bed $vcf_folder/$target_ID.nDNA.snp.50.non_singleton.bed\
 --recode --recode-INFO-all --stdout > $vcf_folder/$target_ID.replications.nDNA.snp.50.non_singleton.vcf
bgzip -c $vcf_folder/$target_ID.replications.nDNA.snp.50.non_singleton.vcf > $vcf_folder/$target_ID.replications.nDNA.snp.50.non_singleton.vcf.gz
tabix -p vcf $vcf_folder/$target_ID.replications.nDNA.snp.50.non_singleton.vcf.gz



