#!/bin/bash -i
#Pipe.09.VariantFiltration.sh
#by HIRAO Akira

set -exuo pipefail

SCRIPT_DIR=$(cd $(dirname $0)  && pwd)

no_thread=64

reference_folder=/home/akihirao/work/Traja/RefGenome/RefGenome_v4
main_folder=/home/akihirao/work/Traja/Traja_GRASDi

target_ID=Traja_GRASDi_ref2_HardFiltered
output_folder=$main_folder/vcf_out_ref2_HardFiltered
mkdir -p $output_folder

cd $output_folder


#===============================================
#Filtering out mt
gatk SelectVariants\
 -R $reference_folder/agi.2.0.fa\
 -V $target_ID.sca_all.snp.vcf.gz\
 -XL $SCRIPT_DIR/mt.list\
 -O $target_ID.nDNA.snp.vcf.gz

gatk SelectVariants\
 -R $reference_folder/agi.2.0.fa\
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
gatk SelectVariants\
 -R $reference_folder/agi.2.0.fa\
 -V $target_ID.sca_all.vcf.gz\
 -select "${ExcessHet_param}"\
 -O $target_ID.ExcessHet.vcf

#Making bed file that marked ExcessHet block
perl $SCRIPT_DIR/Vcf2BED_chr_start_end.pl < $target_ID.ExcessHet.vcf | bedtools cluster -d 300 > $target_ID.ExcessHet.cluster.bed
perl $SCRIPT_DIR/ClusterBedBlock.pl < $target_ID.ExcessHet.cluster.bed > $target_ID.ExcessHet.block.bed

#=====================================================================
#filtering out ExcessHetblock:SNP
gatk SelectVariants\
 -R $reference_folder/agi.2.0.fa\
 -V $target_ID.nDNA.snp.vcf.gz\
 --exclude-intervals $target_ID.ExcessHet.block.bed\
 -O $target_ID.nDNA.snp.no_ExcessHetBlock.vcf.gz \

#Set filtered sites to no call:INDEL
gatk SelectVariants\
 -R $reference_folder/agi.2.0.fa\
 -V $target_ID.nDNA.indel.vcf.gz\
 --exclude-intervals $target_ID.ExcessHet.block.bed\
 -O $target_ID.nDNA.indel.no_ExcessHetBlock.vcf.gz \
#=====================================================================



#VariantFiltration for SNP
gatk VariantFiltration\
 -R $reference_folder/agi.2.0.fa\
 -V $target_ID.nDNA.snp.no_ExcessHetBlock.vcf.gz \
 --filter-expression "QD < 2.0" --filter-name "QDlt2"\
 --filter-expression "FS > 60.0" --filter-name "FSgt60"\
 --filter-expression "MQ < 40.0" --filter-name "MQlt40"\
 --filter-expression "MQRankSum < -12.5" --filter-name "MQRankSumltnegative12.5"\
 --filter-expression "ReadPosRankSum < -8.0" --filter-name "ReadPosRankSumltnegative8"\
 --filter-expression "SOR > 4.0" --filter-name "SORgt4"\
 --filter-expression "${ExcessHet_param}" --filter-name "ExHet"\
 -O $target_ID.nDNA.snp.filter.vcf

grep -E '^#|PASS' $target_ID.nDNA.snp.filter.vcf | bgzip > $target_ID.nDNA.snp.filterPASSED.vcf.gz
tabix -f -p vcf $target_ID.nDNA.snp.filterPASSED.vcf.gz


#VariantFiltration for INDEL
gatk VariantFiltration\
 -R $reference_folder/agi.2.0.fa\
 -V $target_ID.nDNA.indel.no_ExcessHetBlock.vcf.gz \
 --filter-expression "QD < 2.0" --filter-name "QDlt2"\
 --filter-expression "FS > 200.0" --filter-name "FSgt200"\
 --filter-expression "ReadPosRankSum < -20.0" --filter-name "RPRSltnagative20"\
 --filter-expression "SOR > 10.0" --filter-name "SORgt10"\
 --filter-expression "${ExcessHet_param}" --filter-name "ExHet"\
 -O $target_ID.nDNA.indel.filter.vcf

grep -E '^#|PASS' $target_ID.nDNA.indel.filter.vcf | bgzip > $target_ID.nDNA.indel.filterPASSED.vcf.gz
tabix -f -p vcf $target_ID.nDNA.indel.filterPASSED.vcf.gz


#---------------------------------------------------------------------------------------------------------------
#DepthFiltering for SNP: DP < 10 & GQ <20 (Low Genotype Quality: less than 99%)
gatk VariantFiltration\
 -R $reference_folder/agi.2.0.fa\
 -V $target_ID.nDNA.snp.filterPASSED.vcf.gz\
 -G-filter "GQ < 20"\
 -G-filter-name "lowGQ"\
 -G-filter "DP < 10"\
 -G-filter-name "DP_10"\
 -O $target_ID.nDNA.snp.DPfilterPASSED.vcf.gz

#DepthFiltering for INDEL: DP < 10 & GQ < 20 (Low Genotype Quality: less than 99%) 
gatk VariantFiltration\
 -R $reference_folder/agi.2.0.fa\
 -V $target_ID.nDNA.indel.filterPASSED.vcf.gz\
 -G-filter "GQ < 20"\
 -G-filter-name "lowGQ"\
 -G-filter "DP < 10"\
 -G-filter-name "DP_10"\
 -O $target_ID.nDNA.indel.DPfilterPASSED.vcf.gz

#Set filtered sites to no call:SNP
gatk SelectVariants\
 -R $reference_folder/agi.2.0.fa\
 -V $target_ID.nDNA.snp.DPfilterPASSED.vcf.gz\
 --set-filtered-gt-to-nocall\
 -O $target_ID.nDNA.snp.DPfilterNoCall.vcf.gz
bcftools index -f $target_ID.nDNA.snp.DPfilterNoCall.vcf.gz
bcftools view $target_ID.nDNA.snp.DPfilterNoCall.vcf.gz -Ov -o $target_ID.nDNA.snp.DPfilterNoCall.vcf

#Set filtered sites to no call:INDEL
gatk SelectVariants\
 -R $reference_folder/agi.2.0.fa\
 -V $target_ID.nDNA.indel.DPfilterPASSED.vcf.gz\
 --set-filtered-gt-to-nocall\
 -O $target_ID.nDNA.indel.DPfilterNoCall.vcf.gz
bcftools index -f $target_ID.nDNA.indel.DPfilterNoCall.vcf.gz
bcftools view $target_ID.nDNA.indel.DPfilterNoCall.vcf.gz -Ov -o $target_ID.nDNA.indel.DPfilterNoCall.vcf
#=====================================================================


#Merge SNPs and INDELs vcf files into a SNV vcf file
gatk MergeVcfs\
 -R $reference_folder/agi.2.0.fa\
 -I $target_ID.nDNA.snp.DPfilterNoCall.vcf.gz\
 -I $target_ID.nDNA.indel.DPfilterNoCall.vcf.gz\
 -O $target_ID.snp.indel.DPfilterNoCall.vcf.gz
bcftools index -f $target_ID.snp.indel.DPfilterNoCall.vcf.gz
bcftools view  $target_ID.snp.indel.DPfilterNoCall.vcf.gz -Ov -o  $target_ID.snp.indel.DPfilterNoCall.vcf


cd $SCRIPT_DIR

