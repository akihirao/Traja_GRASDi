#!/bin/bash
#Pipe.05.GenotypeGVCF.sca2_sca3.sh
#by HIRAO Akira

set -exuo pipefail

SCRIPT_DIR=$(cd $(dirname $0)  && pwd)

no_thread=128

reference_folder=/home/akihirao/work/Traja/RefGenome/RefGenome_v2
main_folder=/home/akihirao/work/Traja/Traja_GRASDi



target_ID=Traja_GRASDi
output_folder=$main_folder/vcf_out
mkdir -p $output_folder

genomicsDB_name=genomicsDB.$target_ID
DB_path=$main_folder/gDB/$genomicsDB_name


cd $output_folder

gatk GenotypeGVCFs \
-R $reference_folder/agi1.2.fa \
-V gendb://$DB_path \
-L $SCRIPT_DIR/sca2_sca3.list \
-O $output_folder/$target_ID.sca2_sca3.vcf.gz

cd $SCRIPT_DIR