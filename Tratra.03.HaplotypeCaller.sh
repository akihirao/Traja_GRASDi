#!/bin/bash
#Tratra.03.HaplotypeCaller.sh
#by HIRAO Akira

set -exuo pipefail

SCRIPT_DIR=$(cd $(dirname $0)  && pwd)

no_thread=64

reference_folder=/home/akihirao/work/Traja/RefGenome/RefGenome_v3
main_folder=/home/akihirao/work/Traja/Tratra
sample="Tratra.WG"


cd $main_folder

gatk HaplotypeCaller\
 -R $reference_folder/agi1.2.fa\
 -I $sample.filtered.bam\
 --emit-ref-confidence GVCF\
 --bam-output $sample.hpcall.bam\
 -O $sample.g.vcf.gz 

cd $SCRIPT_DIR
