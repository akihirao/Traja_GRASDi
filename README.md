# Bioinformatics pipeline for SNPs calling workflow for GRAS-Di analysis of <i>Trachurus japonicus</i>
[<i>Trachurus japonicus</i>](https://www.fishbase.de/summary/366), Japanese jack mackerel, is a pelagic fish distributed on the continental shelf waters along the subtropical Kuroshio Current and the Tsushima Warm Current in the sewtern North Pacific. <i>Trachurus japonicus</i> is a commercially important species in the East Asia, especially in Japan, Korea and China.


## Requirement

* bedtools: a powerful toolset for genome arithmetic (https://bedtools.readthedocs.io)
* BWA: Burrow-Wheeler Aligner (http://bio-bwa.sourceforge.net) 
* fastp: An all-in-one preprocessing tool for fastq files (https://github.com/OpenGene/fastp) 
* GATK: Genome Analysis Toolkit (https://gatk.broadinstitute.org/)* samtools: Tools for manipulating NGS data (https://github.com/samtools/samtools)
* Plink: Whole-genome association analysis tool (https://www.cog-genomics.org/plink/)
* vcftools: A set of tools for working with VCF files (https://github.com/vcftools/vcftools)

The environments under Ubuntu 18.04 are tested. The versions of the tools used are documented in a series of shell scripts.


## Reference genome and the sequencing data
Primary assembly of <i>Trachurus japonicus</i> genome (agi1) was developed by Dr. Atsushi Fujiwara (Fisheries Research Agency, Japan). The raw sequencing data analyzed were deposited into the DNA Data Bank of Japan Sequence Read Archive with the accession number DRAxxxxxx and DRA012187.



## Usage
Run a series of the shell scripts in the order listed after changing paths according to your environemt:
 
```bash
Pipe.00.fastp.sh
Pipe.01.Map.sh
...
Pipe.10.GenotypeFiltering.sh
```


## Filtering parameters
* Reads of mapping quality (MAPQ) < 4 were removed. 
* Common for filtering out: Depth ＜ 10x, GenotypeQuality < 20 
* SNPs for flitering out: QualByDepth < 2.0, FisherStrand > 60.0, RMSMappingQuality < 40.0, MQRankSum < -12.5, ReadPosRankUsm < -8.0, StrandOddsRatio > 4.0, and ExcessHet > 13.0  
* INDELs for flitering out: QualByDepth < 2.0, FisherStrand > 200.0, RMSMappingQuality < 20.0, StrandOddsRatio > 10.0, and ExcessHet > 13.0    


## Note
This project is currently under development. Thank you!
