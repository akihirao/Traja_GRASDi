#!/bin/bash
#Pipe.00.fastp.Q20.sh
#by HIRAO Akira


set -exuo pipefail

SCRIPT_DIR=$(cd $(dirname $0)  && pwd)


no_thread=16

raw_fastq_folder=/home/akihirao/work/Traja/Traja_GRASDi/Traja_RawData_GRASDi
QC_folder=/home/akihirao/work/Traja/Traja_GRASDi/Traja_QCData_GRASDi

P5_seq="AATGATACGGCGACCACCGAGATCTACAC"
Rd1p_seq="TCGTCGGCAGCGTCAGATGTGTATAAGAGACAG"
P7_seq="CAAGCAGAAGACGGCATACGAGAT"
Rd2p_seq="GTCTCGTGGGCTCGGAGATGTGTATAAGAGACAG"

adapter_lab="adapter"

while read sample index1 index2; do

	if [ ! -e $QC_folder/$sample ]; then
		mkdir $QC_folder/$sample
	fi
	
	P5_concate_seq=$P5_seq$index1$Rd1p_seq
	P7_concate_seq=$P7_seq$index2$Rd2p_seq
	
	P5_concate_lab=">P5_concate"
	P7_concate_lab=">P7_concate"

	echo -n >| $QC_folder/$sample/$sample.adapter.fa
	echo $P5_concate_lab >> $QC_folder/$sample/$sample.$adapter_lab.fa
	echo $P5_concate_seq >> $QC_folder/$sample/$sample.$adapter_lab.fa
	echo $P7_concate_lab >> $QC_folder/$sample/$sample.$adapter_lab.fa
	echo $P7_concate_seq >> $QC_folder/$sample/$sample.$adapter_lab.fa


	R1_tag="_R1"
	R2_tag="_R2"
	sample_R1=$sample$R1_tag
	sample_R2=$sample$R2_tag
	
	#-q 20: mean phred quality >=Q20
	#-l 50: read shortern than length 50 will be discarded 
	fastp -i $raw_fastq_folder/$sample_R1.fastq.gz\
	 -I $raw_fastq_folder/$sample_R2.fastq.gz -3\
	 -o $QC_folder/$sample/$sample_R1.trimQ20.fastq.gz\
	 -O $QC_folder/$sample/$sample_R2.trimQ20.fastq.gz\
	 -h $QC_folder/$sample/$sample.fastp.trimQ20.report.html\
	 -j $QC_folder/$sample/$sample.fastq.trimQ20.report.json\
	 -q 20 -l 50\
	 --adapter_fasta $QC_folder/$sample/$sample.$adapter_lab.fa\
	 -w $no_thread

#done < $SCRIPT_DIR/sample_ID.adapter.A0001_A0646.list #list of ID
done < $SCRIPT_DIR/sample_ID.adapter.A0644_A0646.list

