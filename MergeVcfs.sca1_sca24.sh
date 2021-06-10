
#!/bin/bash
#MergeVcfs.sca1_sca24.sh
#by HIRAO Akira

set -exuo pipefail

SCRIPT_DIR=$(cd $(dirname $0)  && pwd)

no_thread=128

reference_folder=/home/akihirao/work/Traja/RefGenome/RefGenome_v2
main_folder=/home/akihirao/work/Traja/Traja_GRASDi

cd $main_folder/vcf_out

gatk MergeVcfs\
 -R $reference_folder/agi1.2.fa\
 -I Traja_GRASDi.sca1.vcf.gz\
 -I Traja_GRASDi.sca2_sca3.vcf.gz\
 -I Traja_GRASDi.sca4_sca5.vcf.gz\
 -I Traja_GRASDi.sca6.vcf.gz\
 -I Traja_GRASDi.sca7_sca8.vcf.gz\
 -I Traja_GRASDi.sca9_sca10.vcf.gz\
 -I Traja_GRASDi.sca11_sca16.vcf.gz\
 -I Traja_GRASDi.sca17_sca20.vcf.gz\
 -I Traja_GRASDi.sca21_sca24.vcf.gz\
 -O Traja_GRASDi.sca1_sca24.vcf.gz

cd $SCRIPT_DIR
