## Workflow to make distance matrix of Rousset's A with using the program SPAGeDi

#### Requirement
* SPAGeDi (Spatial Pattern Analysis of Genetic Diversity) https://github.com/reedacartwright/spagedi

#### Usage
```bash
#Conversion R script from vcf file to input for SPAGeDi
vcf2spagedi.R

#Execute spagedi by the command file containing the keystrokes 
spagedi < cmds.txt 

#Extract distance matrix of Rousset's A from the SPAGeDi output file spagedi
Extract.RoussetA.MatCsv.sh
```

#### Reference
Rousset, F.(2000) Genetic differentiation between individuals. J. Evol. Biol. 13:58–62. https://doi.org/10.1046/j.1420-9101.2000.00137.x
