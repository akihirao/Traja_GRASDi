#!/bin/bash
#Pipe.04.HaplotypeCaller.sh
#by HIRAO Akira

set -exuo pipefail

CURRENT_DIR=$(cd $(dirname $0)  && pwd)

no_threads=8

#aji.3.1 (aji.3.1: reference genome); fasta header name = scax
code_ID="aji.3.1"

#aji.3.1.fa: the reference genoeme provided by Dr. Fujiwara @2023/2/13
reference_fa=aji.3.1.fa
reference_fa_head=aji.3.1
reference_folder=/home/$USER/work/Traja/RefGenome/RefGenome_v5.1
main_folder=/mnt/WD20/Traja/Traja_GRASDi
script_folder=$main_folder/Scripts
bwa_folder=$main_folder/bwa_out

#samtools 1.16.1
#Using htslib 1.16.1

#gatk 4.3.0.0
#switch gatk ver.4.3.0.0
module load gatk4/4.3.0.0


while read sample; do

	work_folder=$bwa_folder/$sample
	cd $work_folder

	gatk HaplotypeCaller\
	 -R $reference_folder/$reference_fa\
	 -I $sample.$code_ID.filteredDup.bam\
	 --emit-ref-confidence GVCF\
	 --bam-output $sample.$code_ID.hpcall.bam\
	 --native-pair-hmm-threads $no_threads\
	 -O $sample.$code_ID.g.vcf.gz

#done < $script_folder/sample_ID.A0001_A0646.list #list of MIDs
done < $script_folder/sample_ID.A0601_A0646.list #list of MIDs


cd $CURRENT_DIR

module unload gatk4/4.3.0.0

