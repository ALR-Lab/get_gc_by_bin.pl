#!/usr/bin/perl -w
############################################################################################
### Get GC Content By Bin                                                                ###
### Usage: get_gc_by_bin.pl <fasta file>                                                 ###
### This program takes a fasta file as it's first (and only) parameter.                  ###
###                                                                                      ###
### It returns a tab delimited file (filename_gc_bin_out.txt): column 1 = file name of   ###
### the fasta, and column 2 = combined gc content for all records in the file.           ###
###                                                                                      ###
### Jennifer Meneghin                                                                    ###
### November 1, 2018                                                                     ###
############################################################################################

#---------------------------------------------------------------------------------------------------------------------------
#Deal with passed parameters
#---------------------------------------------------------------------------------------------------------------------------
if ($#ARGV == -1) {
    usage();
    exit;
}
$fasta_file = $ARGV[0];
$out_file = $fasta_file . "_gc_bin_out.txt";
unless ( open(IN, "$fasta_file") ) {    
    print "Got a bad fasta file: $fasta_file\n\n";
    exit;
}
unless ( open(OUT, ">$out_file") ) {
    print "Couldn't create $out_file\n";
    exit;
}
print "Parameters:\nfasta file = $fasta_file\noutput file = $out_file\n\n";
#---------------------------------------------------------------------------------------------------------------------------
#The main event
#---------------------------------------------------------------------------------------------------------------------------
print OUT "ID\t% GCContent\tTotal Count\tG Count\tC Count\tA Count\tT Count\n";
print OUT "$fasta_file\t";
$seq = "";
while (<IN>) {
    chomp;
    unless (/^>/) {
	$seq = $seq . $_;
    }
}

print "Process it...\n";
&process_it;

close(IN);
close(OUT);

sub usage {
    print "Get GC Content By Bin\n";
    print "Usage: get_gc_by_bin.pl <fasta file>\n";
    print "This program takes a fasta file as it's first (and only) parameter.\n\n";
    print "It returns a tab delimited file (filename_gc_bin_out.txt): column 1 = file name,\n";
    print "and column 2 = the overall gc content for the entire file.\n";
    print "It also returns the total nucleotide count, along with the number of\n";
    print "A's, G's, C's and T's for the entire fasta file.\n\n";
    print "Jennifer Meneghin\n";
    print "November 1, 2018\n\n";
}

sub process_it {
    @letters = split(//, $seq);
    $gccount = 0;
    $totalcount = 0;
    $acount = 0;
    $tcount = 0;
    $gcount = 0;
    $ccount = 0;
    foreach $i (@letters) {
	if (lc($i) =~ /[a-z]/) {
	    $totalcount++;
	}
	if (lc($i) eq "g" || lc($i) eq "c") {
	    $gccount++;
	}
	if (lc($i) eq "a") {
	    $acount++;
	}
	if (lc($i) eq "t") {
	    $tcount++;
	}
	if (lc($i) eq "g") {
	    $gcount++;
	}
	if (lc($i) eq "c") {
	    $ccount++;
	}
    }
    if ($totalcount > 0) {
	$gccontent = (100 * $gccount) / $totalcount;
    }
    else {
	$gccontent = 0;
    }
    #print "TEST COUNT = $test_count TEST LEN = $test_len\n";
    print OUT "$gccontent\t$totalcount\t$gcount\t$ccount\t$acount\t$tcount\n";
    $seq = "";
}
