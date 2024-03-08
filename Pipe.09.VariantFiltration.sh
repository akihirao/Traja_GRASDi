#!/bin/bash
# Pipe.09.VariantFiltration.sh
# by HIRAO Akira

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
repeatmasker_folder=$main_folder/RepeatMasker

# gatk v.4.3.0.0
module load gatk4/4.3.0.0

target_ID=Traja_GRASDi_ref31
output_folder=$main_folder/vcf_out
mkdir -p $output_folder

cd $output_folder


#===============================================
#Filtering out mt
gatk SelectVariants\
 -R $reference_folder/$reference_fa\
 -V $target_ID.sca_all.snp.vcf.gz\
 -XL $script_folder/mt.list\
 -O $target_ID.nDNA.snp.vcf.gz

gatk SelectVariants\
 -R $reference_folder/$reference_fa\
 -V $target_ID.sca_all.indel.vcf.gz\
 -XL $script_folder/mt.list\
 -O $target_ID.nDNA.indel.vcf.gz

#===============================================
 
 
#defining ExcessHet parameter
#"ExcessHet > 13.0" means excess of heterozygosity with p value 0.05 
ExcessHet_P=0.05
ExcessHet_Q=`echo "scale=5; -10 * l($ExcessHet_P) /l(10)" |bc -l | xargs printf %.1f`
ExcessHet_param="ExcessHet > ${ExcessHet_Q}"

echo $ExcessHet_param


#Making select sited that having ExcessHet
gatk SelectVariants\
 -R $reference_folder/$reference_fa\
 -V $target_ID.sca_all.vcf.gz\
 -select "${ExcessHet_param}"\
 -O $target_ID.ExcessHet.vcf

#Making bed file that marked ExcessHet block
perl $script_folder/Vcf2BED_chr_start_end.pl < $target_ID.ExcessHet.vcf | bedtools cluster -d 300 > $target_ID.ExcessHet.cluster.bed
perl $script_folder/ClusterBedBlock.pl < $target_ID.ExcessHet.cluster.bed > $target_ID.ExcessHet.block.bed

#=====================================================================
#filtering out ExcessHetblock: SNPs
gatk SelectVariants\
 -R $reference_folder/$reference_fa\
 -V $target_ID.nDNA.snp.vcf.gz\
 --exclude-intervals $target_ID.ExcessHet.block.bed\
 -O $target_ID.nDNA.snp.no_ExcessHetBlock.vcf.gz \

#filtering out ExcessHetblock: INDELs
gatk SelectVariants\
 -R $reference_folder/$reference_fa\
 -V $target_ID.nDNA.indel.vcf.gz\
 --exclude-intervals $target_ID.ExcessHet.block.bed\
 -O $target_ID.nDNA.indel.no_ExcessHetBlock.vcf.gz \


#=====================================================================
#filtering out elements detected by RepeatMasker: SNPs
gatk SelectVariants\
 -R $reference_folder/$reference_fa\
 -V $target_ID.nDNA.snp.no_ExcessHetBlock.vcf.gz\
 --exclude-intervals $repeatmasker_folder/aji230213.fa.out.gff.sca.three_col.sorted.bed\
 -O $target_ID.nDNA.snp.no_ExcessHetBlock_RM.vcf.gz \

#filtering out ExcessHetblock: INDELs
gatk SelectVariants\
 -R $reference_folder/$reference_fa\
 -V $target_ID.nDNA.indel.no_ExcessHetBlock.vcf.gz\
 --exclude-intervals $repeatmasker_folder/aji230213.fa.out.gff.sca.three_col.sorted.bed\
 -O $target_ID.nDNA.indel.no_ExcessHetBlock_RM.vcf.gz \


#=====================================================================


#=====================================================================
#Site-based filtering of SNPs
# FS filter shoud not apply for GRAS-Di data set
gatk VariantFiltration\
 -R $reference_folder/$reference_fa\
 -V $target_ID.nDNA.snp.no_ExcessHetBlock.vcf.gz \
 --filter-expression "QD < 2.0" --filter-name "QD2"\
 --filter-expression "MQ < 40.0" --filter-name "MQ40"\
 --filter-expression "MQRankSum < -12.5" --filter-name "MQRS_Nega12.5"\
 --filter-expression "ReadPosRankSum < -8.0" --filter-name "RPRS_Nega8"\
 --filter-expression "SOR > 4.0" --filter-name "SORgt4"\
 --filter-expression "${ExcessHet_param}" --filter-name "ExHet"\
 -O $target_ID.nDNA.snp.filter.vcf.gz

##Excluding filtered sites (including "PASS" or "." in FILTER filed) of SNPs
gatk SelectVariants\
 -R $reference_folder/$reference_fa\
 -V $target_ID.nDNA.snp.filter.vcf.gz\
 --exclude-filtered\
 -O $target_ID.nDNA.snp.filterPASSED.vcf.gz

#Site-based filtering of INDELs
gatk VariantFiltration\
 -R $reference_folder/$reference_fa\
 -V $target_ID.nDNA.indel.no_ExcessHetBlock.vcf.gz \
 --filter-expression "QD < 2.0" --filter-name "QD2"\
 --filter-expression "ReadPosRankSum < -20.0" --filter-name "RPRS_Nega20"\
 --filter-expression "SOR > 10.0" --filter-name "SOR10"\
 --filter-expression "${ExcessHet_param}" --filter-name "ExHet"\
 -O $target_ID.nDNA.indel.filter.vcf.gz

##Excluding filtered sites (including "PASS" or "." in FILTER filed) of INDELs
gatk SelectVariants\
 -R $reference_folder/$reference_fa\
 -V $target_ID.nDNA.indel.filter.vcf.gz\
 --exclude-filtered\
 -O $target_ID.nDNA.indel.filterPASSED.vcf.gz


#---------------------------------------------------------------------------------------------------------------
#Sample-based filtering out SNPs: DP < 20 & GQ <30
#GQ < 30: Low Genotype Quality: less than 99.9%
gatk VariantFiltration\
 -R $reference_folder/$reference_fa\
 -V $target_ID.nDNA.snp.filterPASSED.vcf.gz\
 -G-filter "GQ < 30"\
 -G-filter-name "GQ30"\
 -G-filter "DP < 20"\
 -G-filter-name "DP20"\
 -O $target_ID.nDNA.snp.DPfilterPASSED.vcf.gz

#Sample-based filtering out INDELs: DP < 20 & GQ < 30
#GQ < 30: Low Genotype Quality: less than 99.9%
gatk VariantFiltration\
 -R $reference_folder/$reference_fa\
 -V $target_ID.nDNA.indel.filterPASSED.vcf.gz\
 -G-filter "GQ < 30"\
 -G-filter-name "GQ30"\
 -G-filter "DP < 20"\
 -G-filter-name "DP20"\
 -O $target_ID.nDNA.indel.DPfilterPASSED.vcf.gz


#Set filtered sites to no call: SNPs
gatk SelectVariants\
 -R $reference_folder/$reference_fa\
 -V $target_ID.nDNA.snp.DPfilterPASSED.vcf.gz\
 --set-filtered-gt-to-nocall\
 -O $target_ID.nDNA.snp.DPfilterNoCall.vcf.gz

#Set filtered sites to no call: INDELs
gatk SelectVariants\
 -R $reference_folder/$reference_fa\
 -V $target_ID.nDNA.indel.DPfilterPASSED.vcf.gz\
 --set-filtered-gt-to-nocall\
 -O $target_ID.nDNA.indel.DPfilterNoCall.vcf.gz

#=====================================================================


cd $CURRENT_DIR

module unload gatk4/4.3.0.0

