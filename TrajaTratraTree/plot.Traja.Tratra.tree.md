# Plotting a phylogenic tree of *Trachurus* *japonicus* with *T.* *trachurus* as an outgroup

## Load the libraries

``` r
library(ape)
library(phangorn)
library(phytools)
library(geiger)
library(adegenet)
library(RColorBrewer)
library(tidyverse)
```

## Load the dataset

``` r
#load phylogenic dataset based on SNPs from GRAS-Di and Reseq
Traja.Tratra.tree <- read.tree(file="Traja.Tratra.nj.tree.rooted.boot.nwk")

#load label infor
stock.lab <- read_table("Agi.614indiv.data.txt")
```

## Define outgroup

``` r
#define outgroup
Traja.Tratra.tree.rooted <- root(Traja.Tratra.tree, outgroup="fTratra1")
tip.lab.vec <- Traja.Tratra.tree.rooted$tip.label
no.tip <- length(tip.lab.vec)
```

## Link stock information

``` r
#load label information
stock.lab <- read_table("Agi.614indiv.data.txt")

#define color for each stock: no. stock of 3 means 2019K, 2019T, 2020K 
col.stock <- funky(3) 


MyCol <- rep("grey",no.tip)
for(i in 1:no.tip){
    no.ID.target <- which(stock.lab$ID==tip.lab.vec[i])

    if(length(no.ID.target) >= 1){

        Stock.each <- stock.lab$Current[no.ID.target]

        if (Stock.each == "Kuroshio"){
            MyCol[i] <- col.stock[2]
        }else if(Stock.each == "Tsushima"){
            MyCol[i] <- col.stock[1]
        }else{
        }

    }else{
    }
}

outgroup.ID <- which(tip.lab.vec=="fTratra1")
MyCol[outgroup.ID ] <- "black"

Label.col <- c(col.stock[2],col.stock[1],"black")
Labels <- c("Kuroshio", "Tsushima", "Trachurus trachurus")
```

## 4．Plot nj tree

``` r
pdf("NJtree.Traja.Tratra.pdf", height=14, width=9)
plot(Traja.Tratra.tree.rooted,
    no.margin=FALSE,show.tip=FALSE,edge.width=0.3,
    main="NJ Tree of Trachurus japonicus")
tiplabels(pch=20, col=MyCol, cex=0.5)
#axisPhylo()
add.scale.bar(0.01, -10,length=0.03, cex=0.7, font = 1.0,lwd=0.7)
legend("right", legend=Labels, col =Label.col, pch =20,cex=1.0)
dev.off()
```

    ## quartz_off_screen 
    ##                 2
