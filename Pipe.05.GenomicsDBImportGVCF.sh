#!/bin/bash
#Pipe.05.GenomicsDBImportGVCF.sh
#by HIRAO Akira

set -exuo pipefail

CURRENT_DIR=$(cd $(dirname $0)  && pwd)

no_threads=8


#agi.2.0.rev2 (agi.2.0: reference genome; rev2: pair-end merge reads)
code_ID="agi.2.0.rev2"

reference_fa=agi.2.0.fa
reference_folder=/home/$USER/work/Traja/RefGenome/RefGenome_v4
main_folder=/mnt/WD20/Traja/Traja_GRASDi
script_folder=$main_folder/Scripts
bwa_folder=$main_folder/bwa_out

module load gatk4/4.3.0.0

#-----------------------------------------------------
# defining argument of samples for GenomicsDBImports
input_samples=""
option_lab="-V "
gvcf_lab="."$code_ID".g.vcf.gz"
one_space=" "
slash_lab="/"

while read sample; do

	echo $sample
	gvcf_folder=$bwa_folder/$sample$slash_lab
		
	input_samples=$input_samples$option_lab$gvcf_folder$sample$gvcf_lab$one_space

done < $script_folder/sample_ID.A0001_A0646.list #1st + 2nd samples

echo $input_samples

#-----------------------------------------------------


target_ID=Traja_GRASDi_ref2_rev2
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

done < $script_folder/Traja.agi.2.0.Chr.list


cd $CURRENT_DIR

module unload gatk4

