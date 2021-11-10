# Bioinformatics pipeline for GRAS-Di analysis of <i>Trachurus japonicus</i>
[<i>Trachurus japonicus</i>](https://www.fishbase.de/summary/366), Japanese jack mackerel, is a pelagic fish species distributed on the continental shelf waters along the subtropical Kuroshio Current and the Tsushima Warm Current in the sewtern North Pacific. <i>Trachurus japonicus</i> is a commercially important species in the East Asia, especially in Japan, Korea and China.


## Requirement

* bedtools: a powerful toolset for genome arithmetic (https://bedtools.readthedocs.io)
* BWA: Burrow-Wheeler Aligner (http://bio-bwa.sourceforge.net) 
* Bwa-mem2: the next version of the bwa-mem (https://github.com/bwa-mem2/bwa-mem2)
* fastp: an all-in-one preprocessing tool for fastq files (https://github.com/OpenGene/fastp) 
* GATK: Genome Analysis Toolkit (https://gatk.broadinstitute.org/)
* Plink: whole-genome association analysis tool (https://www.cog-genomics.org/plink/)
* samtools: tools for manipulating NGS data (https://github.com/samtools/samtools)
* Trimmomatic: a flexible read trimming tool (https://github.com/usadellab/Trimmomatic)
* vcftools: a set of tools for working with VCF files (https://github.com/vcftools/vcftools)

The environments under Ubuntu 18.04 are tested. The versions of the tools used are documented in a series of shell scripts.


## Reference genome and the sequencing data
Primary assembly of <i>Trachurus japonicus</i> genome (agi ver.2) was developed by Dr. Atsushi Fujiwara (Fisheries Research Agency, Japan). The raw sequencing data analyzed were deposited into the DNA Data Bank of Japan Sequence Read Archive with the accession number DRA012187 and DRA012269.



## Usage
Run a series of the shell scripts in the order listed after changing paths according to your environemt:
 
```bash
Pipe.01.trimmomatic.fastp.sh
Pipe.02.Map.sh
Pipe.03.RemoveMultipleMappedReads.sh
..
Pipe.11.PlinkFiltering.sh
```


## Filtering parameters
* Reads of mapping quality (MAPQ) < 4 were removed. 
* Common for filtering out: Depth ＜ 10x, GenotypeQuality < 20 
* SNPs for flitering out: QualByDepth < 2.0, FisherStrand > 60.0, RMSMappingQuality < 40.0, MQRankSum < -12.5, ReadPosRankUsm < -8.0, StrandOddsRatio > 4.0, and ExcessHet > 13.0  
* INDELs for flitering out: QualByDepth < 2.0, FisherStrand > 200.0, RMSMappingQuality < 20.0, StrandOddsRatio > 10.0, and ExcessHet > 13.0    


## Note
This project is currently under development. Thank you!
