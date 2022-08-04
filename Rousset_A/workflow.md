## Workflow to make distance matrix of Rousset's A with using the program SPAGeDi

#### The program [SPAGeDi](https://github.com/reedacartwright/spagedi) (Spatial Pattern Analysis of Genetic Diversity) must be install on your system.

#### Usage
```bash
#Conversion R script from vcf file to input for SPAGeDi
vcf2spagedi.R

#Execute spagedi on CUI
spagedi < cmd.Chiopi.txt 

#Extract distance matrix of Rousset's A from the SPAGeDi output file spagedi
Extract.RoussetA.MatCsv.sh
```

#### Reference
Rousset, F.(2000) Genetic differentiation between individuals. J. Evol. Biol. 13:58–62. https://doi.org/10.1046/j.1420-9101.2000.00137.x
