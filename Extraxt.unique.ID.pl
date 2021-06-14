#!/bin/perl
#Extraxt.unique.ID.pl
#by HIRAO Akira

$file1 = "OldFile.txt";
$file2 = "NewFile.txt";
open (IN, "<$file1");
for (<IN>){
$hash{$_} = 1;
}
close(IN);

open (IN2, "<$file2");
for (<IN2>){
unless($hash{$_} == 1){
open(WR,">>Out.txt");
print WR $_;
close(WR);
}
}
close(IN2);
