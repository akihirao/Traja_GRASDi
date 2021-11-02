#!/bin/bash
#Pipe.00.SummaryRawReads.sh
#by HIRAO Akira
#requirement: seqkit (https://github.com/shenwei356/seqkit)

set -exuo pipefail

SCRIPT_DIR=$(cd $(dirname $0)  && pwd)

no_threads=64

main_folder=/home/akihirao/work/Traja/Traja_GRASDi
raw_fastq_folder=$main_folder/Traja_RawData_GRASDi

echo -n >| Summary.RawReads.txt
echo -n >| Summary.RawReads.csv

cd $raw_fastq_folder
while read sample; do

	R1_tag="_R1"
	R2_tag="_R2"
	sample_R1=$sample$R1_tag
	sample_R2=$sample$R2_tag

	seqkit stats -j $no_threads $sample_R1.fastq.gz >> $SCRIPT_DIR/Summary.RawReads.txt
	seqkit stats -j $no_threads $sample_R2.fastq.gz >> $SCRIPT_DIR/Summary.RawReads.txt
		
done < $SCRIPT_DIR/sample_ID.A0001_A0646.list #list of ID
#done <$SCRIPT_DIR/sample_ID.test.list

cd $SCRIPT_DIR

sort Summary.RawReads.txt | uniq > Summary.RawReads.uniq.txt
cat Summary.RawReads.uniq.txt | tr -d ","  | awk -v 'OFS=,' '{print $1,$4,$5}'  > Summary.RawReads.raw.csv

tail -n 1 Summary.RawReads.raw.csv > Summary.RawReads.csv
sed -i -e '$d' Summary.RawReads.raw.csv
cat Summary.RawReads.raw.csv >> Summary.RawReads.csv

rm Summary.RawReads.txt
rm Summary.RawReads.uniq.txt
rm Summary.RawReads.raw.csv


