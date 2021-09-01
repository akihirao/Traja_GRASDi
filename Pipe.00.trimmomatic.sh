#!/bin/bash
#Pipe.00.trimmomatic.sh
#by HIRAO Akira


set -exuo pipefail

SCRIPT_DIR=$(cd $(dirname $0)  && pwd)

no_threads=64


raw_fastq_folder=/home/akihirao/work/Traja/Traja_GRASDi/Traja_RawData_GRASDi
QC_folder=/home/akihirao/work/Traja/Traja_GRASDi/Traja_QCData_GRASDi


while read sample; do

	if [ ! -e $QC_folder/$sample ]; then
		mkdir $QC_folder/$sample
	fi

	R1_tag="_R1"
	R2_tag="_R2"
	sample_R1=$sample$R1_tag
	sample_R2=$sample$R2_tag

	java -jar ~/local/Trimmomatic-0.39/trimmomatic-0.39.jar\
 	 PE\
	 -threads $no_threads\
	 $raw_fastq_folder/$sample_R1.fastq.gz\
	 $raw_fastq_folder/$sample_R2.fastq.gz\
	 $QC_folder/$sample/$sample_R1.trimQ20.pair.fastq.gz\
	 $QC_folder/$sample/$sample_R1.trimQ20.unpair.fastq.gz\
	 $QC_folder/$sample/$sample_R2.trimQ20.pair.fastq.gz\
	 $QC_folder/$sample/$sample_R2.trimQ20.unpair.fastq.gz\
	 SLIDINGWINDOW:150:20\
	 MINLEN:50

	fastp -i $QC_folder/$sample/$sample_R1.trimQ20.pair.fastq.gz\
	 -I $QC_folder/$sample/$sample_R2.trimQ20.pair.fastq.gz\
	 -o $QC_folder/$sample/$sample_R1.trimQ20.fastp.fastq.gz\
	 -O $QC_folder/$sample/$sample_R2.trimQ20.fastp.fastq.gz\
	 -A -q 0\
	 -h $QC_folder/$sample/$sample.trimQ20.fastp.html

done < $SCRIPT_DIR/sample_ID.A0001_A0003.list #list of ID

