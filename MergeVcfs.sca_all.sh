#!/bin/bash
#MergeVcfs.sca_all.sh
#by HIRAO Akira

set -exuo pipefail

SCRIPT_DIR=$(cd $(dirname $0)  && pwd)

no_thread=128

reference_folder=/home/akihirao/work/Traja/RefGenome/RefGenome_v2
main_folder=/home/akihirao/work/Traja/Traja_GRASDi

cd $main_folder/vcf_out_2019_2020

gatk MergeVcfs\
 -R $reference_folder/agi1.2.fa\
 -I Traja_GRASDi_2019_2020.sca1.vcf.gz\
 -I Traja_GRASDi_2019_2020.sca2.vcf.gz\
 -I Traja_GRASDi_2019_2020.sca3.vcf.gz\
 -I Traja_GRASDi_2019_2020.sca4.vcf.gz\
 -I Traja_GRASDi_2019_2020.sca5.vcf.gz\
 -I Traja_GRASDi_2019_2020.sca6.vcf.gz\
 -I Traja_GRASDi_2019_2020.sca7.vcf.gz\
 -I Traja_GRASDi_2019_2020.sca8.vcf.gz\
 -I Traja_GRASDi_2019_2020.sca9.vcf.gz\
 -I Traja_GRASDi_2019_2020.sca10.vcf.gz\
 -I Traja_GRASDi_2019_2020.sca11.vcf.gz\
 -I Traja_GRASDi_2019_2020.sca12.vcf.gz\
 -I Traja_GRASDi_2019_2020.sca13.vcf.gz\
 -I Traja_GRASDi_2019_2020.sca14.vcf.gz\
 -I Traja_GRASDi_2019_2020.sca15.vcf.gz\
 -I Traja_GRASDi_2019_2020.sca16.vcf.gz\
 -I Traja_GRASDi_2019_2020.sca17.vcf.gz\
 -I Traja_GRASDi_2019_2020.sca18.vcf.gz\
 -I Traja_GRASDi_2019_2020.sca19.vcf.gz\
 -I Traja_GRASDi_2019_2020.sca20.vcf.gz\
 -I Traja_GRASDi_2019_2020.sca21.vcf.gz\
 -I Traja_GRASDi_2019_2020.sca22.vcf.gz\
 -I Traja_GRASDi_2019_2020.sca23.vcf.gz\
 -I Traja_GRASDi_2019_2020.sca24.vcf.gz\
 -I Traja_GRASDi_2019_2020.unplaced.vcf.gz\
 -I Traja_GRASDi_2019_2020.mt.vcf.gz\
 -O Traja_GRASDi_2019_2020.sca_all.vcf.gz

cd $SCRIPT_DIR
