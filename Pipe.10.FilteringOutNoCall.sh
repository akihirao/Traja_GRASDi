#!/bin/bash
#Pipe.10.FilteringOutNoCall.sh
#by HIRAO Akira

set -exuo pipefail

CURRENT_DIR=$(cd $(dirname $0)  && pwd)

no_threads=24


#aji.3.1 (aji.3.1: reference genome); fasta header name = scax
code_ID="aji.3.1"

#aji.3.1.fa: the reference genoeme provided by Dr. Fujiwara @2023/2/13
reference_fa=aji.3.1.fa
reference_fa_head=aji.3.1
reference_folder=/home/$USER/work/Traja/RefGenome/RefGenome_v5.1
main_folder=/mnt/WD20/Traja/Traja_GRASDi
script_folder=$main_folder/Scripts

# gatk v.4.3.0.0
module load gatk4/4.3.0.0


target_ID=Traja_GRASDi_ref31
work_folder=$main_folder/vcf_out
mkdir -p $work_folder


cd $work_folder

#Filtering out samples with label repetation: SNP
gatk SelectVariants\
 -R $reference_folder/$reference_fa\
 -V $target_ID.nDNA.snp.DPfilterNoCall.vcf.gz\
 --exclude-sample-name $script_folder/Traja_GRASDi.LabelRepetation.IndivRepetation.args\
 -O $target_ID.nDNA.snp.DPfilterNoCall.non_rep.vcf.gz

#Filtering out samples with label repetation: INDEL
gatk SelectVariants\
 -R $reference_folder/$reference_fa\
 -V $target_ID.nDNA.indel.DPfilterNoCall.vcf.gz\
 --exclude-sample-name $script_folder/Traja_GRASDi.LabelRepetation.IndivRepetation.args\
 -O $target_ID.nDNA.indel.DPfilterNoCall.non_rep.vcf.gz


#Set filtered sites to no call: SNP
#set filtering out locus with no genotypes 99%
gatk SelectVariants\
 -R $reference_folder/$reference_fa\
 -V $target_ID.nDNA.snp.DPfilterNoCall.non_rep.vcf.gz\
 --set-filtered-gt-to-nocall\
 --max-nocall-fraction 0.99\
 --exclude-filtered\
 -O $target_ID.nDNA.snp.DPfilterNoCall.non_rep.P99.vcf.gz


#Set filtered sites to no call: INDEL
#set filtering out locus with no genotypes 99%
gatk SelectVariants\
 -R $reference_folder/$reference_fa\
 -V $target_ID.nDNA.indel.DPfilterNoCall.non_rep.vcf.gz\
 --set-filtered-gt-to-nocall\
 --max-nocall-fraction 0.99\
 --exclude-filtered\
 -O $target_ID.nDNA.indel.DPfilterNoCall.non_rep.P99.vcf.gz

cd $CURRENT_DIR

module unload gatk4/4.3.0.0
