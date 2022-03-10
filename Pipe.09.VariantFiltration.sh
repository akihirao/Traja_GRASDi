#!/bin/bash
#Pipe.09.VariantFiltration.sh
#by HIRAO Akira

set -exuo pipefail

CURRENT_DIR=$(cd $(dirname $0)  && pwd)

no_threads=48

#input your account name
user_name=akihirao

#agi.2.0.rev2 (agi.2.0: reference genome; rev2: pair-end merge reads)
code_ID="agi.2.0.rev2"

reference_fa=agi.2.0.fa
reference_folder=/home/$user_name/work/Traja/RefGenome/RefGenome_v4
main_folder=/home/$user_name/work/Traja/Traja_GRASDi
script_folder=$main_folder/Scripts

#set path to gatk ver.4.2.0.0
gatk_folder=/home/$user_name/local/gatk-4.2.0.0


target_ID=Traja_GRASDi_ref2_rev2
output_folder=$main_folder/vcf_out_ref2_rev2
mkdir -p $output_folder

cd $output_folder


#===============================================
#Filtering out mt
$gatk_folder/gatk SelectVariants\
 -R $reference_folder/$reference_fa\
 -V $target_ID.sca_all.snp.vcf.gz\
 -XL $SCRIPT_DIR/mt.list\
 -O $target_ID.nDNA.snp.vcf.gz

$gatk_folder/gatk SelectVariants\
 -R $reference_folder/$reference_fa\
 -V $target_ID.sca_all.indel.vcf.gz\
 -XL $SCRIPT_DIR/mt.list\
 -O $target_ID.nDNA.indel.vcf.gz
#===============================================
 
 
#defining ExcessHet parameter
#"ExcessHet > 13.0" means excess of heterozygosity with p value 0.05 
ExcessHet_P=0.05
ExcessHet_Q=`echo "scale=5; -10 * l($ExcessHet_P) /l(10)" |bc -l | xargs printf %.1f`
ExcessHet_param="ExcessHet > ${ExcessHet_Q}"

echo $ExcessHet_param


#Making select sited that having ExcessHet
$gatk_folder/gatk SelectVariants\
 -R $reference_folder/$reference_fa\
 -V $target_ID.sca_all.vcf.gz\
 -select "${ExcessHet_param}"\
 -O $target_ID.ExcessHet.vcf

#Making bed file that marked ExcessHet block
perl $script_folder/Vcf2BED_chr_start_end.pl < $target_ID.ExcessHet.vcf | bedtools cluster -d 300 > $target_ID.ExcessHet.cluster.bed
perl $script_folder/ClusterBedBlock.pl < $target_ID.ExcessHet.cluster.bed > $target_ID.ExcessHet.block.bed

#=====================================================================
#filtering out ExcessHetblock:SNP
$gatk_folder/gatk SelectVariants\
 -R $reference_folder/$reference_fa\
 -V $target_ID.nDNA.snp.vcf.gz\
 --exclude-intervals $target_ID.ExcessHet.block.bed\
 -O $target_ID.nDNA.snp.no_ExcessHetBlock.vcf.gz \

#Set filtered sites to no call:INDEL
$gatk_folder/gatk SelectVariants\
 -R $reference_folder/$reference_fa\
 -V $target_ID.nDNA.indel.vcf.gz\
 --exclude-intervals $target_ID.ExcessHet.block.bed\
 -O $target_ID.nDNA.indel.no_ExcessHetBlock.vcf.gz \
#=====================================================================



#Site-based filtering of SNPs
$gatk_folder/gatk VariantFiltration\
 -R $reference_folder/$reference_fa\
 -V $target_ID.nDNA.snp.no_ExcessHetBlock.vcf.gz \
 --filter-expression "QD < 2.0" --filter-name "QD2"\
 --filter-expression "FS > 60.0" --filter-name "FS60"\
 --filter-expression "MQ < 40.0" --filter-name "MQ40"\
 --filter-expression "MQRankSum < -12.5" --filter-name "MQRS_Nega12.5"\
 --filter-expression "ReadPosRankSum < -8.0" --filter-name "RPRS_Nega8"\
 --filter-expression "SOR > 4.0" --filter-name "SORgt4"\
 --filter-expression "${ExcessHet_param}" --filter-name "ExHet"\
 -O $target_ID.nDNA.snp.filter.vcf.gz

