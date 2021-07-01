#!/bin/bash -i
#Pipe.09.PlinkFiltering.sh
#by HIRAO Akira

set -exuo pipefail

SCRIPT_DIR=$(cd $(dirname $0)  && pwd)

no_thread=128

reference_folder=/home/akihirao/work/Traja/RefGenome/RefGenome_v2
main_folder=/home/akihirao/work/Traja/Traja_GRASDi

target_ID=Traja_GRASDi_2019_2020
work_folder=$main_folder/vcf_out_2019_2020
vcf_folder=$main_folder/vcf_out_2019_2020
plink_folder=$main_folder/plink_filtering

mkdir -p $plink_folder

cd $plink_folder

<< CUT1
#Convert from vcf to plink
vcftools --gzvcf $vcf_folder/$target_ID.sca1_24.snp.DPfilterNoCall.non_rep.P99.vcf.gz\
 --plink --out $plink_folder/$target_ID.sca1_24.snp
CUT1


lab_99_filtering="99"
lab_95_filtering="95"
lab_90_filtering="90"
lab_80_filtering="80"
lab_70_filtering="70"
lab_60_filtering="60"
lab_50_filtering="50"

<< CUT2
#mind 0.99 geno 0.99: removing >99% missing individuals and/or sites
plink --noweb --allow-extra-chr\
 --file $target_ID.sca1_24.snp\
 --mind 0.99 --geno 0.99\
 --allow-no-sex\
 --out $target_ID.sca1_24.snp.$lab_99_filtering\
 --recode

#mind 0.95 geno 0.95: removing >95% missing individuals and/or sites
plink --noweb --allow-extra-chr\
 --file $target_ID.sca1_24.snp.$lab_99_filtering\
 --mind 0.95 --geno 0.95\
 --allow-no-sex\
 --out $target_ID.sca1_24.snp.$lab_95_filtering\
 --recode

#mind 0.9 geno 0.9: removing >90% missing individuals and/or sites
plink --noweb --allow-extra-chr\
 --file $target_ID.sca1_24.snp.$lab_95_filtering\
 --mind 0.90 --geno 0.90\
 --allow-no-sex\
 --out $target_ID.sca1_24.snp.$lab_90_filtering\
 --recode

#mind 0.8 geno 0.8: removing >80% missing individuals and/or sites
plink --noweb --allow-extra-chr\
 --file $target_ID.sca1_24.snp.$lab_90_filtering\
 --mind 0.80 --geno 0.80\
 --allow-no-sex\
 --out $target_ID.sca1_24.snp.$lab_80_filtering\
 --recode

#mind 0.7 geno 0.7: removing >70% missing individuals and/or sites
plink --noweb --allow-extra-chr\
 --file $target_ID.sca1_24.snp.$lab_80_filtering\
 --mind 0.70 --geno 0.70\
 --allow-no-sex\
 --out $target_ID.sca1_24.snp.$lab_70_filtering\
 --recode

#mind 0.6 geno 0.6: removing >60% missing individuals and/or sites
plink --noweb --allow-extra-chr\
 --file $target_ID.sca1_24.snp.$lab_70_filtering\
 --mind 0.60 --geno 0.60\
 --allow-no-sex\
 --out $target_ID.sca1_24.snp.$lab_60_filtering\
 --recode

#mind 0.5 geno 0.5: removing >50% missing individuals and/or sites
plink --noweb --allow-extra-chr\
 --file $target_ID.sca1_24.snp.$lab_60_filtering\
 --mind 0.50 --geno 0.50\
 --allow-no-sex\
 --out $target_ID.sca1_24.snp.$lab_50_filtering\
 --recode

CUT2


perl $SCRIPT_DIR/PlinkMAP2BED.pl < $plink_folder/$target_ID.sca1_24.snp.$lab_50_filtering.map > $plink_folder/$target_ID.sca1_24.snp.$lab_50_filtering.bed
perl $SCRIPT_DIR/scripts/Select_ID_PED.pl < $plink_folder/$target_ID.sca1_24.snp.$lab_50_filtering > $SCRIPT_DIR/$target_ID.sca1_24.snp.$lab_50_filtering.indiv.args
cat $SCRIPT_DIR/$target_ID.sca1_24.snp.$lab_50_filtering.indiv.args $SCRIPT_DIR/$target_ID.LabelRepetation.args\
 | sort $target_ID.sca1_24.snp.maf001.indiv.concatenate.args\
 | uniq -u > $target_ID.sca1_24.snp.maf001.indiv.extract_out.args

vcftools --gzvcf $vcf_folder/$target_ID.sca1_24.snp.DPfilterNoCall.non_rep.P99.vcf.gz\
 --recode --recode-INFO-all --stdout --bed $plink_folder/$target_ID.sca1_24.snp.$lab_50_filtering.bed --max-missing 0.9 > $target_ID.sca1_24.snp.$lab_50_filtering.from_bed.vcf


##<< COMMENTOUT
#filtering out MAF < 0.01
vcftools --vcf $vcf_folder/$target_ID.sca1_24.snp.$lab_50_filtering.from_bed.vcf --maf 0.01 --recode --recode-INFO-all --stdout > $vcf_folder/$target_IDsnp.maf001.vcf
bgzip -c $vcf_folder/$target_ID.snp.maf001.vcf > $vcf_folder/$target_IDsnp.maf001.vcf.gz
tabix -p vcf $vcf_folder/$target_IDsnp.maf001.vcf.gz

#Convering from vcf to plink ped/map
vcftools --vcf $vcf_folder/$target_ID.snp.maf001.vcf\
 --plink --out $plink_folder/$target_ID.snp.$lab_50_filtering.maf001

#LD-pruning
plink2 --allow-extra-chr\
 --vcf $vcf_folder/$target_ID.snp.maf001.vcf\
 --indep-pairwise 100 kb 1 0.1 --set-all-var-ids @:#\
 --out $vcf_folder/$target_ID.snp.maf001.prune.in

#convert from LD-prune.in to BED
perl $SCRIPT_DIR/LDpruned2BED.pl < $vcf_folder/$target_ID.snp.maf001.prune.in > $plink_folder/$target_ID.snp.maf001.LDpruned.bed
gatk SelectVariants\
 -R $reference_folder/agi1.2.fa\
 -V $vcf_folder/$target_ID.sca1_24.snp.DPfilterNoCall.non_rep.P99.vcf.gz\
 --sample-name $target_ID.sca1_24.snp.maf001.indiv.extract_out.args\
 -L $plink_folder/$target_ID.snp.maf001.LDpruned.bed\
 -O $vcf_folder/$target_ID.snp.maf001.LDpruned.vcf


##COMMENTOUT


cd $SCRIPT_DIR

