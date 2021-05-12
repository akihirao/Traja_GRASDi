#!/bin/bash
#Pipe.00.fastp.sh
#by HIRAO Akira


set -exuo pipefail

SCRIPT_DIR=$(cd $(dirname $0)  && pwd)


no_thread=16

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
	
	#-q 30: mean phred quality >=Q30
	#-l 50: read shortern than length 50 will be discarded 
	fastp -i $raw_fastq_folder/$sample_R1.fastq.gz\
	 -I $raw_fastq_folder/$sample_R2.fastq.gz -3\
	 -o $QC_folder/$sample/$sample_R1.trimQ30.fastq.gz\
	 -O $QC_folder/$sample/$sample_R2.trimQ30.fastq.gz\
	 -h $QC_folder/$sample/$sample.fastp.trimQ30.report.html\
	 -j $QC_folder/$sample/$sample.fastq.trimQ30.report.json\
	 -q 30 -l 50\
	 -w $no_thread

#done < $SCRIPT_DIR/sample_ID.test.list #list of ID
done < $SCRIPT_DIR/sample_ID.list #list of ID



