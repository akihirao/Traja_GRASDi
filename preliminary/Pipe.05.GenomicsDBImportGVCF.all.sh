#!/bin/bash
#Pipe.05.GenomicsDBImportGVCF.sh
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


target_ID=Traja_GRASDi_ref31
output_folder=$main_folder/gDB
lab_under_bar="_"
mkdir -p $output_folder


cd $output_folder

#genomicsDB_name=genomicsDB.$target_ID$lab_under_bar$chr
genomicsDB_name=genomicsDB.$target_ID
DB_path=$output_folder/$genomicsDB_name

gatk GenomicsDBImport\
 $input_samples\
 --genomicsdb-workspace-path  $DB_path\
 --intervals $script_folder/Traja.aji.3.1.Chr.list\
 --reader-threads $no_threads


cd $CURRENT_DIR

module unload gatk4/4.3.0.0

