#pca-plot.plink.R

rm(list=ls())
library(tidyverse)
library(viridis)
library(adegenet)
library(ggplot2)


#Color pallet of ggplot default
ggColorHue <- function(n, l=65) {
  hues <- seq(15, 375, length=n+1)
  hcl(h=hues, l=l, c=100)[1:n]
}


code_ID <- "Traja_GRASDi_ref2_rev2.nDNA.snp.maf001.LDpruned"
#code_ID <- "Traja_GRASDi_ref2_rev2.nDNA.snp.maf001"
#code_ID <- "Traja_GRASDi_ref2_rev2.nDNA.snp.non_singleton"

pca_input  <- paste(code_ID, ".eigenvec",sep="")
eigenval_input  <- paste(code_ID, ".eigenval",sep="")

sample_info_input <- "Agi.614indiv.data.txt"
sample_info <- read.table(sample_info_input,header=T)

pca <- read.table(pca_input, header=F)
eigenval <- read.csv("Traja_GRASDi_ref2_rev2.nDNA.snp.maf001.LDpruned.eigenval", header=F)
df <- data.frame(pc = 1:nrow(eigenval), eigenval/sum(eigenval)*100)
colnames(pca) <- c("ID","FID",paste("PC",seq(1:(ncol(pca)-2)),sep=""))
pca$stock <- factor(sample_info$YearClassStock, levels=c("T2019","K2019","K2020"))
pca$prefecture <- factor(sample_info$Prefecture)
pca$Birth_month <- factor(sample_info$BirthMonth2019Start)

no_stock <- length(unique(pca$stock))
col_stock <- funky(no_stock)

no_prefecture <- length(unique(pca$prefecture))
MyCol_prefecture <- ggColorHue(no_prefecture)

no_birth_month <- length(unique(pca$Birth_month))
MyCol_birth_month <- ggColorHue(no_birth_month)



p0 <- ggplot(df, aes(pc, V1)) +
  geom_bar(stat = "identity")+
  xlab("Percentage components")+
  ylab("Variance explained (%)")+
  theme_bw(base_size = 15)

ggsave("out_barplot.pdf", p0,
         width = 20, height = 15,
         units = "cm", dpi = 300)


#plot T vs K
#p12_stock <- ggplot(pca, aes(PC1, PC2, color=stock, shape=stock))+
p12_stock <- ggplot(pca, aes(PC1, PC2, color=stock))+
  geom_point(size=2, alpha=0.4)+
#  scale_shape_manual(values=c(rep(15:18, 20)))+
#  scale_color_viridis(option = "D", discrete = T,end = 0.99)+
  xlab(paste0("PC1 (", round(df[1,2], digits = 2), "%)"))+
  ylab(paste0("PC2 (", round(df[2,2], digits = 2), "%)"))+
#  scale_color_brewer(palette = "Set1") +
  scale_fill_manual(values = c("#FF0000", "#FF0000", "#0000FF")) +
  theme_bw(base_size = 15)

ggsave("Stock_out_PC1PC2plot.pdf", p12_stock,
         width = 20, height = 15,
         units = "cm", dpi = 300)

p13_stock <- ggplot(pca, aes(PC1, PC3, color=stock))+
  geom_point(size=2, alpha=0.4)+
#  scale_shape_manual(values=c(rep(15:18, 20)))+
#  scale_color_viridis(option = "D", discrete = T,end = 0.99)+
  xlab(paste0("PC1 (", round(df[1,2], digits = 2), "%)"))+
  ylab(paste0("PC3 (", round(df[3,2], digits = 2), "%)"))+
#  scale_color_brewer(palette = "Set1") +
  scale_fill_manual(values = c("#FF0000", "#FF0000", "#0000FF")) +
  theme_bw(base_size = 15)

ggsave("Stock_out_PC1PC3plot.pdf", p13_stock,
         width = 20, height = 15,
         units = "cm", dpi = 300)



#plot prefecture
p12_prefecture <- ggplot(pca, aes(PC1, PC2, color=prefecture))+
  geom_point(size=2, alpha=0.4)+
#  scale_shape_manual(values=c(rep(15:18, 20)))+
#  scale_color_viridis(option = "D", discrete = T,end = 0.99)+
  xlab(paste0("PC1 (", round(df[1,2], digits = 2), "%)"))+
  ylab(paste0("PC2 (", round(df[2,2], digits = 2), "%)"))+
  scale_color_manual(values=MyCol_prefecture) +
  theme_bw(base_size = 15)

ggsave("Prefecture_out_PC1PC2plot.pdf", p12_prefecture,
         width = 20, height = 15,
         units = "cm", dpi = 300)

p13_prefecture <- ggplot(pca, aes(PC1, PC3, color=prefecture))+
  geom_point(size=2, alpha=0.4)+
#  scale_shape_manual(values=c(rep(15:18, 20)))+
#  scale_color_viridis(option = "D", discrete = T,end = 0.99)+
  xlab(paste0("PC1 (", round(df[1,2], digits = 2), "%)"))+
  ylab(paste0("PC3 (", round(df[3,2], digits = 2), "%)"))+
  scale_color_manual(values=MyCol_prefecture) +
  theme_bw(base_size = 15)

ggsave("Prefecture_out_PC1PC3plot.pdf", p13_prefecture,
         width = 20, height = 15,
         units = "cm", dpi = 300)


#plot birth
p12_birth <- ggplot(pca, aes(PC1, PC2, color=Birth_month))+
  geom_point(size=2, alpha=0.4)+
#  scale_shape_manual(values=c(rep(15:18, 20)))+
#  scale_color_viridis(option = "D", discrete = T,end = 0.99)+
  xlab(paste0("PC1 (", round(df[1,2], digits = 2), "%)"))+
  ylab(paste0("PC2 (", round(df[2,2], digits = 2), "%)"))+
  scale_color_manual(values=MyCol_birth_month) +
  theme_bw(base_size = 15)

ggsave("BirthMonth_out_PC1PC2plot.pdf", p12_birth,
         width = 20, height = 15,
         units = "cm", dpi = 300)

p13_birth <- ggplot(pca, aes(PC1, PC3, color=Birth_month))+
  geom_point(size=2, alpha=0.4)+
#  scale_shape_manual(values=c(rep(15:18, 20)))+
#  scale_color_viridis(option = "D", discrete = T,end = 0.99)+
  xlab(paste0("PC1 (", round(df[1,2], digits = 2), "%)"))+
  ylab(paste0("PC3 (", round(df[3,2], digits = 2), "%)"))+
  scale_color_manual(values=MyCol_birth_month) +
  theme_bw(base_size = 15)

ggsave("BirthMonth_out_PC1PC3plot.pdf", p13_birth,
         width = 20, height = 15,
         units = "cm", dpi = 300)


