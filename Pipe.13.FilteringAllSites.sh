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

while read sca; do

	# coreate a filtered VCF containing only di-allelic snps
	vcftools --gzvcf $target_ID.$sca.all_sites.miss02.vcf.gz\
 	 --mac 1\
	 --remove-indels\
	 --max-alleles 2\
	 --minDP 20\
	 --minQ 30\
	 --max-missing 0.7\
	 --recode --recode-INFO-all --stdout | vcf-annotate\
	 -f MinMQ=30 -H | bgzip -c > \
	 $target_ID.$sca.snp.miss07.DP20.MQ30.vcf.gz
	tabix -p vcf $target_ID.$sca.snp.miss07.DP20.MQ30.vcf.gz

	# create a filtered VCF containing only invariant sites
        vcftools --gzvcf $target_ID.$sca.all_sites.miss02.vcf.gz\
         --max-maf 0\
         --minDP 20\
         --max-missing 0.7\
         --recode --recode-INFO-all --stdout | vcf-annotate\
         -f MinMQ=30 -H | bgzip -c > \
         $target_ID.$sca.invariant.miss07.DP20.MQ30.vcf.gz
        tabix -p vcf $target_ID.$sca.invariant.miss07.DP20.MQ30.vcf.gz
	
	bcftools concat \
	 --allow-overlaps \
	 $target_ID.$sca.snp.miss07.DP20.MQ30.vcf.gz \
	 $target_ID.$sca.invariant.miss07.DP20.MQ30.vcf.gz \
	 -O z -o $target_ID.$sca.all_sites.miss07.DP20.MQ30.vcf.gz
	tabix -p vcf $target_ID.$sca.all_sites.miss07.DP20.MQ30.vcf.gz


        #vcftools --gzvcf $target_ID.$sca.snp.miss07.DP20.MQ30.vcf.gz\
        # --max-missing 1.0\
        # --recode --recode-INFO-all --stdout | bgzip -c > \
        # $target_ID.$sca.snp.miss1.DP20.MQ30.vcf.gz
	#tabix -p vcf $target_ID.$sca.snp.miss1.DP20.MQ30.vcf.gz

        #vcftools --gzvcf $target_ID.$sca.invariant.miss07.DP20.MQ30.vcf.gz\
        # --max-missing 1.0\
        # --recode --recode-INFO-all --stdout | bgzip -c > \
        # $target_ID.$sca.invariant.miss1.DP20.MQ30.vcf.gz
        #tabix -p vcf $target_ID.$sca.invariant.miss1.DP20.MQ30.vcf.gz

done < $scripts_folder/sca_list/Traja.aji.3.1.sca.nDNA.list
#done < $scripts_folder/sca_list/Traja.aji.3.1.unplaced.list


cd $CURRENT_DIR


module unload bcftools/1.16
module unload samtools/1.16.1
module unload gatk4/4.3.0.0
