#!/usr/bin/perl -w

use strict;
use lib './lib';
use vague;

my @widgets = qw(a b c d e f g);

print '#' x 72;
print "\n\nExample of vague\n\n";
print '#' x 72;
print "\n\n";

print $vague::VERSION, "\n";

print some of 1,2,3,4,5,6,7,8,9,10;
print "\n";
print nearly all of "And did these feet in ancient time walk upon England's mountains green.";
print "\n";
print hardly any of "And did these feet in ancient time walk upon England's mountains green.";
print "\n";
my $number = roughly 20;
print "roughly $number\n";

$number = almost 20;
print "almost $number\n";

my $x = any @widgets;
print "x is any widget and is $x\n";

print any @widgets;
print "\n";

for (most of 1..20) {
	print "$_ ";
	generally \&foo('hllo');
}

probably sub { foo('prob') };
probably sub { foo('prob') };
probably sub { foo('prob') };
probably sub { foo('prob') };

print "\n";

sub foo {
	my $msg = shift;
	print "In foo msg $msg\n";
}

for (1..30) {
	print random word, " ", random number, "\n";
}
