#!/bin/bash
#Pipe.0.trimmomatic.fastp.sh
#by HIRAO Akira


set -exuo pipefail

SCRIPT_DIR=$(cd $(dirname $0)  && pwd)

no_threads=64
no_threads_fastp=16

#input your account name
user_name=akihirao

#Prepare raw fastq.gz files in the follwing folder
raw_fastq_folder=/home/$user_name/work/Traja/Traja_GRASDi/Traja_RawData_GRASDi

#Make the foloder for QC output data
QC_folder=/home/$user_name/work/Traja/Traja_GRASDi/Traja_QCData_GRASDi
mkdir -p $QC_folder

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
	 ILLUMINACLIP:$SCRIPT_DIR/NexteraPE-PE.fa:2:30:10\
	 HEADCROP:5\
	 SLIDINGWINDOW:4:20\
	 MINLEN:50

	fastp -i $QC_folder/$sample/$sample_R1.trimQ20.pair.fastq.gz\
	 -I $QC_folder/$sample/$sample_R2.trimQ20.pair.fastq.gz -3\
	 -o $QC_folder/$sample/$sample_R1.trimQ20.trimmomatic.fastp.fastq.rev1.gz\
	 -O $QC_folder/$sample/$sample_R2.trimQ20.trimmomatic.fastp.fastq.rev1.gz\
	 --adapter_fasta $SCRIPT_DIR/NexteraPE-PE.fa\
	 --average_qual 20 -q 20 -l 50 -t 5 -T 5\
	 -h $QC_folder/$sample/$sample.trimQ20.trimmomatic.fastp.rev1.html\
	 -w $no_threads_fastp
	 #-3:  enable per read cutting by quality in tail (3'), default is disabled
	 # -t: trimming how many bases in tail for read1, default is 0 (int [=0])
	 # -T: trimming how many bases in tail for read2, default is 0 (int [=0])

done < $SCRIPT_DIR/sample_ID.A0001_A0646.list #list of ID

