#!/bin/bash
#Pipe.11.PlinkFiltering.sh
#by HIRAO Akira

set -exuo pipefail

CURRENT_DIR=$(cd $(dirname $0)  && pwd)

no_threads=24


#aji.3.1 (aji.3.1: reference genome); fasta header name = scax
code_ID="aji.3.1"

#aji.3.1.fa: the reference genoeme provided by Dr. Fujiwara @2023/2/13
reference_fa=aji.3.1.fa
reference_fa_head=aji.3.1
reference_folder=/home/$USER/work/Traja/RefGenome/RefGenome_v5.1
main_folder=/mnt/WD20/Traja/Traja_GRASDi
script_folder=$main_folder/Scripts
mkdir -p $script_folder/PCA_out


# gatk v.4.3.0.0
module load gatk4/4.3.0.0


target_ID=Traja_GRASDi_ref31
work_folder=$main_folder/vcf_out
vcf_folder=$main_folder/vcf_out
plink_folder=$main_folder/plink_filtering

mkdir -p $plink_folder

cd $plink_folder


#Convert from vcf to plink
vcftools --gzvcf $vcf_folder/$target_ID.nDNA.snp.DPfilterNoCall.non_rep.P99.vcf.gz\
 --plink --out $plink_folder/$target_ID.nDNA.snp


lab_99_filtering="99"
lab_95_filtering="95"
lab_90_filtering="90"
lab_80_filtering="80"
lab_70_filtering="70"
lab_60_filtering="60"
lab_50_filtering="50"


#mind 0.99 geno 0.99: removing >99% missing individuals and/or sites
plink --noweb --allow-extra-chr\
 --file $target_ID.nDNA.snp\
 --mind 0.99 --geno 0.99\
 --allow-no-sex\
 --out $target_ID.nDNA.snp.$lab_99_filtering\
 --recode

#mind 0.95 geno 0.95: removing >95% missing individuals and/or sites
plink --noweb --allow-extra-chr\
 --file $target_ID.nDNA.snp.$lab_99_filtering\
 --mind 0.95 --geno 0.95\
 --allow-no-sex\
 --out $target_ID.nDNA.snp.$lab_95_filtering\
 --recode

#mind 0.9 geno 0.9: removing >90% missing individuals and/or sites
plink --noweb --allow-extra-chr\
 --file $target_ID.nDNA.snp.$lab_95_filtering\
 --mind 0.90 --geno 0.90\
 --allow-no-sex\
 --out $target_ID.nDNA.snp.$lab_90_filtering\
 --recode

#mind 0.8 geno 0.8: removing >80% missing individuals and/or sites
plink --noweb --allow-extra-chr\
 --file $target_ID.nDNA.snp.$lab_90_filtering\
 --mind 0.80 --geno 0.80\
 --allow-no-sex\
 --out $target_ID.nDNA.snp.$lab_80_filtering\
 --recode

#mind 0.7 geno 0.7: removing >70% missing individuals and/or sites
plink --noweb --allow-extra-chr\
 --file $target_ID.nDNA.snp.$lab_80_filtering\
 --mind 0.70 --geno 0.70\
 --allow-no-sex\
 --out $target_ID.nDNA.snp.$lab_70_filtering\
 --recode

#mind 0.6 geno 0.6: removing >60% missing individuals and/or sites
plink --noweb --allow-extra-chr\
 --file $target_ID.nDNA.snp.$lab_70_filtering\
 --mind 0.60 --geno 0.60\
 --allow-no-sex\
 --out $target_ID.nDNA.snp.$lab_60_filtering\
 --recode

#mind 0.5 geno 0.5: removing >50% missing individuals and/or sites
plink --noweb --chr-set 24 no-xy no-mt\
 --file $target_ID.nDNA.snp.$lab_60_filtering\
 --mind 0.50 --geno 0.50\
 --allow-no-sex\
 --out $target_ID.nDNA.snp.$lab_50_filtering\
 --recode


perl $script_folder/PlinkMAP2BED.pl < $plink_folder/$target_ID.nDNA.snp.$lab_50_filtering.map > $plink_folder/$target_ID.nDNA.snp.$lab_50_filtering.bed
perl $script_folder/Select_ID_PED.pl < $plink_folder/$target_ID.nDNA.snp.$lab_50_filtering.ped > $script_folder/$target_ID.nDNA.snp.$lab_50_filtering.indiv.args

vcftools --gzvcf $vcf_folder/$target_ID.nDNA.snp.DPfilterNoCall.non_rep.P99.vcf.gz\
 --recode --recode-INFO-all --stdout --bed $plink_folder/$target_ID.nDNA.snp.$lab_50_filtering.bed --keep $script_folder/$target_ID.nDNA.snp.$lab_50_filtering.indiv.args --max-missing 0.9 > $vcf_folder/$target_ID.nDNA.snp.$lab_50_filtering.from_bed.vcf
bgzip -c $vcf_folder/$target_ID.nDNA.snp.$lab_50_filtering.from_bed.vcf > $vcf_folder/$target_ID.nDNA.snp.$lab_50_filtering.from_bed.vcf.gz
tabix -p vcf $vcf_folder/$target_ID.nDNA.snp.$lab_50_filtering.from_bed.vcf.gz

