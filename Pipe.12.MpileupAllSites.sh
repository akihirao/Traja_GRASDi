#!/bin/bash
# Pipe.12.MpileupAllSites.sh
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

	bcftools mpileup -f $reference_folder/$reference_fa\
	 --threads $no_threads\
	 --max-depth 1000\
	 -b $scripts_folder/sample_list/Traja_614indiv_filtered_BAM.list.txt\
	 --annotate "FORMAT/AD,DP"\
	 -r $sca | \
	bcftools call\
	 --threads $no_threads\
	 -m -Oz\
	 --annotate "FORMAT/GQ"\
	 -o $target_ID.$sca.all_sites.raw.vcf.gz
	tabix -p vcf $target_ID.$sca.all_sites.raw.vcf.gz 
	
	vcftools --gzvcf $target_ID.$sca.all_sites.raw.vcf.gz\
	 --max-missing 0.5\
	 --recode --recode-INFO-all --stdout | bgzip > $target_ID.$sca.all_sites.miss02.vcf.gz
	tabix -p vcf $target_ID.$sca.all_sites.miss02.vcf.gz

done < $scripts_folder/sca_list/Traja.aji.3.1.sca.nDNA.list
#done < $scripts_folder/sca_list/Traja.aji.3.1.sca4.list


cd $CURRENT_DIR


module unload bcftools/1.16
module unload samtools/1.16.1
module unload gatk4/4.3.0.0
