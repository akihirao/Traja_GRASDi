#!/bin/bash
#Pipe.01.NGmerge.trimmomatic.fastp.sh
#by HIRAO Akira


set -exuo pipefail

CURRENT_DIR=$(cd $(dirname $0)  && pwd)

no_threads=96
no_threads_fastp=16


main_folder=/home/$USER/work/Traja/Traja_GRASDi
script_folder=$main_folder/Scripts

#Prepare raw fastq.gz files in the followig folder
raw_fastq_folder=$main_folder/Traja_RawData_GRASDi

#Prepare the folder for QC output data
QC_folder=$main_folder/Traja_QCData_GRASDi
mkdir -p $QC_folder


while read sample; do

	if [ ! -e $QC_folder/$sample ]; then
		mkdir $QC_folder/$sample
	fi

	R1_tag="_R1"
	R2_tag="_R2"
	sample_R1=$sample$R1_tag
	sample_R2=$sample$R2_tag

	#Merge pair-end reads with removing adapters
	NGmerge -a -z -v -n $no_threads\
	 -1 $raw_fastq_folder/$sample_R1.fastq.gz\
	 -2 $raw_fastq_folder/$sample_R2.fastq.gz\
	 -o $QC_folder/$sample/$sample.merge

	#set path to trimmomatic-0.39.jar on your environment!
	java -jar ~/local/Trimmomatic-0.39/trimmomatic-0.39.jar\
 	 PE\
	 -threads $no_threads\
	 $QC_folder/$sample/$sample.merge_1.fastq.gz\
	 $QC_folder/$sample/$sample.merge_2.fastq.gz\
	 $QC_folder/$sample/$sample_R1.merge.trimmomatic.pair.fastq.gz\
	 $QC_folder/$sample/$sample_R1.merge.trimmomatic.unpair.fastq.gz\
	 $QC_folder/$sample/$sample_R2.merge.trimmomatic.pair.fastq.gz\
	 $QC_folder/$sample/$sample_R2.merge.trimmomatic.unpair.fastq.gz\
	 ILLUMINACLIP:$main_folder/Scripts/NexteraPE-PE.fa:2:30:10\
	 MINLEN:50

	fastp -i $QC_folder/$sample/$sample_R1.merge.trimmomatic.pair.fastq.gz\
	 -I $QC_folder/$sample/$sample_R2.merge.trimmomatic.pair.fastq.gz -3\
	 -o $QC_folder/$sample/$sample_R1.trimQ20.merge.trimmomatic.fastp.fastq.gz\
	 -O $QC_folder/$sample/$sample_R2.trimQ20.merge.trimmomatic.fastp.fastq.gz\
	 --adapter_fasta $main_folder/Scripts/NexteraPE-PE.fa\
	 --average_qual 20 -q 20 -l 50 -f 5 -F 5 -t 5 -T 5\
	 -h $QC_folder/$sample/$sample.trimQ20.merge.trimmomatic.fastp.html\
	 -w $no_threads_fastp
	#-3:  enable per read cutting by quality in tail (3'), default is disabled
	#-f: trimming how many bases in front for read1, default is 0 (int [=0])
	#-F: trimming how many bases in front for read2, default is 0 (int [=0])
	#-t: trimming how many bases in tail for read1, default is 0 (int [=0])
	#-T: trimming how many bases in tail for read2, default is 0 (int [=0])

done < $script_folder/sample_ID.A0001_A0646.list #list of ID
#done < $script_folder/sample_ID.test.list

cd $CURRENT_DIR

