#!/usr/bin/perl

use strict;
use lib './lib';
use vague;
use Test;

BEGIN {
	plan tests => 13,
}

# I really don't know how to test this module
ok($vague::VERSION);

my @x;

@x = many of qw(a b c d e f g h i j);
ok( @x >= 0 && @x <= 10 );

@x = none of qw(a b c d e f g h i j);
ok( @x >= 0 && @x <= 5 );

my $x;
my $quo = "And did these feet in ancient times, walk upon England's mountains...";
$x = some of $quo;
ok( index($quo, $x) == 0 );

$x = lots of 100;
ok( $x > 10 && $x < 100 );

$x = 0;
probably sub { $x++ };
probably sub { $x++ };
probably sub { $x++ };
probably sub { $x++ };
probably sub { $x++ };
ok( $x > 0 );

$x = 0;
foreach (any qw(a b c d e f g h i j)) {
	$x++;
}
ok( $x == 10 );

$vague::rnd_indexw = -1;
$vague::rnd_index = -1;

$x = random word;
ok( $x eq 'country' || $x eq 'feck!' );

$x = random word;
ok( $x eq 'horizon' || $x eq 'feck!' );

$x = random word;
ok( $x eq 'halibut' || $x eq 'feck!' );


$x = random number;
ok( $x == 4 || int($x) == 3 );

$x = random number;
ok( $x == 8 || int($x) == 3 );

$x = random number;
ok( $x == 6 || int($x) == 3 );