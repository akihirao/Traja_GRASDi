# Workflow to make distance matrix of Rousset's A (Rousset 2000) with using the program SPAGeDi

##Requirement: the program [SPAGeDi](https://github.com/reedacartwright/spagedi) (Spatial Pattern Analysis of Genetic Diversity) must be install on your system.


...bash
#Conversion R script from vcf file to input for SPAGeDi
vcf2spagedi.R

#Execute spagedi on CUI
spagedi < cmd.Chiopi.txt 

#Extract distance matrix of Rousset's A from the SPAGeDi output file spagedi
Extract.RoussetA.MatCsv.sh 
...

