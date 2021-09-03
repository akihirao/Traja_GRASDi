#!/bin/bash
#Pipe.00.fastp.sh
#by HIRAO Akira


set -exuo pipefail

SCRIPT_DIR=$(cd $(dirname $0)  && pwd)


no_thread=32

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
	 -I $raw_fastq_folder/$sample_R2.fastq.gz\
	 -o $QC_folder/$sample/$sample_R1.trimQ20.LN150.fastq.gz\
	 -O $QC_folder/$sample/$sample_R2.trimQ20.LN150.fastq.gz\
	 -h $QC_folder/$sample/$sample.fastp.trimQ20.LN150.report.html\
	 -j $QC_folder/$sample/$sample.fastq.trimQ20.LN150.report.json\
	 --average_qual 20 -l 149\
	 -Y 0\
	 -A -Q\
	 -w $no_thread

done < $SCRIPT_DIR/sample_ID.A0066_A0576.list #list of ID


