#!/bin/bash
#Pipe.01.Map.sh
#by HIRAO Akira

set -exuo pipefail

SCRIPT_DIR=$(cd $(dirname $0)  && pwd)

no_thread=64

reference_folder=/home/akihirao/work/Traja/RefGenome/RefGenome_v2
main_folder=/home/akihirao/work/Traja/Traja_GRASDi
QC_folder=$main_folder/Traja_QCData_GRASDi

R1_tag="_R1"
R2_tag="_R2"

#bwa (Version: 0.7.17-r1198-dirty)
#samtools 1.12-12-g38139f7
#Using htslib 1.12-10-gc3ba302

#Checking for reference index
if [ ! -e $reference_folder/agi1.2.fa.bwt ]; then
		bwa index $reference_folder/agi1.2.fa
fi

#Checking for fasta index
if [ ! -e $reference_folder/agi1.2.fa.fai ]; then
                samtools faidx $reference_folder/agi1.2.fa
fi

#preparing for output folder
mkdir -p $main_folder/bwa_out


#running for mapping procedures
while read sample; do

	work_folder=$main_folder/bwa_out/$sample
	mkdir -p $work_folder
	cd $work_folder

	fastq_R1=$sample$R1_tag.trimQ30.fastq.gz
	fastq_R2=$sample$R2_tag.trimQ30.fastq.gz
		
	#setting RG: @RG\tID:Traja_GRASDi\tSM:$sample\tPL:Illumina
	specific_ID="Traja_GRASDi"
	tag_read_group_part1="@RG\tID:"
	tag_read_group_part2="\tSM:"
	tag_read_group_part3="\tPL:Illumina"
	tag_read_group=$tag_read_group_part1$specific_ID$tag_read_group_part2$sample$tag_read_group_part3

	bwa mem -t $no_thread -M -R $tag_read_group $reference_folder/agi1.2.fa\
	 $QC_folder/$sample/$fastq_R1 $QC_folder/$sample/$fastq_R2 | samtools view -@ $no_thread -b | samtools sort -@ $no_thread > $sample.agi1.2.bam
	samtools index -@ $no_thread $sample.agi1.2.bam
	
done < $SCRIPT_DIR/sample_ID.A0001_A0646.list #list of MIDs


cd $SCRIPT_DIR


