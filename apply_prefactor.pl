#! /usr/bin/perl -w
#
# (C) Sebastian Fritsch

use strict;

$_=$0;
s#^.*/##;
my $progname=$_;
my $usage="Usage: $progname [OPTIONS] <in> <out>";

# read program arguments

while ((defined ($ARGV[0])) and ($ARGV[0] =~ /^-./))
{
        if (($ARGV[0] !~ /^--/) and (length($ARGV[0])>2)){
           $_=shift(@ARGV);
           #short opt having agruments examples fo
           if ( $_ =~ /^-[fo]/ ) {
              unshift(@ARGV,substr($_,0,2),substr($_,2));
           }
           else{
              unshift(@ARGV,substr($_,0,2),"-".substr($_,2));
           }
        }
	if (($ARGV[0] eq "-h") or ($ARGV[0] eq "--help"))
	{
		print <<END;
This script calculates the integral of a table
$usage
OPTIONS:
-h, --help            Show this help message


NEEDS:
USES: readin_table saveto_table

END
		exit;
	}
	else
	{
		die "Unknow option '".$ARGV[0]."' !\n";
	}
}

#Print usage
die "no files given\n$usage\n" unless $#ARGV > 0;

use CsgFunctions;


my $do_interpolate = 0;

my $infile="$ARGV[0]";
my @r;
my @val;
my @flag;
(readin_table($infile,@r,@val,@flag)) || die "$progname: error at readin_table\n";

my $outfile="$ARGV[1]";
my @out;

my $prefactor="$ARGV[2]";
my $prefactor_cg = 0;


if (defined $ARGV[3]){
    $prefactor_cg = "$ARGV[3]";
    $do_interpolate = 1;
}

my $min = 0;
my $i=0;

for (;$i<=$#r;$i++){
  $out[$i]=$val[$i]; 
}

if (!$do_interpolate){
    for ($i=0;$i<=$#r;$i++){
    # just multiply
      $out[$i]=$out[$i]*$prefactor;
    }
}
else
{
    for ($i=0;$i<=$#r;$i++){
    # do a linear interpoltation between the prefactors
    
        $out[$i]=$i/$#r*$out[$i]*$prefactor_cg+(1-$i/$#r)*$out[$i]*$prefactor;

    }   
}

saveto_table($outfile,@r,@out,@flag) || die "$progname: error at save table\n";
