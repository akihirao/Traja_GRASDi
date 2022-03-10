#!/bin/bash
#Pipe.10.FilteringOutNoCall.sh
#by HIRAO Akira

set -exuo pipefail

CURRENT_DIR=$(cd $(dirname $0)  && pwd)

no_threads=48

#input your account
user_name=akihirao

#agi.2.0.rev2 (agi.2.0: reference genome; rev2: pair-end merge reads)
code_ID="agi.2.0.rev2"

reference_fa=agi.2.0.fa
reference_folder=/home/$user_name/work/Traja/RefGenome/RefGenome_v4
main_folder=/home/$user_name/work/Traja/Traja_GRASDi
script_folder=$main_folder/Scripts

#set path to gatk ver.4.2.0.0
gatk_folder=/home/$user_name/local/gatk-4.2.0.0


target_ID=Traja_GRASDi_ref2_rev2
work_folder=$main_folder/vcf_out_ref2_rev2
mkdir -p $work_folder


cd $work_folder

#Filtering out samples with label repetation: SNP
$gatk_folder/gatk SelectVariants\
 -R $reference_folder/$reference_fa\
 -V $target_ID.nDNA.snp.DPfilterNoCall.vcf.gz\
 --exclude-sample-name $script_folder/Traja_GRASDi.LabelRepetation.IndivRepetation.args\
 -O $target_ID.nDNA.snp.DPfilterNoCall.non_rep.vcf.gz

#Filtering out samples with label repetation: INDEL
$gatk_folder/gatk SelectVariants\
 -R $reference_folder/$reference_fa\
 -V $target_ID.nDNA.indel.DPfilterNoCall.vcf.gz\
 --exclude-sample-name $script_folder/Traja_GRASDi.LabelRepetation.IndivRepetation.args\
 -O $target_ID.nDNA.indel.DPfilterNoCall.non_rep.vcf.gz


#Set filtered sites to no call: SNP
#set filtering out locus with no genotypes 99%
$gatk_folder/gatk SelectVariants\
 -R $reference_folder/$reference_fa\
 -V $target_ID.nDNA.snp.DPfilterNoCall.non_rep.vcf.gz\
 --set-filtered-gt-to-nocall\
 --max-nocall-fraction 0.99\
 --exclude-filtered\
 -O $target_ID.nDNA.snp.DPfilterNoCall.non_rep.P99.vcf.gz


#Set filtered sites to no call: INDEL
#set filtering out locus with no genotypes 99%
$gatk_folder/gatk SelectVariants\
 -R $reference_folder/$reference_fa\
 -V $target_ID.nDNA.indel.DPfilterNoCall.non_rep.vcf.gz\
 --set-filtered-gt-to-nocall\
 --max-nocall-fraction 0.99\
 --exclude-filtered\
 -O $target_ID.nDNA.indel.DPfilterNoCall.non_rep.P99.vcf.gz

cd $CURRENT_DIR

