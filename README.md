# Variant calling pipeline for GRAS-Di analysis of <i>Trachurus japonicus</i>
[<i>Trachurus japonicus</i>](https://www.fishbase.de/summary/366), Japanese jack mackerel, is a pelagic fish species distributed on the continental shelf waters along the subtropical Kuroshio Current and the Tsushima Warm Current in the sewtern North Pacific. <i>Trachurus japonicus</i> is a commercially important species in the East Asia, especially in Japan, Korea and China.


## Requirement

* bedtools: a powerful toolset for genome arithmetic https://bedtools.readthedocs.io
* BWA: Burrow-Wheeler Aligner http://bio-bwa.sourceforge.net
* Bwa-mem2: the next version of the bwa-mem https://github.com/bwa-mem2/bwa-mem2
* fastp: an all-in-one preprocessing tool for fastq files https://github.com/OpenGene/fastp 
* GATK: Genome Analysis Toolkit https://gatk.broadinstitute.org
* NGmerge: merging paired-end reads and removing sequencing adapters https://github.com/jsh58/NGmerge
* Plink: whole-genome association analysis tool https://www.cog-genomics.org/plink
* samtools: tools for manipulating NGS data https://github.com/samtools/samtools
* Trimmomatic: a flexible read trimming tool https://github.com/usadellab/Trimmomatic
* vcftools: a set of tools for working with VCF files https://github.com/vcftools/vcftools

The environments under Ubuntu 22.04 are tested. The versions of the tools used are documented in a series of shell scripts.


## Reference genome and the sequencing data
The assembly of T. japonicus has been uploaded to DDBJ/ENA/GenBank (AP029620-AP031217). Raw FASTQ files of GRAS-Di data were deposited in DRA/SRA/ERA ([PRJDB11775](https://www.ncbi.nlm.nih.gov/nuccore/?term=PRJDB11775)).



## Usage
Run a series of the shell scripts in the order listed after changing paths according to your environemt:
 
```bash
Pipe.01.NGmerge.trimmomatic.fastp.sh
Pipe.02.Map.sh
Pipe.03.RemoveMultipleMappedReads.sh
..
Pipe.11.PlinkFiltering.sh
```


## Filtering parameters
* Reads of mapping quality (MAPQ) < 4 were removed. 
* Common for filtering out: Depth ＜ 20x, GenotypeQuality < 30 
* SNPs for flitering out: QualByDepth < 2.0, RMSMappingQuality < 40.0, MQRankSum < -12.5, ReadPosRankUsm < -8.0, StrandOddsRatio > 4.0, and ExcessHet > 13.0  
* INDELs for flitering out: QualByDepth < 2.0, RMSMappingQuality < 20.0, StrandOddsRatio > 10.0, and ExcessHet > 13.0    


## Reference
Hirao AS, Imoto J, Fujiwara A, Watanabe C, Yoda M, Matsuura A, Akita T (accepted) Genome-wide SNP analysis coupled with geographic and reproductive-phenological information reveals panmixia in a classical marine species, the Japanese jack mackerel (<i>Trachurus japonicus</i>). Fisheries Research

