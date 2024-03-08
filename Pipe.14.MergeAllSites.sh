#!/bin/bash
# Pipe.13.FilteringAllSites.sh
# by HIRAO Akira

set -exuo pipefail

CURRENT_DIR=$(cd $(dirname $0)  && pwd)

no_threads=16


#aji.3.1 (aji.3.1: reference genome); fasta header name = scax
code_ID="aji.3.1"

#aji.3.1.fa: the reference genoeme provided by Dr. Fujiwara @2023/2/13
reference_fa=aji.3.1.fa
reference_fa_head=aji.3.1
reference_folder=/home/$USER/work/Traja/RefGenome/RefGenome_v5.1
main_folder=/mnt/WD20/Traja/Traja_GRASDi
scripts_folder=$main_folder/Scripts

#bcftools 1.16
#samtools 1.16.1
#Using htslib 1.16.1

#gatk 4.3.0.0
module load bcftools/1.16
module load samtools/1.16.1
module load gatk4/4.3.0.0


target_ID=Traja_GRASDi_ref31
vcf_folder=$main_folder/vcf_out
mkdir -p $vcf_folder


cd $vcf_folder

#bcftools concat \
# --allow-overlaps \
# $target_ID.$sca.snp.miss07.DP20.MQ30.vcf.gz \
# $target_ID.$sca.invariant.miss07.DP20.MQ30.vcf.gz \
# -O z -o $target_ID.$sca.all_sites.miss07.DP20.MQ30.vcf.gz
#tabix -p vcf $target_ID.$sca.all_sites.miss07.DP20.MQ30.vcf.gz

gatk MergeVcfs\
 -R $reference_folder/$reference_fa\
 -I $target_ID.sca1.all_sites.miss07.DP20.MQ30.vcf.gz\
 -I $target_ID.sca2.all_sites.miss07.DP20.MQ30.vcf.gz\
 -I $target_ID.sca3.all_sites.miss07.DP20.MQ30.vcf.gz\
 -I $target_ID.sca4.all_sites.miss07.DP20.MQ30.vcf.gz\
 -I $target_ID.sca5.all_sites.miss07.DP20.MQ30.vcf.gz\
 -I $target_ID.sca6.all_sites.miss07.DP20.MQ30.vcf.gz\
 -I $target_ID.sca7.all_sites.miss07.DP20.MQ30.vcf.gz\
 -I $target_ID.sca8.all_sites.miss07.DP20.MQ30.vcf.gz\
 -I $target_ID.sca9.all_sites.miss07.DP20.MQ30.vcf.gz\
 -I $target_ID.sca10.all_sites.miss07.DP20.MQ30.vcf.gz\
 -I $target_ID.sca11.all_sites.miss07.DP20.MQ30.vcf.gz\
 -I $target_ID.sca12.all_sites.miss07.DP20.MQ30.vcf.gz\
 -I $target_ID.sca13.all_sites.miss07.DP20.MQ30.vcf.gz\
 -I $target_ID.sca14.all_sites.miss07.DP20.MQ30.vcf.gz\
 -I $target_ID.sca15.all_sites.miss07.DP20.MQ30.vcf.gz\
 -I $target_ID.sca16.all_sites.miss07.DP20.MQ30.vcf.gz\
 -I $target_ID.sca17.all_sites.miss07.DP20.MQ30.vcf.gz\
 -I $target_ID.sca18.all_sites.miss07.DP20.MQ30.vcf.gz\
 -I $target_ID.sca19.all_sites.miss07.DP20.MQ30.vcf.gz\
 -I $target_ID.sca20.all_sites.miss07.DP20.MQ30.vcf.gz\
 -I $target_ID.sca21.all_sites.miss07.DP20.MQ30.vcf.gz\
 -I $target_ID.sca22.all_sites.miss07.DP20.MQ30.vcf.gz\
 -I $target_ID.sca23.all_sites.miss07.DP20.MQ30.vcf.gz\
 -I $target_ID.sca24.all_sites.miss07.DP20.MQ30.vcf.gz\
 -I $target_ID.unplaced.all_sites.miss07.DP20.MQ30.vcf.gz\
 -O $target_ID.sca_all.all_sites.miss07.DP20.MQ30.vcf.gz

gatk MergeVcfs\
 -R $reference_folder/$reference_fa\
 -I $target_ID.sca1.snp.miss07.DP20.MQ30.vcf.gz\
 -I $target_ID.sca2.snp.miss07.DP20.MQ30.vcf.gz\
 -I $target_ID.sca3.snp.miss07.DP20.MQ30.vcf.gz\
 -I $target_ID.sca4.snp.miss07.DP20.MQ30.vcf.gz\
 -I $target_ID.sca5.snp.miss07.DP20.MQ30.vcf.gz\
 -I $target_ID.sca6.snp.miss07.DP20.MQ30.vcf.gz\
 -I $target_ID.sca7.snp.miss07.DP20.MQ30.vcf.gz\
 -I $target_ID.sca8.snp.miss07.DP20.MQ30.vcf.gz\
 -I $target_ID.sca9.snp.miss07.DP20.MQ30.vcf.gz\
 -I $target_ID.sca10.snp.miss07.DP20.MQ30.vcf.gz\
 -I $target_ID.sca11.snp.miss07.DP20.MQ30.vcf.gz\
 -I $target_ID.sca12.snp.miss07.DP20.MQ30.vcf.gz\
 -I $target_ID.sca13.snp.miss07.DP20.MQ30.vcf.gz\
 -I $target_ID.sca14.snp.miss07.DP20.MQ30.vcf.gz\
 -I $target_ID.sca15.snp.miss07.DP20.MQ30.vcf.gz\
 -I $target_ID.sca16.snp.miss07.DP20.MQ30.vcf.gz\
 -I $target_ID.sca17.snp.miss07.DP20.MQ30.vcf.gz\
 -I $target_ID.sca18.snp.miss07.DP20.MQ30.vcf.gz\
 -I $target_ID.sca19.snp.miss07.DP20.MQ30.vcf.gz\
 -I $target_ID.sca20.snp.miss07.DP20.MQ30.vcf.gz\
 -I $target_ID.sca21.snp.miss07.DP20.MQ30.vcf.gz\
 -I $target_ID.sca22.snp.miss07.DP20.MQ30.vcf.gz\
 -I $target_ID.sca23.snp.miss07.DP20.MQ30.vcf.gz\
 -I $target_ID.sca24.snp.miss07.DP20.MQ30.vcf.gz\
 -I $target_ID.unplaced.snp.miss07.DP20.MQ30.vcf.gz\
 -O $target_ID.sca_all.snp.miss07.DP20.MQ30.vcf.gz
 
cd $CURRENT_DIR


module unload bcftools/1.16
module unload samtools/1.16.1
module unload gatk4/4.3.0.0

