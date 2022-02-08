#!/bin/bash
#Pipe.11.PlinkFiltering.sh
#by HIRAO Akira

set -exuo pipefail

SCRIPT_DIR=$(cd $(dirname $0)  && pwd)

no_threads=48

#input your account name
user_name=akihirao

reference_fa=agi.2.0.fa
reference_folder=/home/$user_name/work/Traja/RefGenome/RefGenome_v4
main_folder=/home/$user_name/work/Traja/Traja_GRASDi

#set path to gatk ver.4.2.0.0
gatk_folder=/home/$user_name/local/gatk-4.2.0.0


target_ID=Traja_GRASDi_ref2_rev1
work_folder=$main_folder/vcf_out_ref2_rev1
vcf_folder=$main_folder/vcf_out_ref2_rev1
plink_folder=$main_folder/plink_filtering_rev1

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
plink --noweb --allow-extra-chr\
 --file $target_ID.nDNA.snp.$lab_60_filtering\
 --mind 0.50 --geno 0.50\
 --allow-no-sex\
 --out $target_ID.nDNA.snp.$lab_50_filtering\
 --recode


perl $SCRIPT_DIR/PlinkMAP2BED.pl < $plink_folder/$target_ID.nDNA.snp.$lab_50_filtering.map > $plink_folder/$target_ID.nDNA.snp.$lab_50_filtering.bed
perl $SCRIPT_DIR/Select_ID_PED.pl < $plink_folder/$target_ID.nDNA.snp.$lab_50_filtering.ped > $SCRIPT_DIR/$target_ID.nDNA.snp.$lab_50_filtering.indiv.args

vcftools --gzvcf $vcf_folder/$target_ID.nDNA.snp.DPfilterNoCall.non_rep.P99.vcf.gz\
 --recode --recode-INFO-all --stdout --bed $plink_folder/$target_ID.nDNA.snp.$lab_50_filtering.bed --keep $SCRIPT_DIR/$target_ID.nDNA.snp.$lab_50_filtering.indiv.args --max-missing 0.9 > $vcf_folder/$target_ID.nDNA.snp.$lab_50_filtering.from_bed.vcf
bgzip -c $vcf_folder/$target_ID.nDNA.snp.$lab_50_filtering.from_bed.vcf > $vcf_folder/$target_ID.nDNA.snp.$lab_50_filtering.from_bed.vcf.gz
tabix -p vcf $vcf_folder/$target_ID.nDNA.snp.$lab_50_filtering.from_bed.vcf.gz


#filtering out singletons
vcftools --gzvcf $vcf_folder/$target_ID.nDNA.snp.$lab_50_filtering.from_bed.vcf.gz --singletons --stdout > $vcf_folder/$target_ID.nDNA.snp.$lab_50_filtering.from_bed.singletons.txt
perl $SCRIPT_DIR/Singletons2BED.pl < $vcf_folder/$target_ID.nDNA.snp.$lab_50_filtering.from_bed.singletons.txt > $vcf_folder/$target_ID.nDNA.snp.$lab_50_filtering.from_bed.singletons.bed

vcftools --gzvcf $vcf_folder/$target_ID.nDNA.snp.$lab_50_filtering.from_bed.vcf.gz\
 --recode --recode-INFO-all --stdout --exclude-bed $vcf_folder/$target_ID.nDNA.snp.$lab_50_filtering.from_bed.singletons.bed > $vcf_folder/$target_ID.nDNA.snp.$lab_50_filtering.non_singleton.vcf
bgzip -c $vcf_folder/$target_ID.nDNA.snp.$lab_50_filtering.non_singleton.vcf > $vcf_folder/$target_ID.nDNA.snp.$lab_50_filtering.non_singleton.vcf.gz
tabix -p vcf $vcf_folder/$target_ID.nDNA.snp.$lab_50_filtering.non_singleton.vcf.gz

##Performing PCA: LD-pruned
plink --vcf $vcf_folder/$target_ID.nDNA.snp.$lab_50_filtering.non_singleton.vcf.gz\
 --allow-extra-chr --pca --out $target_ID.nDNA.snp.$lab_50_filtering.non_singleton


#filtering out MAF < 0.01
vcftools --gzvcf $vcf_folder/$target_ID.nDNA.snp.$lab_50_filtering.non_singleton.vcf.gz --maf 0.01 --recode --recode-INFO-all --stdout > $vcf_folder/$target_ID.nDNA.snp.maf001.vcf
bgzip -c $vcf_folder/$target_ID.nDNA.snp.maf001.vcf > $vcf_folder/$target_ID.nDNA.snp.maf001.vcf.gz
tabix -p vcf $vcf_folder/$target_ID.nDNA.snp.maf001.vcf.gz

##Performing PCA: MAF < 0.01
plink --vcf $vcf_folder/$target_ID.nDNA.snp.maf001.vcf.gz\
 --allow-extra-chr --pca --out $target_ID.nDNA.snp.maf001

#Convetion from vcf to plink ped/map
vcftools --vcf $vcf_folder/$target_ID.nDNA.snp.maf001.vcf\
 --plink --out $plink_folder/$target_ID.nDNA.snp.$lab_50_filtering.maf001


#LD-pruning
plink2 --allow-extra-chr\
 --vcf $vcf_folder/$target_ID.nDNA.snp.maf001.vcf\
 --indep-pairwise 100 kb 1 0.1 --set-all-var-ids @:#\
 --out $vcf_folder/$target_ID.nDNA.snp.maf001


#convert from LD-prune.in to BED
perl $SCRIPT_DIR/LDpruned2BED.pl < $vcf_folder/$target_ID.nDNA.snp.maf001.prune.in > $plink_folder/$target_ID.nDNA.snp.maf001.LDpruned.bed

$gatk_folder/gatk SelectVariants\
 -R $reference_folder/$reference_fa\
 -V $vcf_folder/$target_ID.nDNA.snp.DPfilterNoCall.non_rep.P99.vcf.gz\
 --sample-name $SCRIPT_DIR/$target_ID.nDNA.snp.$lab_50_filtering.indiv.args\
 -L $plink_folder/$target_ID.nDNA.snp.maf001.LDpruned.bed\
 -O $vcf_folder/$target_ID.nDNA.snp.maf001.LDpruned.vcf.gz

##Performing PCA: LD-pruned
plink --vcf $vcf_folder/$target_ID.nDNA.snp.maf001.LDpruned.vcf.gz\
 --allow-extra-chr --pca --out $target_ID.nDNA.snp.maf001.LDpruned

#Convertion into *thaw format for analysis using the package "smartsnp" in the R
plink2 --vcf $vcf_folder/$target_ID.nDNA.snp.maf001.LDpruned.vcf.gz --allow-extra-chr --recode A-transpose --out $vcf_folder/$target_ID.nDNA.snp.maf001.LDpruned.genotypeMatrix

cd $SCRIPT_DIR