#Rename the full dataset including singleton
cp $vcf_folder/$target_ID.nDNA.snp.$lab_50_filtering.from_bed.vcf.gz $vcf_folder/$target_ID.nDNA.snp.singleton.vcf.gz
tabix -p vcf $vcf_folder//$target_ID.nDNA.snp.singleton.vcf.gz

#filtering out singletons
vcftools --gzvcf $vcf_folder/$target_ID.nDNA.snp.singleton.vcf.gz --singletons --stdout > $vcf_folder/$target_ID.nDNA.snp.singletons.txt
perl $script_folder/Singletons2BED.pl < $vcf_folder/$target_ID.nDNA.snp.singletons.txt > $vcf_folder/$target_ID.nDNA.snp.singletons.bed

vcftools --gzvcf $vcf_folder/$target_ID.nDNA.snp.singleton.vcf.gz\
 --recode --recode-INFO-all --stdout --exclude-bed $vcf_folder/$target_ID.nDNA.snp.singletons.bed > $vcf_folder/$target_ID.nDNA.snp.non_singleton.vcf
bgzip -c $vcf_folder/$target_ID.nDNA.snp.non_singleton.vcf > $vcf_folder/$target_ID.nDNA.snp.non_singleton.vcf.gz
tabix -p vcf $vcf_folder/$target_ID.nDNA.snp.non_singleton.vcf.gz


##Performing PCA: non-singleton
plink --vcf $vcf_folder/$target_ID.nDNA.snp.non_singleton.vcf.gz\
  --allow-extra-chr\
  --pca --out $script_folder/PCA_out/$target_ID.nDNA.snp.non_singleton

#filtering out MAF < 0.01
vcftools --gzvcf $vcf_folder/$target_ID.nDNA.snp.non_singleton.vcf.gz --maf 0.01 --recode --recode-INFO-all --stdout > $vcf_folder/$target_ID.nDNA.snp.maf001.vcf
bgzip -c $vcf_folder/$target_ID.nDNA.snp.maf001.vcf > $vcf_folder/$target_ID.nDNA.snp.maf001.vcf.gz
tabix -p vcf $vcf_folder/$target_ID.nDNA.snp.maf001.vcf.gz


##Performing PCA: MAF >= 0.01
plink --vcf $vcf_folder/$target_ID.nDNA.snp.maf001.vcf.gz\
  --allow-extra-chr\
  --pca --out $script_folder/PCA_out/$target_ID.nDNA.snp.maf001

#Convetion from vcf to plink ped/map
vcftools --vcf $vcf_folder/$target_ID.nDNA.snp.maf001.vcf\
 --plink --out $plink_folder/$target_ID.nDNA.snp.maf001


#LD-pruning
plink2 --allow-extra-chr\
 --vcf $vcf_folder/$target_ID.nDNA.snp.maf001.vcf\
 --indep-pairwise 100 kb 1 0.1 --set-all-var-ids @:#\
 --out $vcf_folder/$target_ID.nDNA.snp.maf001


#convert from LD-prune.in to BED
perl $script_folder/LDpruned2BED.pl < $vcf_folder/$target_ID.nDNA.snp.maf001.prune.in > $plink_folder/$target_ID.nDNA.snp.maf001.LDpruned.bed

gatk SelectVariants\
 -R $reference_folder/$reference_fa\
 -V $vcf_folder/$target_ID.nDNA.snp.DPfilterNoCall.non_rep.P99.vcf.gz\
 --sample-name $script_folder/$target_ID.nDNA.snp.$lab_50_filtering.indiv.args\
 -L $plink_folder/$target_ID.nDNA.snp.maf001.LDpruned.bed\
 -O $vcf_folder/$target_ID.nDNA.snp.maf001.LDpruned.vcf.gz

#replicate samples for calculateing a genotyping error rate
gatk SelectVariants\
 -R $reference_folder/$reference_fa\
 -V $vcf_folder/$target_ID.nDNA.snp.DPfilterNoCall.vcf.gz\
 --sample-name $script_folder/rep_sample_ID.list\
 -L $plink_folder/$target_ID.nDNA.snp.maf001.LDpruned.bed\
 -O $vcf_folder/$target_ID.nDNA.snp.maf001.LDpruned.replicates.vcf.gz


##Performing PCA: LD-pruned
plink --vcf $vcf_folder/$target_ID.nDNA.snp.maf001.LDpruned.vcf.gz\
  --allow-extra-chr\
  --pca --out $script_folder/PCA_out/$target_ID.nDNA.snp.maf001.LDpruned

#Convertion into *thaw format for analysis using the package "smartsnp" in the R
plink2 --vcf $vcf_folder/$target_ID.nDNA.snp.maf001.LDpruned.vcf.gz\
  --allow-extra-chr\
  --recode A-transpose --out $vcf_folder/$target_ID.nDNA.snp.maf001.LDpruned.genotypeMatrix

cd $CURRENT_DIR

module unload gatk4/4.3.0.0

