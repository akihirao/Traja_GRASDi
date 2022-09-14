#!/bin/bash
#Pipe.07.MergeVcfs.sca_all.sh
#by HIRAO Akira

set -exuo pipefail

CURRENT_DIR=$(cd $(dirname $0)  && pwd)

no_threads=48


#agi.2.0.rev2 (agi.2.0: reference genome; rev2: pair-end merge reads)
code_ID="agi.2.0.rev2"

reference_fa=agi.2.0.fa
reference_folder=/home/$USER/work/Traja/RefGenome/RefGenome_v4
main_folder=/home/$USER/work/Traja/Traja_GRASDi
script_folder=$main_folder/Scripts

#set path to gatk ver.4.2.0.0
gatk_folder=/home/$USER/local/gatk-4.2.0.0


target_ID=Traja_GRASDi_ref2_rev2

cd $main_folder/vcf_out


$gatk_folder/gatk MergeVcfs\
 -R $reference_folder/$reference_fa\
 -I $target_ID.sca1.vcf.gz\
 -I $target_ID.sca2.vcf.gz\
 -I $target_ID.sca3.vcf.gz\
 -I $target_ID.sca4.vcf.gz\
 -I $target_ID.sca5.vcf.gz\
 -I $target_ID.sca6.vcf.gz\
 -I $target_ID.sca7.vcf.gz\
 -I $target_ID.sca8.vcf.gz\
 -I $target_ID.sca9.vcf.gz\
 -I $target_ID.sca10.vcf.gz\
 -I $target_ID.sca11.vcf.gz\
 -I $target_ID.sca12.vcf.gz\
 -I $target_ID.sca13.vcf.gz\
 -I $target_ID.sca14.vcf.gz\
 -I $target_ID.sca15.vcf.gz\
 -I $target_ID.sca16.vcf.gz\
 -I $target_ID.sca17.vcf.gz\
 -I $target_ID.sca18.vcf.gz\
 -I $target_ID.sca19.vcf.gz\
 -I $target_ID.sca20.vcf.gz\
 -I $target_ID.sca21.vcf.gz\
 -I $target_ID.sca22.vcf.gz\
 -I $target_ID.sca23.vcf.gz\
 -I $target_ID.sca24.vcf.gz\
 -I $target_ID.unplaced.vcf.gz\
 -I $target_ID.mt.vcf.gz\
 -O $target_ID.sca_all.vcf.gz

cd $CURRENT_DIR

