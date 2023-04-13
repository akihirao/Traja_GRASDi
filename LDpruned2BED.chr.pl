#!/usr/bin/perl
#LDpruned2BED.chr.pl
#conversion from LD-prune.in to BED (chr version)
#how to use 
#$ perl LDpruned2BED.chr.pl < input.prune.in > output.bed


#==================================================
$chr_head = 'chr';

while($line = <>){
	chomp $line;
	($chr_No, $position) = split /:/,$line;
	$chr = $chr_head.$chr_No;
	$start_position = $position -1;
	$end_position = $position;
	print "$chr\t$start_position\t$end_position\n";
}
