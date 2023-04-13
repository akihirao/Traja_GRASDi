#vcf2spagedi.R
#Conversion R script form vcf to input file for SPAGeDi
#Population and Spatial position are treated as virtual information

library(vcfR)
library(adegenet)

setwd("/mnt/WD20/Traja/Traja_GRASDi/Rousset_A")

input_vcf_file <- "/mnt/WD20/Traja/Traja_GRASDi/vcf_out/Traja_GRASDi_ref3.nDNA.snp.maf001.non_unplaced.LDpruned.vcf.gz"
output_file <- "spagedi.input.txt"


fish_vcf <- vcfR::read.vcfR(input_vcf_file)

#Convert to genind
fish_genind <- vcfR::vcfR2genind(fish_vcf)
no_indiv <-nInd(fish_genind)
pop(fish_genind) <- rep("all", no_indiv)
no_pop <- nPop(fish_genind)

fish_df <- adegenet::genind2df(fish_genind)


fish_mat <- gsub("11", "22", as.matrix(fish_df))
fish_mat <- gsub("01", "12", fish_mat)
fish_mat <- gsub("10", "12", fish_mat)
fish_mat <- gsub("00", "11", fish_mat)
fish_mat[is.na(fish_mat)] <- "00"
fish_df <- as.data.frame(fish_mat)

fish_df_spatial <- cbind(data.frame(pop=fish_df[,1],X=numeric(nInd(fish_genind)),Y=numeric(nInd(fish_genind)),fish_df[,-1]))


no_coord <- 2　#spatial coord: X and Y were set 0 as unrelalized information
no_loc <- nLoc(fish_genind)
no_digit_loc <- 1 #genotypes:11, 12, 22, 00(=NA)
no_ploidy <- 2

line1 <- "//Input file of SNP dataset for SPAGeDi"
line2 <- "// #ind #cat #coord #loci #dig_loc #ploidy"
line3 <- c(no_indiv, no_pop, no_coord, no_loc, no_digit_loc, no_ploidy)
line4 <- 0 #no distance class info
line5 <- c("Ind", colnames(fish_df_spatial))
lineEnd <- "END"

write(line1, file=output_file)
write(line2, file=output_file, append =TRUE)
write(line3, file=output_file, sep="\t", ncolumns = length(line3), append =TRUE)
write(line4, file=output_file, sep="\t", ncolumns = length(line4), append =TRUE)
write(line5, file=output_file,sep="\t", ncolumns = length(line5), append =TRUE)
write.table(fish_df_spatial, file=output_file, sep="\t", col.names=F,row.names=T,quote=F, append =TRUE)
write(lineEnd, file=output_file, sep="\t", ncolumns = length(line5), append =TRUE)

