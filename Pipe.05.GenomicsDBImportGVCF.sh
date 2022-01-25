#!/bin/bash
#Pipe.05.GenomicsDBImportGVCF.sh
#by HIRAO Akira

set -exuo pipefail

SCRIPT_DIR=$(cd $(dirname $0)  && pwd)

no_threads=64

#input your account name
user_name=akihirao

reference_fa=agi.2.0.fa
reference_folder=/home/$user_name/work/Traja/RefGenome/RefGenome_v4
main_folder=/home/$user_name/work/Traja/Traja_GRASDi

#set path to gatk ver.4.2.0.0
gatk_folder=/home/$user_name/local/gatk-4.2.0.0

#-----------------------------------------------------
# defining argument of samples for GenomicsDBImports
input_samples=""
option_lab="-V "
gvcf_lab=".agi.2.0.rev1.g.vcf.gz"
one_space=" "
slash_lab="/"

while read sample; do

	echo $sample
	gvcf_folder=$main_folder/bwa_out/$sample$slash_lab
		
	input_samples=$input_samples$option_lab$gvcf_folder$sample$gvcf_lab$one_space

done < $SCRIPT_DIR/sample_ID.A0001_A0646.list #1st + 2nd samples

echo $input_samples

#-----------------------------------------------------


target_ID=Traja_GRASDi_ref2_rev1
output_folder=$main_folder/gDB
lab_under_bar="_"
mkdir -p $output_folder


cd $output_folder


while read chr; do

	genomicsDB_name=genomicsDB.$target_ID$lab_under_bar$chr
	DB_path=$output_folder/$genomicsDB_name

	$gatk_folder/gatk GenomicsDBImport\
	 $input_samples\
	 --genomicsdb-workspace-path  $DB_path\
	 --intervals $chr\
	 --reader-threads $no_threads

done < $SCRIPT_DIR/Traja.agi.2.0.Chr.list


cd $SCRIPT_DIR

