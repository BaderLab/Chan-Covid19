#!/usr/bin/perl

use strict;
use warnings;

my %seqs;
$/ = "\n>"; # read fasta by sequence, not by lines

while (<>) {
    s/>//g;
    my ($seqid, @seq) = split (/\n/, $_);
	#shift @seq;
    my $seq = uc(join "", @seq); # rebuild sequence as a single string
	#print "$seq\n";
    my $len = length $seq;
    my $numA = $seq =~ tr/A//; # removing A's from sequence returns total counts
    my $numC = $seq =~ tr/C//;
    my $numG = $seq =~ tr/G//;
    my $numT = $seq =~ tr/T//;
    my $numN = $seq =~ tr/N//;
    my $numGap = $seq =~ tr/-//;
	# name seqlen A C G T N Gap
    print "$seqid\t";
	print "$len\t";
	print "$numA\t$numC\t$numG\t$numT\t$numN\t$numGap\n";
	#print "$len\n";
	#print "$numN\n";
}
