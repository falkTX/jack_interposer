#!/usr/bin/perl

open(CHECKERS, ">checkers.c");

my $fragment = `cat checker_fragment.c`;

while (<STDIN>)
{
	$_ =~ /(.*)\|(.*)\|(.*)\|(.*)/;
	my $returntype = $1;
	my $name = $2;
	my $parameters = $3;
	my $parameternames = $4;

	my $currentFragment = $fragment;
	$currentFragment =~ s/\$returntype/$returntype/gs;
	$currentFragment =~ s/\$name/$name/gs;
	$currentFragment =~ s/\$parameters/$parameters/gs;
	$currentFragment =~ s/\$parameternames/$parameternames/gs;

	print CHECKERS $currentFragment;
}
close(CHECKERS);
