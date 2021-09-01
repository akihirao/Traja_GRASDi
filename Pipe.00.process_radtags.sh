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
	process_radtags -1 $raw_fastq_folder/$sample_R1.fastq.gz\
	 -2 $raw_fastq_folder/$sample_R2.fastq.gz\
	 -o $QC_folder/$sample/\
	 -c -q

done < $SCRIPT_DIR/sample_ID.A0001_A0003.list #list of ID


