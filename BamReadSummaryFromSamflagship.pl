#!/usr/bin/perl
#BamReadSummaryFromSamflagship.pl
#by HIRAO Akira

print "Sample","\t","Total_reads", "\t","Mapped_reads", "\t","Mapped_reads_rate", "\t","Properly_paired_mapped_reads", "\t","Properly_paired_mapped_reads_rate","\n";


while ($line = <>) {
	chomp $line;
	if($line =~ m/bam/){
		@sample_ID = split (/\./, $line); 
		$ID_out = $sample_ID[0];	
		print $ID_out, "\t";

	$line = <>;
		@total_reads = split (/\s/, $line); 
		print $total_reads[0], "\t";
	$line = <>;
	$line = <>;
	$line = <>;

	$line = <>;
		@mapped_reads = split (/\s/, $line);
		$no_mapped_reads = $mapped_reads[0];
		$mapped_reads_rate = $mapped_reads[4];
		$mapped_reads_rate = substr($mapped_reads_rate, 1);
		print $no_mapped_reads, "\t", $mapped_reads_rate, "\t";

	$line = <>;
	$line = <>;
	$line = <>;

	$line = <>;
		@properly_paired_mapped_reads = split (/\s/, $line); 
		$no_properly_paired_mapped_reads = $properly_paired_mapped_reads[0];
		$properly_paired_mapped_reads_rate = $properly_paired_mapped_reads[5];
		$properly_paired_mapped_reads_rate = substr($properly_paired_mapped_reads_rate, 1);
		print $no_properly_paired_mapped_reads, "\t", $properly_paired_mapped_reads_rate, "\n";


	}else{	

	}

}
