# Bioinformatics pipeline for SNPs calling workflow for GRAS-Di analysis of <i>Trachurus japonicus</i>
[<i>Trachurus japonicus</i>](https://www.fishbase.de/summary/366), Japanese jack mackerel, is a pelagic fish distributed on the continental shelf waters along the subtropical Kuroshio Current and the Tsushima Warm Current in the sewtern North Pacific. <i>Trachurus japonicus</i> is a commercially important species in the East Asia, especially in Japan, Korea and China.


## Requirement

* samtools: Tools for manipulating NGS data (https://github.com/samtools/samtools)
* vcftools: A set of tools for working with VCF files (https://github.com/vcftools/vcftools)
* BWA: Burrow-Wheeler Aligner (http://bio-bwa.sourceforge.net) 
* GATK: Genome Analysis Toolkit (https://gatk.broadinstitute.org/)
* Plink: Whole-genome association analysis tool (https://www.cog-genomics.org/plink/)
* fastp: An all-in-one preprocessing tool for fastq files (https://github.com/OpenGene/fastp) 

The environments under Ubuntu 18.04 are tested. The versions of the tools used are documented in a series of shell scripts.


## Reference genome
Primary assembly of <i>Trachurus japonicus</i> genome (agi1) was developed by Dr. Atsushi Fujiwara (Fisheries Research Agency, Japan). 


## Usage
Run a series of the shell scripts in the order listed after changing paths according to your environemt:
 
```bash
Pipe.00.fastp.sh
Pipe.01.BWA_mapping.sh

...
Pipe.10.GenotypeFiltering.sh
```



## Note
This project is currently under development. Thank you!
