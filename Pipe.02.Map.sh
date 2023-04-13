#!/bin/bash
#Pipe.02.Map.sh
#by HIRAO Akira

set -exuo pipefail

CURRENT_DIR=$(cd $(dirname $0)  && pwd)

no_threads=32


#aji.3.1 (aji.3.1: reference genome); fasta header name = scax
code_ID="aji.3.1"

#aji.3.1.fa: the reference genoeme provided by Dr. Fujiwara @2023/2/13
reference_fa=aji.3.1.fa
reference_fa_head=aji.3.1
reference_folder=/home/$USER/work/Traja/RefGenome/RefGenome_v5.1
main_folder=/mnt/WD20/Traja/Traja_GRASDi
script_folder=$main_folder/Scripts
QC_folder=$main_folder/Traja_QCData_GRASDi


R1_tag="_R1"
R2_tag="_R2"

#bwa (Version: 0.7.17-r1198-dirty)
#bwa-mem2 v2.2.1
#samtools 1.16.1
#Using htslib 1.16.1

#gatk 4.3.0.0
#switch gatk ver.4.3.0.0
module load gatk4/4.3.0.0


#Checking for reference index (bwa-mem2)
if [ ! -e $reference_folder/$reference_fa.bwt.2bit.64 ]; then
	bwa-mem2 index $reference_folder/$reference_fa
fi

#Checking for reference index (bwa)
if [ ! -e $reference_folder/$reference_fa.bwt ]; then
	bwa index $reference_folder/$reference_fa
fi

#Checking for fasta index (samtools)
if [ ! -e $reference_folder/$reference_fa.fai ]; then
	samtools faidx $reference_folder/$reference_fa
fi

#Checking for gatk reference index (gatk: *.dict)
if [ ! -e $reference_folder/$reference_fa_head.dict ]; then
	gatk CreateSequenceDictionary -R $reference_folder/$reference_fa -O $reference_folder/$reference_fa_head.dict
fi


#preparing for output folder
mkdir -p $main_folder/bwa_out


#running for mapping procedures
while read sample; do

	work_folder=$main_folder/bwa_out/$sample
	mkdir -p $work_folder
	cd $work_folder

	fastq_R1=$sample$R1_tag.trimQ20.merge.trimmomatic.fastp.fastq.gz
	fastq_R2=$sample$R2_tag.trimQ20.merge.trimmomatic.fastp.fastq.gz
		
	#setting RG: @RG\tID:Traja_GRASDi\tSM:$sample\tPL:Illumina
	specific_ID="Traja_GRASDi"
	tag_read_group_part1="@RG\tID:"
	tag_read_group_part2="\tSM:"
	tag_read_group_part3="\tPL:Illumina"
	tag_read_group=$tag_read_group_part1$specific_ID$tag_read_group_part2$sample$tag_read_group_part3

	bwa-mem2 mem -t $no_threads -M -R $tag_read_group $reference_folder/$reference_fa\
	 $QC_folder/$sample/$fastq_R1 $QC_folder/$sample/$fastq_R2 | samtools view -@ $no_threads -b | samtools sort -@ $no_threads > $sample.$code_ID.bam
	samtools index -@ $no_threads $sample.$code_ID.bam
	
done < $script_folder/sample_ID.A0001_A0646.list  #list of MIDs


cd $CURRENT_DIR

module unload gatk4/4.3.0.0

