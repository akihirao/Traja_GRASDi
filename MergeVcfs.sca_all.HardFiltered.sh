#!/bin/bash
#MergeVcfs.sca_all.HardFiltered.sh
#by HIRAO Akira

set -exuo pipefail

SCRIPT_DIR=$(cd $(dirname $0)  && pwd)

no_thread=64

reference_folder=/home/akihirao/work/Traja/RefGenome/RefGenome_v2
main_folder=/home/akihirao/work/Traja/Traja_GRASDi

cd $main_folder/vcf_out_ref2_HardFiltered

gatk MergeVcfs\
 -R $reference_folder/agi1.2.fa\
 -I Traja_GRASDi_2nd_ref2_HardFiltered.sca1.vcf.gz\
 -I Traja_GRASDi_2nd_ref2_HardFiltered.sca2.vcf.gz\
 -I Traja_GRASDi_2nd_ref2_HardFiltered.sca3.vcf.gz\
 -I Traja_GRASDi_2nd_ref2_HardFiltered.sca4.vcf.gz\
 -I Traja_GRASDi_2nd_ref2_HardFiltered.sca5.vcf.gz\
 -I Traja_GRASDi_2nd_ref2_HardFiltered.sca6.vcf.gz\
 -I Traja_GRASDi_2nd_ref2_HardFiltered.sca7.vcf.gz\
 -I Traja_GRASDi_2nd_ref2_HardFiltered.sca8.vcf.gz\
 -I Traja_GRASDi_2nd_ref2_HardFiltered.sca9.vcf.gz\
 -I Traja_GRASDi_2nd_ref2_HardFiltered.sca10.vcf.gz\
 -I Traja_GRASDi_2nd_ref2_HardFiltered.sca11.vcf.gz\
 -I Traja_GRASDi_2nd_ref2_HardFiltered.sca12.vcf.gz\
 -I Traja_GRASDi_2nd_ref2_HardFiltered.sca13.vcf.gz\
 -I Traja_GRASDi_2nd_ref2_HardFiltered.sca14.vcf.gz\
 -I Traja_GRASDi_2nd_ref2_HardFiltered.sca15.vcf.gz\
 -I Traja_GRASDi_2nd_ref2_HardFiltered.sca16.vcf.gz\
 -I Traja_GRASDi_2nd_ref2_HardFiltered.sca17.vcf.gz\
 -I Traja_GRASDi_2nd_ref2_HardFiltered.sca18.vcf.gz\
 -I Traja_GRASDi_2nd_ref2_HardFiltered.sca19.vcf.gz\
 -I Traja_GRASDi_2nd_ref2_HardFiltered.sca20.vcf.gz\
 -I Traja_GRASDi_2nd_ref2_HardFiltered.sca21.vcf.gz\
 -I Traja_GRASDi_2nd_ref2_HardFiltered.sca22.vcf.gz\
 -I Traja_GRASDi_2nd_ref2_HardFiltered.sca23.vcf.gz\
 -I Traja_GRASDi_2nd_ref2_HardFiltered.sca24.vcf.gz\
 -I Traja_GRASDi_2nd_ref2_HardFiltered.unplaced.vcf.gz\
 -I Traja_GRASDi_2nd_ref2_HardFiltered.mt.vcf.gz\
 -O Traja_GRASDi_2nd_ref2_HardFiltered.sca_all.vcf.gz

cd $SCRIPT_DIR

