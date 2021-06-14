#!/bin/bash -i
#Pipe.08.FilteringOutNoCall.sca1_sca24.sh
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

#Filtering out samples with label repetation: SNP
gatk SelectVariants\
 -R $reference_folder/agi1.2.fa\
 -V $target_ID.sca1_sca24.snp.DPfilterNoCall.vcf.gz\
 --exclude-sample-name $SCRIPT_DIR/Traja_GRASDi.LabelRepetation.args\
 -O $target_ID.sca1_sca24.snp.DPfilterNoCall.non_rep.vcf.gz

#Filtering out samples with label repetation: INDEL
gatk SelectVariants\
 -R $reference_folder/agi1.2.fa\
 -V $target_ID.sca1_sca24.indel.DPfilterNoCall.vcf.gz\
 --exclude-sample-name $SCRIPT_DIR/Traja_GRASDi.LabelRepetation.args\
 -O $target_ID.sca1_sca24.indel.DPfilterNoCall.non_rep.vcf.gz


#Set filtered sites to no call: SNP
#set filtering out locus with no genotypes 99%
gatk SelectVariants\
 -R $reference_folder/agi1.2.fa\
 -V $target_ID.sca1_sca24.snp.DPfilterNoCall.non_rep.vcf.gz\
 --set-filtered-gt-to-nocall\
 --max-nocall-fraction 0.99\
 --exclude-filtered\
 -O $target_ID.sca1_sca24.snp.DPfilterNoCall.non_rep.P99.vcf.gz


#Set filtered sites to no call: INDEL
#set filtering out locus with no genotypes 99%
gatk SelectVariants\
 -R $reference_folder/agi1.2.fa\
 -V $target_ID.sca1_sca24.indel.DPfilterNoCall.non_rep.vcf.gz\
 --set-filtered-gt-to-nocall\
 --max-nocall-fraction 0.99\
 --exclude-filtered\
 -O $target_ID.sca1_sca24.indel.DPfilterNoCall.non_rep.P99.vcf.gz



