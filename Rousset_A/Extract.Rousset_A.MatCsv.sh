#!/bin/bash
#Extract.RoussetA.MatCsv.sh
#SPAGeDiを使って個体間の遺伝的分化係数 Rousset's A (Rousset 2000)を算出し、csv形式のmatrixファイルを出力する

#事前にspagediで算出しておく
#spagedi < cmd.Chiopi.txt


CURRENT_DIR=$(cd $(dirname $0) && pwd)

work_folder=/home/akihirao/work/Traja/Traja_GRASDi/Rousset_A

cd $work_folder


spagedi_input_file="spagedi.input.txt"
spagedi_output_file="spagedi.output.txt"

output_csv="Rousset_A.DistMat.csv"

nInd=(`awk 'NR==3 {print $1}' ${spagedi_input_file}`)
nCutCol=$((${nInd}+2));

#Extract dist matrix of Rousset's A from SPAGeDi outpufile 
cat $spagedi_output_file | grep -A $nCutCol "^Pairwise Rousset's distance between individuals ('a' in Rousset, 2000)$" | sed -e '1,2d' | sed s/"ALL LOCI"/ID/ | awk -F '\t' 'BEGIN{OFS=","}{$1=""; print $0}' | sed 's/^,//g' > $output_csv

cd $CURRENT_DIR

