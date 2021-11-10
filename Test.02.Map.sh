#!/bin/bash
#Pipe.02.Map.sh
#by HIRAO Akira

set -exuo pipefail

SCRIPT_DIR=$(cd $(dirname $0)  && pwd)

no_threads=64

#agi.2.0.fa: the reference genoeme provided by Dr. Fujiwara @2021/8/26
reference_fa=agi.2.0.fa
reference_fa_head=agi.2.0
reference_folder=/home/akihirao/work/Traja/RefGenome/RefGenome_v4
main_folder=/home/akihirao/work/Traja/Traja_GRASDi
raw_fastq_folder=$main_folder/Traja_RawData_GRASDi
QC_folder=$main_folder/Traja_QCData_GRASDi
bwa_mem2_folder=/home/akihirao/local/bwa-mem2-2

R1_tag="_R1"
R2_tag="_R2"

#bwa (Version: 0.7.17-r1198-dirty)
#bwa-mem2 v2.2.1
#samtools 1.12-12-g38139f7
#Using htslib 1.12-10-gc3ba302


#Checking for reference index (bwa-mem2)
if [ ! -e $reference_folder/$reference_fa.bwt.2bit.64 ]; then
	$bwa_mem2_folder/bwa-mem2 index $reference_folder/$reference_fa
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

	fastq_R1=$sample$R1_tag.fastq.gz
	fastq_R2=$sample$R2_tag.fastq.gz
		
	#setting RG: @RG\tID:Traja_GRASDi\tSM:$sample\tPL:Illumina
	specific_ID="Traja_GRASDi"
	tag_read_group_part1="@RG\tID:"
	tag_read_group_part2="\tSM:"
	tag_read_group_part3="\tPL:Illumina"
	tag_read_group=$tag_read_group_part1$specific_ID$tag_read_group_part2$sample$tag_read_group_part3

	$bwa_mem2_folder/bwa-mem2 mem -t $no_threads -M -R $tag_read_group $reference_folder/$reference_fa\
	 $raw_fastq_folder/$fastq_R1 $raw_fastq_folder/$fastq_R2 | samtools view -@ $no_threads -b | samtools sort -@ $no_threads > $sample.agi.2.0.unQC.bam
	samtools index -@ $no_threads $sample.agi.2.0.unQC.bam
	
#done < $SCRIPT_DIR/sample_ID.A0001_A0646.list  #list of MIDs
done < $SCRIPT_DIR/sample_ID.test.list


cd $SCRIPT_DIR

