#!/usr/bin/perl

# htmlgen.pl
#
# An html we site generator.
#
# Artium Nihamkin 
# sartium@mail.technion.ac.il 
# April 2011
# 
#
# This script generates html pages from template file and 
# content files. Input is a .template file and a path to a 
# directory that contains .content files. The script searches 
# the directory recursively. Creates .html file out of each 
# .content file.
# There are two spcecial tags that a template can contain: [% content %] and [% time %].
# Here is an example of content file (notice the empty line between key-value pairs and main 
# content):
# 
## 	bgcolor = red
##	title = Some funny title
##	
##	Main content start here<br>
##	<img src="image.jpg">
#
# A template file may look like this
#
##	<html>
##	<head><title>[% title %]</title>
##	<body bgcolor = [% bgcolor %]>
##	[% content %]
##	<small>Last update: [% time %]</small>
## 	</body></html>
##

use strict;
use warnings;
use File::Find;

if (!@ARGV) {usage()};

sub usage
{
    die "Usage: $0 [template_file] [root]\n";    
}


# Load template file we load it once and save it in a variable
open(TemplateFile, "<", $ARGV[0])
    or die "Couldn't open file [$_[0]]: $!";
my @template = <TemplateFile>;
close (TemplateFile);


# Perform action on all files
find(\&do_for_all_files, $ARGV[1]);


sub do_for_all_files
{
    if(-f and m/.*\.content$/) {
		my $filename = $_;
		$filename =~ s/\.content$/\.html/;
		print "$0: Generating file $filename\n";
		perform_substitution($_, $filename);
    }
}

sub perform_substitution
{
    # Load key-value pairs from content file
    open(ContentFile, "<", $_[0])
	or die "Couldn't open file [$_[0]]: $!";
    my %replace = ();       
    while (<ContentFile>) {
		if (/^\s*$/) {last;}
		chomp;
		(my $key, my $value) = split /\s*=\s*/, $_, 2;
		$replace{$key} = $value;
    }

    while (<ContentFile>) {
		$replace{"content"} .= $_;
    }
    $replace{"time"} = scalar localtime;
    close (ContentFile);
    
    # Perform replacement and write to destination file
    my $to_replace = qr/@{["\\[\\%\\s*(" .
			   join("|" => map quotemeta($_), keys %replace) .
			   ")\\s*\\%\\]"]}/;
    open(DestinationFile, ">", $_[1]) 
	or die "Couldn't open file [$_[0]]: $!";
    foreach (@template) {
		(my $templine = $_) =~ s/$to_replace/$replace{$1}/g;
	     
		$templine =~ s/\[\%\s*time\s*\%\]/$replace{"time"}/g;  # Content may contain [% time %] tag as well
		print DestinationFile $templine;
    }
    close(DestinationFile);
}
