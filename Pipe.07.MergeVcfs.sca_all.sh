#!/bin/bash
#Pipe.07.MergeVcfs.sca_all.sh
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
vcf_folder=$main_folder/vcf_out

# gatk ver.4.3.0.0
module load gatk4/4.3.0.0


target_ID=Traja_GRASDi_ref31

cd $main_folder/vcf_out


gatk MergeVcfs\
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

module unload gatk4/4.3.0.0

