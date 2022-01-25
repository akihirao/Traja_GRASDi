#!/bin/bash
#Pipe.10.FilteringOutNoCall.sh
#by HIRAO Akira

set -exuo pipefail

SCRIPT_DIR=$(cd $(dirname $0)  && pwd)

no_threads=64

#input your account
user_name=akihirao

reference_fa=agi.2.0.fa
reference_folder=/home/$user_name/work/Traja/RefGenome/RefGenome_v4
main_folder=/home/$user_name/work/Traja/Traja_GRASDi

#set path to gatk ver.4.2.0.0
gatk_folder=/home/$user_name/local/gatk-4.2.0.0


target_ID=Traja_GRASDi_ref2_rev1
work_folder=$main_folder/vcf_out_ref2_rev1
mkdir -p $work_folder


cd $work_folder

#Filtering out samples with label repetation: SNP
$gatk_folder/gatk SelectVariants\
 -R $reference_folder/$reference_fa\
 -V $target_ID.nDNA.snp.DPfilterNoCall.vcf.gz\
 --exclude-sample-name $SCRIPT_DIR/Traja_GRASDi.LabelRepetation.IndivRepetation.args\
 -O $target_ID.nDNA.snp.DPfilterNoCall.non_rep.vcf.gz

#Filtering out samples with label repetation: INDEL
$gatk_folder/gatk SelectVariants\
 -R $reference_folder/$reference_fa\
 -V $target_ID.nDNA.indel.DPfilterNoCall.vcf.gz\
 --exclude-sample-name $SCRIPT_DIR/Traja_GRASDi.LabelRepetation.IndivRepetation.args\
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

cd $SCRIPT_DIR

