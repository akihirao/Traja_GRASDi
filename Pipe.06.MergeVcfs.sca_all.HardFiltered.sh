#!/bin/bash
#Pipe.06.MergeVcfs.sca_all.HardFiltered.sh
#by HIRAO Akira

set -exuo pipefail

SCRIPT_DIR=$(cd $(dirname $0)  && pwd)

no_thread=64

reference_folder=/home/akihirao/work/Traja/RefGenome/RefGenome_v4
main_folder=/home/akihirao/work/Traja/Traja_GRASDi

target_ID=Traja_GRASDi_ref2_HardFiltered

cd $main_folder/vcf_out_ref2_HardFiltered


gatk MergeVcfs\
 -R $reference_folder/agi.2.0.fa\
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

cd $SCRIPT_DIR

