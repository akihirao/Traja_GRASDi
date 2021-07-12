#!/bin/bash
#Tratra.01.Map.sh
#by HIRAO Akira

set -exuo pipefail

SCRIPT_DIR=$(cd $(dirname $0)  && pwd)

no_thread=128

reference_folder=/home/akihirao/work/Traja/RefGenome/RefGenome_v3
main_folder=/home/akihirao/work/Traja
work_folder=$main_folder/Tratra
fastq_folder=$main_folder/RefGenome/RefGenome_Tratra

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
mkdir -p $work_folder
cd $work_folder

#running for mapping procedures

fastq_R1=Tratra_ref_R1.fastq.gz
fastq_R2=Tratra_ref_R2.fastq.gz
		
#setting RG: @RG\tID:Tratra_WG\tSM:fTraTra1_1\tPL:Illumina
specific_ID="Tratra_WG"
sample_lab="fTraTra1_1"
tag_read_group_part1="@RG\tID:"
tag_read_group_part2="\tSM:"
tag_read_group_part3="\tPL:Illumina"
tag_read_group=$tag_read_group_part1$specific_ID$tag_read_group_part2$sample_lab$tag_read_group_part3

echo $tag_read_group

#Bwa-mem2: next verstion of bwa-mem algorisms by Heng Li
/home/akihirao/local/bwa-mem2/bwa-mem2 mem $reference_folder/agi1.2.fa $fastq_folder/$fastq_R1 $fastq_folder/$fastq_R2 > $Tratra.WG.sam

#samtools view --threads $no_thread -b | samtools sort --threads $no_thread > $Tratra.WG.bam
#samtools index -@ $no_thread Tratra.WG.bam
	
cd $SCRIPT_DIR