#!/bin/bash
#LD.pruned.non_singleton.vcf.sh
#by HIRAO Akira

set -exuo pipefail

CURRENT_DIR=$(cd $(dirname $0)  && pwd)

no_threads=4


#agi.2.0.rev2 (agi.2.0: reference genome; rev2: pair-end merge reads)
code_ID="agi.2.0.rev2"

reference_fa=agi.2.0.fa
reference_folder=/home/$USER/work/Traja/RefGenome/RefGenome_v4

main_folder=/home/$USER/work/Traja/Traja_GRASDi
script_folder=$main_folder/Scripts

target_ID=Traja_GRASDi_ref2_rev2
work_folder=$main_folder/vcf_out
vcf_folder=$main_folder/vcf_out
plink_folder=$main_folder/plink_filtering

lab_50_filtering="50"

#set path to gatk ver.4.2.0.0
gatk_folder=/home/$USER/local/gatk-4.2.0.0


#LD-pruning for non_singleton
plink2 --allow-extra-chr\
 --vcf $vcf_folder/$target_ID.nDNA.snp.non_singleton.vcf\
 --indep-pairwise 100 kb 1 0.1 --set-all-var-ids @:#\
 --out $vcf_folder/$target_ID.nDNA.snp.non_singleton


#convert from LD-prune.in to BED
perl $script_folder/LDpruned2BED.pl < $vcf_folder/$target_ID.nDNA.snp.non_singleton.prune.in > $plink_folder/$target_ID.nDNA.snp.non_singleton.LDpruned.bed

$gatk_folder/gatk SelectVariants\
 -R $reference_folder/$reference_fa\
 -V $vcf_folder/$target_ID.nDNA.snp.DPfilterNoCall.non_rep.P99.vcf.gz\
 --sample-name $script_folder/$target_ID.nDNA.snp.$lab_50_filtering.indiv.args\
 -L $plink_folder/$target_ID.nDNA.snp.non_singleton.LDpruned.bed\
 -O $vcf_folder/$target_ID.nDNA.snp.non_singleton.LDpruned.vcf.gz

cd $CURRENT_DIR