##Excluding filtered sites (including "PASS" or "." in FILTER filed) of SNPs
$gatk_folder/gatk SelectVariants\
 -R $reference_folder/$reference_fa\
 -V $target_ID.nDNA.snp.filter.vcf.gz\
 --exclude-filtered\
 -O $target_ID.nDNA.snp.filterPASSED.vcf.gz

#Site-based filtering of INDELs
$gatk_folder/gatk VariantFiltration\
 -R $reference_folder/$reference_fa\
 -V $target_ID.nDNA.indel.no_ExcessHetBlock.vcf.gz \
 --filter-expression "QD < 2.0" --filter-name "QD2"\
 --filter-expression "FS > 200.0" --filter-name "FS200"\
 --filter-expression "ReadPosRankSum < -20.0" --filter-name "RPRS_Nega20"\
 --filter-expression "SOR > 10.0" --filter-name "SOR10"\
 --filter-expression "${ExcessHet_param}" --filter-name "ExHet"\
 -O $target_ID.nDNA.indel.filter.vcf.gz

##Excluding filtered sites (including "PASS" or "." in FILTER filed) of INDELs
$gatk_folder/gatk SelectVariants\
 -R $reference_folder/$reference_fa\
 -V $target_ID.nDNA.indel.filter.vcf.gz\
 --exclude-filtered\
 -O $target_ID.nDNA.indel.filterPASSED.vcf.gz


#---------------------------------------------------------------------------------------------------------------
#Sample-based filtering of SNPs: DP < 10 & GQ <20 (Low Genotype Quality: less than 99%)
$gatk_folder/gatk VariantFiltration\
 -R $reference_folder/$reference_fa\
 -V $target_ID.nDNA.snp.filterPASSED.vcf.gz\
 -G-filter "GQ < 20"\
 -G-filter-name "lowGQ"\
 -G-filter "DP < 10"\
 -G-filter-name "DP_10"\
 -O $target_ID.nDNA.snp.DPfilterPASSED.vcf.gz

#Sample-based filtering of INDELs: DP < 10 & GQ < 20 (Low Genotype Quality: less than 99%) 
$gatk_folder/gatk VariantFiltration\
 -R $reference_folder/$reference_fa\
 -V $target_ID.nDNA.indel.filterPASSED.vcf.gz\
 -G-filter "GQ < 20"\
 -G-filter-name "lowGQ"\
 -G-filter "DP < 10"\
 -G-filter-name "DP_10"\
 -O $target_ID.nDNA.indel.DPfilterPASSED.vcf.gz

#Set filtered sites to no call:SNP
$gatk_folder/gatk SelectVariants\
 -R $reference_folder/$reference_fa\
 -V $target_ID.nDNA.snp.DPfilterPASSED.vcf.gz\
 --set-filtered-gt-to-nocall\
 -O $target_ID.nDNA.snp.DPfilterNoCall.vcf.gz
bcftools index -f $target_ID.nDNA.snp.DPfilterNoCall.vcf.gz
bcftools view $target_ID.nDNA.snp.DPfilterNoCall.vcf.gz -Ov -o $target_ID.nDNA.snp.DPfilterNoCall.vcf

#Set filtered sites to no call:INDEL
$gatk_folder/gatk SelectVariants\
 -R $reference_folder/$reference_fa\
 -V $target_ID.nDNA.indel.DPfilterPASSED.vcf.gz\
 --set-filtered-gt-to-nocall\
 -O $target_ID.nDNA.indel.DPfilterNoCall.vcf.gz
bcftools index -f $target_ID.nDNA.indel.DPfilterNoCall.vcf.gz
bcftools view $target_ID.nDNA.indel.DPfilterNoCall.vcf.gz -Ov -o $target_ID.nDNA.indel.DPfilterNoCall.vcf
#=====================================================================


#Merge SNPs and INDELs vcf files into a SNV vcf file
$gatk_folder/gatk MergeVcfs\
 -R $reference_folder/$reference_fa\
 -I $target_ID.nDNA.snp.DPfilterNoCall.vcf.gz\
 -I $target_ID.nDNA.indel.DPfilterNoCall.vcf.gz\
 -O $target_ID.snp.indel.DPfilterNoCall.vcf.gz
bcftools index -f $target_ID.snp.indel.DPfilterNoCall.vcf.gz
bcftools view  $target_ID.snp.indel.DPfilterNoCall.vcf.gz -Ov -o  $target_ID.snp.indel.DPfilterNoCall.vcf


cd $CURRENT_DIR

