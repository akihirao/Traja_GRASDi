#!/bin/bash
#Pipe.04.GenomicsDBImportGVCF.2019.2020.YearClass.chr.sh
#by HIRAO Akira

set -exuo pipefail

SCRIPT_DIR=$(cd $(dirname $0)  && pwd)

no_thread=128

reference_folder=/home/akihirao/work/Traja/RefGenome/RefGenome_v2
main_folder=/home/akihirao/work/Traja/Traja_GRASDi

no_sample=646

#-----------------------------------------------------
# defining argument of samples for GenomicsDBImports
input_samples=""
option_lab="-V "
gvcf_lab=".agi1.2.g.vcf.gz"
one_space=" "
slash_lab="/"

while read sample; do

	echo $sample
	gvcf_folder=$main_folder/bwa_out/$sample$slash_lab
		
	input_samples=$input_samples$option_lab$gvcf_folder$sample$gvcf_lab$one_space

done < $SCRIPT_DIR/sample_ID.A0001_A0646.list #list of samples

echo $input_samples

#-----------------------------------------------------


target_ID=Traja_GRASDi_2019_2020
output_folder=$main_folder/gDB
lab_under_bar="_"
mkdir -p $output_folder



cd $output_folder


while read chr; do

	genomicsDB_name=genomicsDB.$target_ID$lab_under_bar$chr


	DB_path=$output_folder/$genomicsDB_name

	gatk GenomicsDBImport\
	 $input_samples\
	 --genomicsdb-workspace-path  $DB_path\
	 --intervals $chr\
	 --reader-threads $no_thread

done < $SCRIPT_DIR/Traja.agi1.2.Chr.list


cd $SCRIPT_DIR

